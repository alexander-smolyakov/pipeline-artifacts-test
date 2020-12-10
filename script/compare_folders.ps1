##############
## Global variables
##############
$pathToGeneratedArtifact = "$(Build.SourcesDirectory)";
$pathToDownloadedArtifact = "$(System.ArtifactsDirectory)";

$folderReference = -join($pathToGeneratedArtifact, "\TestCases\SourceFiles"); 
$folderDifference = -join($pathToDownloadedArtifact, "\TestCases\1_OnlySourceFiles\Artifact_SourceFiles");

$FolderReferenceContents = Get-ChildItem $folderReference -Recurse | where-object {-not $_.PSIsContainer}
$FolderDifferenceContents = Get-ChildItem $folderDifference -Recurse | where-object {-not $_.PSIsContainer}
$CheckResult = Compare-Object -ReferenceObject $FolderReferenceContents -DifferenceObject $FolderDifferenceContents -Property ('Name', 'Length');

if ($CheckResult) {
    Write-Host Folders are differs
    Write-Host $CheckResult
    Write-Host ##vso[task.complete result=Failed] Check failed 
} else {
    Write-Host ##vso[task.complete result=Succeeded;] Check passed
}

