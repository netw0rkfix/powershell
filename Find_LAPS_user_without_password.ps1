#get laps users without password 
Get-ADComputer -filter {enabled -eq $true} -Properties ms-mcs-admpwd | where-object {$_.'ms-mcs-admpwd' -eq $null}  | Sort-Object -Property name | select name,ms-mcs-admpwd



#return all users from ad whit creation date and last login + username
Get-ADUser -Filter {Enabled -eq $True} -Property Created,LastLogonDate | Select-Object -Property Name, SAMAccountName, Created, LastLogonDate

