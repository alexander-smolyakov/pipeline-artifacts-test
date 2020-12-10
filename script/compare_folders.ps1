param ($pathToGeneratedArtifact, $pathToDownloadedArtifact, $reference, $difference);
try {
    $folderReference = -join($pathToGeneratedArtifact, $reference); 
    $folderDifference = -join($pathToDownloadedArtifact, $difference);
    
    $FolderReferenceContents = Get-ChildItem $folderReference -Recurse | where-object {-not $_.PSIsContainer}
    $FolderDifferenceContents = Get-ChildItem $folderDifference -Recurse | where-object {-not $_.PSIsContainer}

    $CheckResult = Compare-Object -ReferenceObject $FolderReferenceContents -DifferenceObject $FolderDifferenceContents -Property ('Name', 'Length');
    
    if ($CheckResult) {
        Write-Host "Folders are differs"
        Write-Host $CheckResult
        Write-Host "##vso[task.complete result=Failed] Check failed"
    } else {
        echo "Folders are identical "
        echo "Check passed"
    }
} catch {
    Write-Host "An error occurred:"
    Write-Host $_
    Write-Host "##vso[task.complete result=Failed] Check failed"
}

exit $LASTEXITCODE
