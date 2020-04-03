#set the certificate validation for entire XIO session. Ignore all certificates
Set-XtremTrustAllCertsPolicy | Out-Null
#create the session to XIO management server

$xiom = "xiom01pi04lv.corp.nm.org"
$user = "admin"
$pass = "Xtrem10"
$xioclu ="QTS-GP02-X2-02"
$array = @()

New-XtremSession -XmsName $xiom -Username $user -Password $pass -XtremClusterName $xioclu

$volumes = import-csv 'C:\Users\nm184804\Desktop\scripts\QTS Cerner Lun Creation.csv'

foreach ($volume in $volumes) 
{

$volinfo = Get-XtremVolume -XtremClusterName $xioclu -VolName $volume.Name

$volnaa += $volinfo.'naa-name'


$array += $volinfo.'naa-name'

}

$array | Out-File 'C:\Users\nm184804\Desktop\scripts\QTS Cerner Lun Creation naa2.txt'


