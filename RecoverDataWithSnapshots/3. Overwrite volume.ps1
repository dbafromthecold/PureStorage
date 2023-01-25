# import powershell modules
Import-Module PureStoragePowerShellSDK


# set variables
$TargetVM = "<<TARGET VM NAME>>"

$TargetDisk = "<<TARGET DISK ID>>" # this is retrieved by Get-Disk on the target server

$SourceVolume = "<<SOURCE VOLUME NAME ON THE ARRAY>>"
$TargetVolume = "<<TARGET VOLUME NAME ON THE ARRAY>>"

$ProtectionGroup = "<<PROTECTION GROUP NAME>>"

$FlashArrayIp = "<<STORAGE ARRAY MANAGENENT IP>>"


# get credentials to connect to flash array
$Cred = Get-Credential


# Connect to the FlashArray's REST API, get a session going
$FlashArray = New-PfaArray -EndPoint $FlashArrayIp -Credentials $Cred -IgnoreCertificateError


# create session on target VM
$TargetVMSession = New-PSSession -ComputerName $TargetVM


# Offline the target volume
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | ? { $_.SerialNumber -eq $using:TargetDisk } | Set-Disk -IsOffline $True }


# Confirm volume offline
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | Select-Object Number, SerialNumber, OperationalStatus | Format-Table}


# get most recent snapshot - check snapshot name variable input, is source volume correct?
$MostRecentSnapshot = Get-PfaProtectionGroupSnapshots -Array $FlashArray -Name $ProtectionGroup | Sort-Object created -Descending | Select-Object -Property name -First 1
$MostRecentSnapshot.Name


# Perform the volume overwrite
New-PfaVolume -Array $FlashArray -VolumeName $TargetVolume -Source ($MostRecentSnapshot.name + ".$SourceVolume") -Overwrite


# Online the target volume
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | ? { $_.SerialNumber -eq $using:TargetDisk } | Set-Disk -IsOffline $False }


# Confirm volume online
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-Disk | Select-Object Number, SerialNumber, OperationalStatus | Format-Table}


# List database files on new volume
Invoke-Command -Session $TargetVMSession -ScriptBlock { Get-ChildItem F:\SQLData1}
