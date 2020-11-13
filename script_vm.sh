#!/bin/bash

read -p "What is the name of the VM you want to create? " vmname

if [[ -d /Users/alexis/VirtualBox\ VMs/"$vmname"/ ]] ; then
	echo "The name $vmname is already taken. Please choose another name."
	exit 1
fi

read -p "How much storage should the new virtual machine use (in GB)? " disksize
disksize=$(($disksize * 954)) #Conversion des GB (ou Go) vers Mio

read -p "How much RAM should the new virtual machine use (in GB)? " ramsize
ramsize=$(($ramsize * 1024))

read -p "How much Video Ram should the new virtual machine use (from 1 to 128)? " vram

VBoxManage createvm --name $vmname --ostype debian_64 --register
VBoxManage modifyvm $vmname --ioapic on                     
VBoxManage modifyvm $vmname --memory $ramsize --vram $vram
VBoxManage modifyvm $vmname --nic1 bridged --bridgeadapter1 en0
VBoxManage createhd --filename "/Users/alexis/VirtualBox VMs/${vmname}/${vmname}_disk.vdi" --size $disksize --format VDI
VBoxManage storagectl $vmname --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $vmname --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/Users/alexis/VirtualBox VMs/${vmname}/${vmname}_disk.vdi"
VBoxManage storagectl $vmname --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach $vmname --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium /Users/alexis/Downloads/debian-10.4.0-amd64-DVD-1.iso
VBoxManage modifyvm $vmname --boot1 dvd --boot2 disk --boot3 none --boot4 none
VBoxManage modifyvm $vmname --graphicscontroller vmsvga

# VBoxManage startvm $vmname