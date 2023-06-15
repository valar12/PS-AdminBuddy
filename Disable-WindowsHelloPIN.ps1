# https://www.thewindowsclub.com/how-to-disable-windows-hello-prompt
#https://www.tenforums.com/tutorials/167588-enable-disable-sign-options-page-settings-windows-10-a.html
#This requires administrative rights to run

#Registry key path
$RegKey = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions";

#Get current value of value propert
$value =(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\PolicyManager\default\Settings\AllowSignInOptions).value
#Write-Output "The current registry value of value is $value";

# add a new property if it does not exist yet
$PropertyName = "value";
$PropertyData = "0";
$PropertyType = "DWord";

#Disable Windows Hello PIN
If ($value -ne 0) {
    Set-ItemProperty $RegKey -Name $PropertyName -Value $PropertyData -Type $PropertyType
}

Write-Output "The new registry value of value has been updated to $value";
#Required reboot to enforce