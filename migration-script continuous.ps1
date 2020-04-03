#Folder migration script. Written by Jeremy Dixon
#Modified on January 8th 2019
#Version 1.1

#User input section

Param(
 [Parameter(Mandatory=$True,Position=1)]
 [string]$sd,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$dd,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$filter
  )


write-host "Script will scan the directory you entered and run robocopy against each sub folder and continue until you interupt the script with control-c or close the powershell window."
#write-Host -Object ('The key that was pressed was: {0}' -f [System.Console]::ReadKey().Key.ToString());

#endless loop
$continue = "No"

####################################### MAIN SCRIPT #####################################################

#Loop to continue and cycle back through every file again until user interupts the script.

#define date
$startdate=Get-Date -format M-dd-yyyy-HHmmss 
$date=Get-Date -format M-dd-yyyy

#create directory based on date
New-Item D:\scripts\logs\$date -type directory -ErrorAction SilentlyContinue | Out-Null
New-Item D:\scripts\logs\$date\failure -type directory -ErrorAction SilentlyContinue | Out-Null
New-Item D:\scripts\logs\$date\successful -type directory -ErrorAction SilentlyContinue | Out-Null
#log directory
$logdir="C:\scripts\logs\"+ $date + "\"

###test if log directory is created.
#$FolderExists = Test-Path $logdir 
#If ($FolderExists -ne $True){Write-Host "ERROR: Log folder not found. Fix the issue and rerun script." -fore Yellow -back Black; Break }

#test that source and destination paths are reachable
$FolderExists = Test-Path $sd 
If ($FolderExists -ne $True) {Write-Host "ERROR: Source path not reachable. Fix issue and rerun script." -fore Yellow -back Black; Break }

$FolderExists = Test-Path $dd 
If ($FolderExists -ne $True) {Write-Host "ERROR: Destination path not reachable. Fix issue and rerun script." -fore Yellow -back Black; Break }

    #grab all sub directories that start with include and exclude anything that has _OLD at end of name.
    $sfolders = get-childitem -Path $sd -Include $filter* -Exclude *_

    foreach($source in $sfolders) 
     {
        #build full path to source
        $source = $source.name
        $sfolder = $sd + $source

        #build full path to destination
        $dfolder = $dd + $source

        $log=$logdir + $source + ".log"

        robocopy $sfolder $dfolder /E /XO /dcopy:T /COPY:DAT /MT:32 /tee /MT:32 /R:0 /W:0


     
     }

