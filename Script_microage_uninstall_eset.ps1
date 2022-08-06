## Powershell
$UninstallStrings = (gwmi win32_product | where {$_.Name -like "eset*"} | select LocalPackage).localpackage
$Count = 0

foreach ($UninstallString in $UninstallStrings) {
    $Count = $Count + 1
    c:\windows\system32\msiexec /x $UninstallString /qn PASSWORD="nod32" REBOOT="ReallySuppress" /L*V "C:\windows\temp\eset-uninstall-$Count.log"
    c:\windows\system32\msiexec /x $UninstallString /qn REBOOT="ReallySuppress" /L*V "C:\windows\temp\eset-uninstall-Nopass-$Count.log"
}
