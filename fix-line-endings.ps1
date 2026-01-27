#!/usr/bin/env pwsh
# Fix line endings - convert CRLF to LF

Write-Host "Fixing line endings in otherfiles and ssh directories..."

$directories = @("otherfiles", "ssh")
$utf8NoBom = New-Object System.Text.UTF8Encoding $false

foreach ($dir in $directories) {
    if (Test-Path $dir) {
        $files = Get-ChildItem -Path $dir -File -Recurse

        foreach ($file in $files) {
            Write-Host "Processing: $($file.FullName)"
            $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
            if ($content) {
                $content = $content -replace "`r`n", "`n"
                [System.IO.File]::WriteAllText($file.FullName, $content, $utf8NoBom)
            }
        }
    }
}

Write-Host "Done! All files converted to Unix line endings (LF)"
