param ($pathToTestCase, [String[]]$WhitelistedExtensions);

try {
    $isValid = $false;
    $folder = "$pathToTestCase";
    $files = Get-ChildItem $folder -Recurse | where-object { -not $_.PSIsContainer } 

    if ($files.count -eq 0) {
        Write-Output "Path to the folder: $folder"
        throw "Empty file list"
    }

    $files_filtered = Get-ChildItem $folder -Recurse | where-object { 
        $WhitelistedExtensions.Contains([IO.Path]::GetExtension($_));
    }

    Write-Output "files_filtered = $files_filtered" 


    foreach ($file in $files) {
        $extension = [IO.Path]::GetExtension($file);
        
        if ($WhitelistedExtensions.Contains($extension)) {
            $isValid = $true;
        }
        else {
            $isValid = $false;
            Write-Host "The $extension extension is not whitelisted"
            break;
        }
    }

    if ($isValid) {
        Write-Output "All files are passed validation"
        Write-Output "Check passed"
    }
    else {
        Write-Host "##vso[task.complete result=Failed] Check failed"
    }
}
catch {
    Write-Host "An error occurred:"
    Write-Host $_
    Write-Host "##vso[task.complete result=Failed] Check failed"
}

exit $LASTEXITCODE
