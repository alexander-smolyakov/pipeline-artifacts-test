<#
    .SYNOPSIS
        Check files extension in the folder by the whitelist.
    .DESCRIPTION
        The "Download Build Artifacts" task allows us to download files from 
        several Build Artifacts that are matched some patterns. To test this 
        functionality we download several files with the specified extensions 
        and this script validates the results of the download.
#>

param (
    # Path to the folder 
    [string]$pathToFolder,
    
    # Array of allowed file extensions
    # Pattern: .<extension>
    # Example: -WhitelistedExtensions ".cpp",".hpp"
    [String[]]$whitelistedExtensions
)

try {
    if ([string]::IsNullOrEmpty($pathToFolder)) {
        throw "Path to the folder is empty"
    }

    if ($whitelistedExtensions.Count -eq 0) {
        throw "Extensions whitelist is empty"
    }

    Write-Host "##[command]Check files in $pathToFolder by following whitelist: $whitelistedExtensions"

    $suspicious_files = Get-ChildItem "$pathToFolder" -Recurse | where-object { 
        (-not $whitelistedExtensions.Contains([IO.Path]::GetExtension($_))) -and (-not $_.PSIsContainer)
    }

    if ($suspicious_files) {
        Write-Host "##vso[task.logissue type=error;]The folder contains some not whitelisted items - Check failed"

        Write-Output "Extensions whitelist:"
        Write-Output $whitelistedExtensions

        Write-Output "Suspicious files:"
        Write-Output $suspicious_files

        Write-Output "Content of $pathToFolder"
        $folderContent = Get-ChildItem "$folderDifference" -Recurse -Name | where-object { -not $_.PSIsContainer }
        Write-Output $folderContent

        Write-Host "##vso[task.complete result=Failed]Test failed"
    }
    else {
        Write-Output "##[section]All files are passed validation - Check passed"
    }
}
catch {
    Write-Host "##vso[task.logissue type=error;]An error occurred: $_"
    Write-Output "##vso[task.complete result=Failed;]Test failed"
}

exit $LASTEXITCODE
