##############
## Global variables
##############
$pathToGeneratedArtifact = "D:\Azure DevOps\self-hosted agents\v-alsmo\Agent-2\_work\3\s"
$pathToDownloadedArtifact = "D:\Azure DevOps\self-hosted agents\v-alsmo\Agent-2\_work\3\a"

#$pathToGeneratedArtifact = "$(Build.SourcesDirectory)";
#$pathToDownloadedArtifact = "$(System.ArtifactsDirectory)";

##############
## Functions
##############
function compareFolders ($folderReference, $folderDifferenc){
    $FolderReferenceContents = Get-ChildItem $folderReference -Recurse | where-object {-not $_.PSIsContainer}
    $FolderDifferenceContents = Get-ChildItem $folderDifference -Recurse | where-object {-not $_.PSIsContainer}

    return $CheckResult = Compare-Object -ReferenceObject $FolderReferenceContents -DifferenceObject $FolderDifferenceContents -Property ('Name', 'Length');
}

##############
## Test Case 1
##############
$TestCaseName = "Test Case 1 (OnlySourceFiles)"
echo "Check relesut of $TestCaseName" 

$folderReference = -join($pathToGeneratedArtifact, "\TestCases\SourceFiles"); 
$folderDifference = -join($pathToDownloadedArtifact, "\TestCases\1_OnlySourceFiles\Artifact_SourceFiles");
$CheckResult = compareFolders -folderReference $folderReference -folderDifference $folderDifference 

if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}

##############
## Test Case 2
##############
$TestCaseName = "Test Case 2 (OnlyHeaderFiles)"
echo "Check relesut of $TestCaseName" 

$folderReference = -join($pathToGeneratedArtifact, "\TestCases\HeaderFiles");
$folderDifference =  -join($pathToDownloadedArtifact, "\TestCases\2_OnlyHeaderFiles\Artifact_HeaderFiles");

$CheckResult = compareFolders -folderReference $folderReference -folderDifference $folderDifference 
if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}

##############
## Test Case 3
##############
$TestCaseName = "Test Case 3 (OnlyCFiles)"
$CheckResult = $null;
echo "Check relesut of $TestCaseName" 

$folder = -join($pathToDownloadedArtifact, "\TestCases\3_OnlyCFiles");

$files = Get-ChildItem $folder -Recurse | where-object {-not $_.PSIsContainer} 

foreach ($file in $files){
    $extension = [IO.Path]::GetExtension($file)
    if ($extension -ne ".c") {
    $CheckResult = "Error";
    }
}

if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}

##############
## Test Case 4
##############
$TestCaseName = "Test Case 4 (OnlyHPPFiles)"
$CheckResult = $null;
echo "Check relesut of $TestCaseName" 

$folder = -join($pathToDownloadedArtifact, "\TestCases\4_OnlyHPPFiles");

$files = Get-ChildItem $folder -Recurse | where-object {-not $_.PSIsContainer} 

foreach ($file in $files){
    $extension = [IO.Path]::GetExtension($file)
    if ($extension -ne ".hpp") {
    $CheckResult = "Error";
    }
}

if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}

##############
## Test Case 5
##############
$TestCaseName = "Test Case 5 (CppFiles)"
$CheckResult = $null;
echo "Check relesut of $TestCaseName" 

$folder = -join($pathToDownloadedArtifact, "\TestCases\5_CppFiles");

$files = Get-ChildItem $folder -Recurse | where-object {-not $_.PSIsContainer} 

foreach ($file in $files){
    $extension = [IO.Path]::GetExtension($file)
    if ($extension -eq ".cpp" -or $extension -eq ".hpp") {
    continue;
    } else {
    $CheckResult = "Error";
    }
}

if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}


##############
## Test Case 6
##############
$TestCaseName = "Test Case 6 (CFiles)"
$CheckResult = $null;
echo "Check relesut of $TestCaseName" 

$folder = -join($pathToDownloadedArtifact, "\TestCases\6_CFiles");
$files = Get-ChildItem $folder -Recurse | where-object {-not $_.PSIsContainer} 

foreach ($file in $files){
    $extension = [IO.Path]::GetExtension($file)
    if ($extension -eq ".c" -or $extension -eq ".h") {
    continue;
    } else {
    $CheckResult = "Error";
    }
}

if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}

##############
## Test Case 7
##############
$TestCaseName = "Test Case 7 (AllFiles)"
echo "Check relesut of $TestCaseName" 

$folderReference = -join($pathToGeneratedArtifact, "\TestCases\");
$folderDifference =  -join($pathToDownloadedArtifact, "\TestCases\7_AllFiles\");

$CheckResult = $CheckResult = compareFolders -folderReference $folderReference -folderDifference $folderDifference
if ($CheckResult) {
    echo "$TestCaseName - failed"
} else {
    echo "$TestCaseName - passed"
}