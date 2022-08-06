$users = Get-Content C:\temp\failedusers.txt

foreach ( $user in $users) {

$log= "c:\rights\" + $user + ".txt"
$fullname = "I:\users\" + $user
#$user = $_.basename
$commandDetails = $env:USERDNSDOMAIN + "\" + $user + ":" + "(OI)(CI)F"

$user
#icacls $fullname /save $log /q /l /c /t
$resultatOwner = icacls $fullname /setowner $env:USERDNSDOMAIN\$user /t /c /l /q
#$resultatRights = icacls $fullname /grant:r $commandDetails /c /q
#$resultatReset = icacls $fullname* /reset /t /c /q /l
$user + " Owner : " + $resultatOwner >>c:\temp\icacls2.log 
#$user + " Rights : " + $resultatRights >>c:\temp\icacls.log
#$user + " Reset : " + $resultatReset >>c:\temp\icacls.log
