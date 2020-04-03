#Folder migration script. Written by Jeremy Dixon
#Modified on January 29th 2019
#Version 1.2

#User input section

Param(
 [Parameter(Mandatory=$True,Position=1)]
 [string]$sd,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$dd,
  [Parameter(Mandatory=$True,Position=2)]
  [string]$filter
  )

write-host "Script will scan the  source directory you entered and run robocopy against each sub folder and continue until no folder are found matching our criteria." -BackgroundColor "Green" -ForegroundColor "Black"

####################################### MAIN SCRIPT #####################################################

#test that source and destination paths are reachable
$FolderExists = Test-Path $sd 
If ($FolderExists -ne $True) {Write-Host "ERROR: Source path not reachable. Fix issue and rerun script." -fore Yellow -back Black; Break }

$FolderExists = Test-Path $dd 
If ($FolderExists -ne $True) {Write-Host "ERROR: Destination path not reachable. Fix issue and rerun script." -fore Yellow -back Black; Break }

#Loop  until no folders are found matching our criteria.

Do {

        #Sleep for 60 seconds between runs
        Start-Sleep -s 60

        #define date
        $startdate=Get-Date -format M-dd-yyyy-HHmmss 
        $date=Get-Date -format M-dd-yyyy

        #create directory based on date
        New-Item D:\scripts\logs\$date -type directory -ErrorAction SilentlyContinue | Out-Null

        #log directory
        $logdir="D:\scripts\logs\"+ $date + "\"

        #test if log directory is created.
        $FolderExists = Test-Path $logdir 
        If ($FolderExists -ne $True){Write-Host "ERROR: Log folder not found. Fix the issue and rerun script." -fore Yellow -back Black; Break }

        #Start logging all screen output
        Start-Transcript -Path $logdir\$startdate-$filter.txt
  
        #grab all sub directories that start with $filter and exclude any folder that has "_" in the name.
        $sfolders = get-childitem -Path $sd -Exclude *_* | ? {$_.Name -Like "$filter*"}

        $date=Get-Date -format M-dd-yyyy-HHmmss

         If ($sfolders.count -ne "0"){ Write-Host $date":Running Robocopy for " $sfolders.count " folders found in $sd" -BackgroundColor "Green" -ForegroundColor "Black" }

         foreach($source in $sfolders) 
         {
           #build full path to source
           $source = $source.name
           $sfolder = $sd + $source

           #build full path to destination
           $dfolder = $dd + $source

           $log=$logdir + $source + ".log"

           $date=Get-Date -format M-dd-yyyy-HHmmss
           Write-Host $date":Starting robocopy for " $source -fore Green -back Black

           robocopy $sfolder $dfolder /E /XO /dcopy:T /COPY:DATS /MT:32 /tee /MT:32 /R:0 /W:0
         }
    #Write output to log file.
    Stop-Transcript

} while ($sfolders.count -ne 0)

$date=Get-Date -format M-dd-yyyy-HHmmss
Write-Host $date":Robocopy job for all subdirectories of:" $sd " Complete" -fore Green -back Black
