#!/usr/bin/env pwsh

param(
    [Parameter(Position=0)]
    [string]$IMAGE
)

# Get available images from dockerfiles directory
$IMAGES = Get-ChildItem -Path "dockerfiles" -Filter "*.docker" | ForEach-Object { $_.BaseName }

function Show-Images {
    Write-Host "Available images are: $($IMAGES -join ', ')"
    exit 1
}

# Missing argument
if (-not $IMAGE) {
    Write-Host "Missing name of the image to create or container to launch!"
    Show-Images
}

# Check if the provided image name is valid
if ($IMAGE -notin $IMAGES) {
    Write-Host "Name of the image to create or container to launch is not known!"
    Write-Host "The name should be one of these:"
    Show-Images
}

# Checking if the image exists
$imageExists = docker images --format "{{.Repository}}" | Select-String -Pattern "^${IMAGE}$" -Quiet

if ($imageExists) {
    Write-Host "Image already exists!"
} else {
    Write-Host "Fixing line endings before build..."
    & "$PSScriptRoot/fix-line-endings.ps1"

    Write-Host "Building the image..."
    docker build -f "./dockerfiles/${IMAGE}.docker" . --tag "${IMAGE}:devel"
}

# Checking if an associated volume exists
$volumeExists = docker volume ls --format "{{.Name}}" | Select-String -Pattern "^${IMAGE}$" -Quiet

if ($volumeExists) {
    Write-Host "Volume already exists"
} else {
    Write-Host "Creating volume!"
    docker volume create $IMAGE
}

Write-Host "Launching the container..."

# Display Windows Explorer path to access the Docker volume
# Try different path formats for compatibility
$volumePaths = @(
    "\\wsl$\docker-desktop-data\data\docker\volumes\${IMAGE}\_data",
    "\\wsl$\docker-desktop-data\version-pack-data\community\docker\volumes\${IMAGE}\_data"
)

$volumePath = $null
foreach ($path in $volumePaths) {
    if (Test-Path $path -ErrorAction SilentlyContinue) {
        $volumePath = $path
        break
    }
}

if ($volumePath) {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "Docker volume accessible in Windows Explorer"
    Write-Host "Path: $volumePath"
    Write-Host ""
    Write-Host "Opening volume folder in Windows Explorer..."
    Start-Process explorer.exe -ArgumentList $volumePath
    Write-Host "========================================"
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "========================================"
    Write-Host "To access the Docker volume in Windows Explorer:"
    Write-Host "1. Open File Explorer"
    Write-Host "2. Type in address bar: \\wsl$\"
    Write-Host "3. Navigate to: docker-desktop-data\data\docker\volumes\${IMAGE}\_data"
    Write-Host "   (or try: docker-desktop-data\version-pack-data\community\docker\volumes\${IMAGE}\_data)"
    Write-Host "========================================"
    Write-Host ""
}

# Get current directory path (convert to Unix-style for Docker)
$currentPath = (Get-Location).Path
# Convert Windows path to Docker-compatible path
$dockerPath = $currentPath -replace '\\', '/'
if ($dockerPath -match '^([A-Za-z]):') {
    $dockerPath = $dockerPath -replace '^([A-Za-z]):', '/$1'
}

# Port option for neo-h
$portOption = @()
if ($IMAGE -eq "neo-h") {
    $portOption = @("-p", "0.0.0.0:8000:8000", "-p", "0.0.0.0:1986:2222")
}

# Detect if running in WSL or native Windows
$isWSL = (Test-Path "/proc/version") -and ((Get-Content "/proc/version" -ErrorAction SilentlyContinue) -match "microsoft")

# Configure X11 based on environment
if ($isWSL) {
    # WSL environment - use WSLg
    Write-Host "Detected WSL environment - using WSLg"
    $x11Volumes = @(
        "-v", "/tmp/.X11-unix:/tmp/.X11-unix",
        "-v", "/mnt/wslg:/mnt/wslg"
    )
    $displayVar = $env:DISPLAY
} else {
    # Native Windows - use VcXsrv
    Write-Host "Detected Windows environment - configuring for VcXsrv"

    # Check if VcXsrv is already running
    $vcxsrvRunning = Get-Process -Name "vcxsrv" -ErrorAction SilentlyContinue

    if (-not $vcxsrvRunning) {
        Write-Host "VcXsrv not running. Starting VcXsrv..."

        # Try to find VcXsrv executable
        $vcxsrvPaths = @(
            "C:\Program Files\VcXsrv\vcxsrv.exe",
            "C:\Program Files (x86)\VcXsrv\vcxsrv.exe",
            "${env:ProgramFiles}\VcXsrv\vcxsrv.exe",
            "${env:ProgramFiles(x86)}\VcXsrv\vcxsrv.exe",
            "${env:LOCALAPPDATA}\Programs\VcXsrv\vcxsrv.exe",
            "${env:APPDATA}\Programs\VcXsrv\vcxsrv.exe"
        )

        $vcxsrvExe = $vcxsrvPaths | Where-Object { Test-Path $_ } | Select-Object -First 1

        # If not found in standard paths, try to find it via shortcut
        if (-not $vcxsrvExe) {
            $shortcutPath = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\VcXsrv\XLaunch.lnk"
            if (Test-Path $shortcutPath) {
                $shell = New-Object -ComObject WScript.Shell
                $shortcut = $shell.CreateShortcut($shortcutPath)
                $vcxsrvDir = Split-Path $shortcut.TargetPath
                $vcxsrvExe = Join-Path $vcxsrvDir "vcxsrv.exe"
                if (-not (Test-Path $vcxsrvExe)) {
                    $vcxsrvExe = $null
                }
            }
        }

        if ($vcxsrvExe) {
            # Launch VcXsrv with proper settings (multiwindow, clipboard, DPI auto-detection)
            Start-Process -FilePath $vcxsrvExe -ArgumentList ":0 -multiwindow -clipboard -wgl -ac -dpi auto" -WindowStyle Hidden
            Write-Host "VcXsrv started. Waiting for initialization..."
            Start-Sleep -Seconds 3
        } else {
            Write-Host "ERROR: VcXsrv not found. Please install VcXsrv from:"
            Write-Host "https://sourceforge.net/projects/vcxsrv/"
            exit 1
        }
    } else {
        Write-Host "VcXsrv is already running"
    }

    $x11Volumes = @()
    $displayVar = "host.docker.internal:0.0"
}

# Build docker run command
$dockerArgs = @(
    "run",
    "--rm",
    "-d",
    "--cpus=8",
    "-it",
    "-v", "${dockerPath}/ssh:/tmp/ssh:ro",
    "-v", "${IMAGE}:/vol"
)

# Add X11 volumes if in WSL
if ($x11Volumes.Count -gt 0) {
    $dockerArgs += $x11Volumes
}

# Add environment variables
$dockerArgs += @(
    "-e", "TERM=xterm-256color",
    "-e", "DISPLAY=$displayVar"
)

# Add DPI settings for better resolution (especially for Windows/VcXsrv)
if (-not $isWSL) {
    $dockerArgs += @(
        "-e", "GDK_SCALE=1",
        "-e", "GDK_DPI_SCALE=1.5",
        "-e", "QT_SCALE_FACTOR=1.5"
    )
}

# Add WSL-specific environment variables if in WSL
if ($isWSL) {
    $dockerArgs += @(
        "-e", "WAYLAND_DISPLAY=${env:WAYLAND_DISPLAY}",
        "-e", "XDG_RUNTIME_DIR=${env:XDG_RUNTIME_DIR}",
        "-e", "PULSE_SERVER=${env:PULSE_SERVER}"
    )
}

# Add port option if needed
if ($portOption.Count -gt 0) {
    $dockerArgs += $portOption
}

# Add Docker-in-Docker support (optional - uncomment if needed)
# Note: This requires Docker Desktop to be configured appropriately
# $dockerArgs += @(
#     "-v", "//var/run/docker.sock:/var/run/docker.sock",
#     "-v", "//usr/bin/docker:/usr/bin/docker"
# )

# Add image name
$dockerArgs += "${IMAGE}:devel"

# Run the container
& docker $dockerArgs
