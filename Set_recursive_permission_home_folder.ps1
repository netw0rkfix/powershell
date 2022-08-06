Get-ChildItem i:\users | foreach { 

$log= "c:\rights\" +$_.BaseName + ".txt"
$fullname = $_.FullName + "\"
$user = $_.basename
$commandDetails = $env:USERDNSDOMAIN + "\" + $user + ":" + "(OI)(CI)F"


#icacls $fullname /save $log /q /l /c /t
$resultatOwner = icacls $fullname /setowner $env:USERDNSDOMAIN\$user /t /c /l /q
$resultatRights = icacls $fullname /grant:r $commandDetails /c /q
$resultatReset = icacls $fullname* /reset /t /c /q /l
$user + " Owner : " + $resultatOwner >>c:\temp\icacls.log 
$user + " Rights : " + $resultatRights >>c:\temp\icacls.log
$user + " Reset : " + $resultatReset >>c:\temp\icacls.log

}