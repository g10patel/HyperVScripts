param(
    [Parameter(Mandatory=$true)]
    [string]$vmName,

    [Parameter(Mandatory=$true)]
    [string]
    $image

    [Parameter()]
    [string]
    $vmswitch = "vswitch1"

    [Parameter()]
    [string]
    $port = "port1"

    [Parameter()]
    [int]
    $vlan = 199

    [Parameter()]
    [int]
    $cpu = 2

    [Parameter()]
    [Int64]
    $ram = 2GB

    [Parameter(Mandatory=$true)]
    [string]
    $path_to_disk

    [Parameter()]
    [Int64]
    $disk_size = 20GB
)
# Create a new VM
New-VM  $vm
# Set the CPU and start-up RAM
Set-VM $vm -ProcessorCount $cpu -MemoryStartupBytes $ram 
# Create the new VHDX disk - the path and size.
New-VHD -Path $path_to_disk$vm-disk1.vhdx -SizeBytes $disk_size
# Add the new disk to the VM
Add-VMHardDiskDrive -VMName $vm -Path $path_to_disk$vm-disk1.vhdx
# Assign the OS ISO file to the VM
Set-VMDvdDrive -VMName $vm -Path $image
# Remove the default VM NIC named 'Network Adapter'
Remove-VMNetworkAdapter -VMName $vm 
# Add a new NIC to the VM and set its name
Add-VMNetworkAdapter -VMName $vm -Name $port
# Configure the NIC as access and assign VLAN
Set-VMNetworkAdapterVlan -VMName $vm -VMNetworkAdapterName $port -Access -AccessVlanId $vlan
# Connect the NIC to the vswitch
Connect-VMNetworkAdapter -VMName $vm -Name $port -SwitchName $vmswitch
Start-VM $vm