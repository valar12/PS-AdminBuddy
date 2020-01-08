$properties = @(
    @{n='User';e={$_.Properties[0].Value}},
    @{n='Locked by';e={$_.Properties[1].Value}},
    @{n='TimeStamp';e={$_.TimeCreated}}
    @{n='DCname';e={$_.Properties[4].Value}}
)
Get-WinEvent -ComputerName DOMAINCONTROLLER1 -FilterHashTable @{LogName='Security'; ID=4740} | 
Select $properties |
Export-csv $env:SystemDrive\Users\$env:Username\Desktop\LockedUsers.csv -NoTypeInformation -Encoding UTF8
