#production OU for Windows 10 Horizon 7 desktops
$TargetOU = "OU=PROD,OU=Horizon View 7 Desktops,OU=RNU,OU=Domain Computers,DC=protrav,DC=Local"

#Search for compuer object in computer container which contain the WIN10- hostname prefix
$ComputerFilter = Get-ADComputer -LDAPFilter "(name=*VDI10-*)" -SearchBase "CN=Computers,DC=protrav,DC=local"

#Move object to production OU
ForEach ($computers in $ComputerFilter) {
    Move-ADObject -Identity $Computers.DistinguishedName -TargetPath $TargetOU
    Write-Output "Computer object $ComputerFilter.Name has been moved to $TargetOU"
}
