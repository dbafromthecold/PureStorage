# import powershell module
Import-Module PureStoragePowerShellSDK


# set variables
$FlashArrayIp = "<<STORAGE ARRAY MANAGENENT IP>>"
$SourceVolume = "<<VOLUME NAME ON THE ARRAY>>"
$ProtectionGroup = "<<PROTECTION GROUP NAME>>"


# get credentials to connect to flash array
$Cred = Get-Credential


# Connect to the FlashArray's REST API, get a session going
$FlashArray = New-PfaArray -EndPoint $FlashArrayIp -Credentials $Cred -IgnoreCertificateError


# Take a snaphot of the protection group
$MostRecentSnapshot = New-PFAProtectionGroupSnapshot -Array $FlashArray -ProtectionGroupName $ProtectionGroup | Sort-Object Created -Descending | Select-Object -Property name -First 1
Write-Host $MostRecentSnapshot.Name
