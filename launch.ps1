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
    $portOption = @("-p", "0.0.0.0:8000:8000")
}

# Detect if running in WSL or native Windows
$isWSL = Test-Path "/proc/version" -and (Get-Content "/proc/version" -ErrorAction SilentlyContinue) -match "microsoft"

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
