
### Change execution policy to allow script running
Set-ExecutionPolicy Bypass -Scope Process


### Install choco package manager
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco uninstall anydeskproduct 



# Get the list of computer names from AD
$strCategory = "computer"

$objDomain = New-Object System.DirectoryServices.DirectoryEntry

$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.SearchRoot = $objDomain
$objSearcher.CacheResults = -1
$objSearcher.PageSize = 5000
$objSearcher.SizeLimit = 5000

$objSearcher.Filter = ("(&(operatingSystemVersion=5*)(objectCategory=$strCategory)(operatingSystem=Windows XP*))")

$wmiPrinterClass = "win32_printer"

$colProplist = "name"
foreach ($i in $colPropList)
    {$objSearcher.PropertiesToLoad.Add($i)}

$colResults = $objSearcher.FindAll()
$colResults.count

# for each computer, use WMI to scan for printers
foreach ($objComputer in $colResults)
    {
    $machine = $objComputer.Properties.name
    $machine
    get-WmiObject -class $wmiPrinterClass -computername $machine | `
      ft systemName, name, shareName, Local -auto | `
      Export-CSV "C:\Users\max1arm\Desktop\printers.csv"  #<<< HOW DO I STOP THIS FROM OVERWRITING???
    }
    
