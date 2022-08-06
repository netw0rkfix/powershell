#list all licence form o365
Get-MsolAccountSku

#list all F1 licenced users
Get-MsolUser -MaxResults 2000 | Where-Object {($_.licenses).AccountSkuId -match "M365_F1_COMM"}

### Change execution policy to allow script running
Set-ExecutionPolicy Bypass -Scope Process

### Uninstall teams machine wide
(Get-ItemProperty C:\Users\*\AppData\Local\Microsoft\Teams\Update.exe).PSParentPath | foreach-object {Start-Process $_\Update.exe -ArgumentList "--uninstall /s" -PassThru -Wait}

### Install choco package manager
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco uninstall anydeskproduct 

#List inactive ad users
#Nedd to run as root
Import-Module ActiveDirectory
Search-ADAccount –AccountDisabled -UsersOnly | Select -Property Name,DistinguishedName

### Find registry keys for installed software
get-children -path 'HKEY_USERS:\<User GUID>\Software\Microsoft\Windows\CurrentVersion\Uninstall' | select name


#Commande powershell pour actualiser le AD sync sur SMTP : 
Start-ADSyncSyncCycle -policytype delta


### Uninstall software 

### Get package name
## Get-package -name anydesk

### Pull GUID from every registry path
#$UninstallKeys = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
#$null = New-PSDrive -Name HKU -PSProvider Registry -Root Registry::HKEY_USERS
#$Uninstall Keys += Get-ChildItem HKU: -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' } | ForEach-Object { "HKU:\$($_.PSChildName)\Software\Microsoft\Windows\CurrentVersion\Uninstall" }

### Iterate on every  key ton extract the name of the application
#foreach ($UninstallKey in $UninstallKeys) {
#    Get-ChildItem -Path $UninstallKey -ErrorAction SilentlyContinue | Where {$_.PSChildName -match '^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$'} | Select-Object @{n='GUID';e={$_.PSChildName}}, @{n='Name'; e={$_.GetValue('DisplayName')}}
#}

### Install choco package manager
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
#choco uninstall <packagename>

### list all installed software and their GUID
### parameter -name <package name> to search specific 
function Get-InstalledSoftware {
    [OutputType([System.Management.Automation.PSObject])]
    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Name
    )
    $UninstallKeys = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall", "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
    $null = New-PSDrive -Name HKU -PSProvider Registry -Root Registry::HKEY_USERS
    $UninstallKeys += Get-ChildItem HKU: -ErrorAction SilentlyContinue | Where-Object { $_.Name -match 'S-\d-\d+-(\d+-){1,14}\d+$' } | ForEach-Object { "HKU:\$($_.PSChildName)\Software\Microsoft\Windows\CurrentVersion\Uninstall" }
    if (-not $UninstallKeys) {
        Write-Verbose -Message 'No software registry keys found'
    } else {
        foreach ($UninstallKey in $UninstallKeys) {
            if ($PSBoundParameters.ContainsKey('Name')) {
                $WhereBlock = { ($_.PSChildName -match '^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$') -and ($_.GetValue('DisplayName') -like "$Name*") }
            } else {
                $WhereBlock = { ($_.PSChildName -match '^{[A-Z0-9]{8}-([A-Z0-9]{4}-){3}[A-Z0-9]{12}}$') -and ($_.GetValue('DisplayName')) }
            }
            $gciParams = @{
                Path        = $UninstallKey
                ErrorAction = 'SilentlyContinue'
            }
            $selectProperties = @(
                @{n='GUID'; e={$_.PSChildName}}, 
                @{n='Name'; e={$_.GetValue('DisplayName')}}
            )
            Get-ChildItem @gciParams | Where $WhereBlock | Select-Object -Property $selectProperties
        }
    }
}


get-InstalledSoftware | Select-Object -name ESET Endpoint Security