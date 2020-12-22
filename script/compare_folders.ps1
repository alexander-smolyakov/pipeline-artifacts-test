<#
    .SYNOPSIS
        Compare original folder with downloaded folder.
    .DESCRIPTION
        To check the results of the "Download Build Artifacts" task
        we need to validate what exactly was downloaded by the task.
#>

param (
    # Path to the original folder
    $folderReference, 
    
    # Path to the downloaded folder
    $folderDifference
)

try { 
    Write-Host "##[command]Compare folder $folderReference with $folderDifference"

    $FolderReferenceContents = Get-ChildItem $folderReference -Recurse | where-object { -not $_.PSIsContainer }
    $FolderDifferenceContents = Get-ChildItem $folderDifference -Recurse | where-object { -not $_.PSIsContainer }

    $CheckResult = Compare-Object -ReferenceObject $FolderReferenceContents -DifferenceObject $FolderDifferenceContents -Property ('Name', 'Length');

    if ($CheckResult) {
        Write-Host "##vso[task.logissue type=error;]Folders are differs - Check failed"
        Write-Output $CheckResult

        Write-Output "Reference folder:"
        Write-Output $FolderReferenceContents

        Write-Output "Difference folder:"
        Write-Output $FolderDifferenceContents

        Write-Output "##vso[task.complete result=Failed;] Test failed"
    }
    else {
        Write-Output "##[section]Folders are identical - Check passed"
    }
}
catch {
    Write-Host "##vso[task.logissue type=error;]An error occurred: $_"
    Write-Output "##vso[task.complete result=Failed;] Test failed"
}

exit $LASTEXITCODE
