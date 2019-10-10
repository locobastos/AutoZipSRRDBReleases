# Auto Zip SRRDB Releases

## Note before continuing
This script is enough for my personnal use, but need to be enhanced to be generally used:
- using .ini file for the config part
- asking srrdb team the download limit per day, to avoid useless HTTP request

## Prerequisite
You'll need to disable PowerShell protection:

    PS> Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

Please read this article before: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-6

This script uses these softwares:
- cfv : https://sourceforge.net/projects/cfv/files/cfv/
- srr : https://bitbucket.org/Gfy/pyrescene/downloads/
- 7-Zip : https://www.7-zip.org/download.html

You'll need to modify the script to change these variables:
* $extracted_dir: Where all the subfolders are located.
* $zip_dir: Where you want to store the zipped files.
* $not_found_srrdb_dir: Where you want to store the scene subfolders that do not exist on srrdb.com.
* $error_folder: Where you want to store all subfolders when an error occurs (sfv check error, srr extract error...)
* $srr_exe: srr.exe file location
* $cfv_exe: cfv.exe file location
* $7z_exe: 7z.exe file location

## Use Case
Imagine you have a folder and inside this folder, you have many subfolders (I had more than 21K folders when I've created this script).
One scene release per subfolder, example:

```
___SCENE_RELEASES___
|-- Aanalog_System_-_Strange_Morning_In_December-Vinyl-2001-KTMP3
    |-- 01-analog_system_-_strange_morning_in_december_a1(kaylab_remix)-ktmp3.mp3
    |-- 02-analog_system_-_strange_morning_in_december_b1(original_mix)-ktmp3.mp3
|-- A.Hat.in.Time.Seal.the.Deal.Update.v20180914-CODEX
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.rar
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r00
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r01
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r02
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r03
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r04
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r05
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r06
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r07
    |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.r08
```

## Script description
This script does:
1) Download the .srr file from srrdb.com:
    
    https://www.srrdb.com/download/srr/release_folder_name_here

2) Extract the stored files into the subfolder:
```
    |-- A.Hat.in.Time.Seal.the.Deal.Update.v20180914-CODEX
        |-- codex.nfo
        |-- codex-a.hat.in.time.seal.the.deal.update.v20180914.sfv
        ...snip...
```
3) Check the checksums with the extracted .sfv file.
4) Zip everything into a .zip file, including the .srr file.
5) Deleting the non-zipped files.

## Output example
```
==================================================================================================
Working on Evil_Minded_Vs_Ginger_Kommander-Old_School-WEB-2009-iWD
Download the SRR file from SRRDB
Extracting all files from SRR...
00-evil_minded_vs_ginger_kommander-old_school-web-2009-iwd.nfo: extracted.
00-evil_minded_vs_ginger_kommander-old_school-web-2009-iwd.jpg: extracted.
00-evil_minded_vs_ginger_kommander-old_school-web-2009-iwd.m3u: extracted.
00-evil_minded_vs_ginger_kommander-old_school-web-2009-iwd.sfv: extracted.
01-evil_minded_vs_ginger_kommander-old_school_(extended).srs: extracted.
Entering into the folder...
Checking the checksums with the SFV file...
00-evil_minded_vs_ginger_kommander-old_school-web-2009-iwd.sfv: 1 files, 1 OK.  0.180 seconds, 81638.9K/s
Creating the ZIP file...

7-Zip 19.00 (x64) : Copyright (c) 1999-2018 Igor Pavlov : 2019-02-21

Scanning the drive:
1 folder, 7 files, 15613609 bytes (15 MiB)

Creating archive: Evil_Minded_Vs_Ginger_Kommander-Old_School-WEB-2009-iWD.zip

Add new data to archive: 1 folder, 7 files, 15613609 bytes (15 MiB)


Files read from disk: 7
Archive size: 14354058 bytes (14 MiB)
Everything is Ok
Deleting files...
==================================================================================================
```
