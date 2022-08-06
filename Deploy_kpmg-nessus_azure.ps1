#Step1: Convert VMDK disk to VHD disk
#Import-Module "C:\Program Files\Microsoft Virtual Machine Converter\mvmcCmdlet.psd1"
#ConvertTo-MvmcVirtualHardDisk -SourceLiteralPath C:\CloudTechLab\VMWINSTO01.vmdk -VhdType DynamicHardDisk -VhdFormat vhd -destination E:\VHDexport\

#Step2: Copy VHD file to Blob storage
#Add-AzVhd -Destination "https://kpmgnessus.blob.core.windows.net/kpmg/Siemplify v1.5.vhdx" -LocalFilePath "U:\Projets\Scripts\Deploy_Nessus_azure_vm.ps1" -ResourceGroupName "RG-01" -NumberOfUploaderThreads 32

Step3: Define variable for new VM
$resourceGroupName = "rg-01"
$destinationVhd = ""
$virtualNetworkName = "vNET"
$locationName = "eastus"

Step4: Get a virtual network information. 
$virtualNetwork = Get-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Name $virtualNetworkName 

Step5: Define network interface details.
$networkInterface = New-AzNetworkInterface -Name "nessus-network-int" -ResourceGroupName $resourceGroupName -Location $locationName -SubnetId "/subscriptions/05859901-b18d-4b7c-8c45-ca57eee14022/resourceGroups/RG-01/providers/Microsoft.Network/virtualNetworks/vNET/subnets/Serveurs"

Step6: Get VM size from your location
Get-AzVMSize $locationName

Step6: Define name and size
$vmConfig = New-AzVMConfig -VMName "kpmg-nessus" -VMSize "Standard_D4s_v3"

Step7: Define disk configuration
$vmConfig = Set-AzVMOSDisk -VM $vmConfig -Name "OSdisk" -VhdUri $destinationVhd -CreateOption Attach -Linux

Step8: Add network interface.
$vmConfig = Add-AzVMNetworkInterface -VM $vmConfig -Id $networkInterface.Id

Step9 
$vm = New-AzVM -VM $vmConfig -Location $locationName -ResourceGroupName $resourceGroupName

