$extracted_dir = dir V:\___SCENE___\___EXTRACTED___ | ?{$_.PSISContainer}
$zip_dir = 'V:\___SCENE___\___ZIP___'
$not_found_srrdb_dir = 'V:\___SCENE___\___NOT_FOUND_SRRDB___'
$error_folder = 'V:\___SCENE___\___ERROR___'

$srr_exe = 'D:\LiberKey\MyApps\ReScene\srr.exe'
$cfv_exe = 'D:\LiberKey\MyApps\cfv\cfv.exe'
$7z_exe  = 'C:\Program Files\7-Zip\7z.exe'

cd 'V:\___SCENE___\___EXTRACTED___'

foreach ($current_folder in $extracted_dir){
	Write-Host "=================================================================================================="
	Write-Host "Working on $current_folder"
	$download_url = "https://www.srrdb.com/download/srr/" + $current_folder.Name
	$srr_file = $current_folder.Name + ".srr"
	$sfv_file = (Get-ChildItem -Path $current_folder.FullName -Name *.sfv)
	$zip_file = $current_folder.Name + ".zip"
	Write-Host "Download the SRR file from SRRDB"
	try {
		$response = Invoke-WebRequest -Uri $download_url -OutFile $srr_file
	} catch {
		Write-Host "`nERROR while downloading SRR file`n" -ForegroundColor Red
		switch ($_.Exception.Response.StatusCode.Value__) {
			404 {
				Write-Host "Release not existing on SRRDB, moving release..." -ForegroundColor Red
				Move-Item -Path $current_folder.FullName -Destination $not_found_srrdb_dir
			}
			429 {
				Write-Host "Too many requests, slepping for 1 hour..." -ForegroundColor Red
				Start-Sleep -Seconds 90000
			}
		}
		continue
	}

	Write-Host "Extracting all files from SRR..."
	& $srr_exe @('-x', $srr_file, '-o', $current_folder.Name, '-y')
	if ($LASTEXITCODE -ne 0) {
		Write-Host "`nERROR during SRR extraction`n" -ForegroundColor Red
		Write-Host "Moving release..." -ForegroundColor Red
		Move-Item -Path $current_folder.FullName -Destination $error_folder
		Move-Item -Path $srr_file -Destination $error_folder
		continue
	}

	Write-Host "Entering into the folder..."
	cd $current_folder.FullName

	Write-Host "Checking the checksums with the SFV file..."
	& $cfv_exe @('-f', $sfv_file)
	if ($LASTEXITCODE -ne 0) {
		Write-Host "`nERROR during SFV check`n" -ForegroundColor Red
		Write-Host "Moving release..." -ForegroundColor Red
		cd ..
		Move-Item -Path $current_folder.FullName -Destination $error_folder
		Move-Item -Path $srr_file -Destination $error_folder
		continue
	}

	Write-Host "Creating the ZIP file..."
	cd ..
	& $7z_exe @('a', '-tzip', $zip_file, $current_folder, $srr_file)
	if ($LASTEXITCODE -ne 0) {
		Write-Host "`nERROR during ZIP creation`n" -ForegroundColor Red
		Write-Host "Moving release..." -ForegroundColor Red
		Move-Item -Path $current_folder.FullName -Destination $error_folder
		Move-Item -Path $srr_file -Destination $error_folder
		continue
	}
	Move-Item -Path $zip_file -Destination $zip_dir

	Write-Host "Deleting files..."
	Remove-Item -Force -Recurse $current_folder.FullName
	Remove-Item -Force $srr_file
}
