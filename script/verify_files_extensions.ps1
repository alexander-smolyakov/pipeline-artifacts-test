param ($pathToTestCase, [String[]]$WhitelistedExtensions);

try {
    $isValid = $false;
    $folder = "$pathToTestCase";
    $files = Get-ChildItem $folder -Recurse | where-object { -not $_.PSIsContainer } 

    if ($files.count -eq 0) {
        echo "Path to the folder: $folder"
        throw "Empty file list"
    }

    $files_filtered = Get-ChildItem $folder -Recurse | where-object { 
        $WhitelistedExtensions.Contains([IO.Path]::GetExtension($_));
    }

    echo "files_filtered = $files_filtered" 


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
        echo "All files are passed validation"
        echo "Check passed"
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
