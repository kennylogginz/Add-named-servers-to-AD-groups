### Update AD Groups "Patching Group 1" & "Patching Group 2" with like-named servers from AD
### Computer accounts in the above groups can be associated to GPO entries that set comp config - admin templates - windows components - windows update - patch / reboot windows

### Updates
### May 7, 2017 - Initial version

### Build filtered list of all AD servers

### Filter out servers that we don't want to regularly patch
$Servers = Get-ADComputer -Filter * | Sort DNSHostname `
| Where {$_.DNShostName -notlike "*GOL*"} `
| Where {$_.DNShostName -notlike "*ESX*"}
## | Where {$_.DNShostName -notlike "*YOUR ENTRY HERE*"} 
 
### Filter $Servers to include servers with the # 1 in their name
$Servers2AddtoGrp1 = $Servers | Where {$_ -like "*1*"}

### Filter $Servers to include servers with the # 2 in their name
$Servers2AddtoGrp2 = $Servers | Where {$_ -like "*2*"}

### Create object for patching group 1
$ADGrp1 = Get-ADGroup -Filter * | Where {$_.name -eq "Patching Group 1"}

### Create object for patching group 2
$ADGrp2 = Get-ADGroup -Filter * | Where {$_.name -eq "Patching Group 2"}

### Reset Patching Group 1 members
Get-ADGroupMember $ADGrp1 | ForEach {

    Remove-ADGroupMember $ADGrp1 -members $_ -Confirm:$False

}

### Reset Patching Group 2 members
Get-ADGroupMember $ADGrp2 | ForEach {

    Remove-ADGroupMember $ADGrp2 -members $_ -Confirm:$False

}

### Add all entries from $Servers2AddtoGrp1
Add-ADGroupMember $ADGrp1 -Members $Servers2AddtoGrp1

### Add all entries from $Servers2AddtoGrp2
Add-ADGroupMember $ADGrp2 -Members $Servers2AddtoGrp2

