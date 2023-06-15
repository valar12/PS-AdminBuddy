# Connect to Azure AD
Connect-AzureAD

# Retrieve the Azure AD tenant information
$tenantInfo = Get-AzureADTenantDetail

# Get all Azure AD users
$users = Get-AzureADUser -All $true

# Create an empty array to store the results
$result = @()

# Iterate through each user
foreach ($user in $users) {
    # Get the registered devices for the user
    $devices = Get-AzureADUserRegisteredDevice -ObjectId $user.ObjectId

    # Iterate through each device
    foreach ($device in $devices) {
        # Create a custom object with device and user information
        $deviceObject = [PSCustomObject]@{
            DeviceName = $device.DisplayName
            DeviceOwner = $user.UserPrincipalName
            DeviceOSType = $device.DeviceOSType
            ApproximateLastLogonTimeStamp = $device.ApproximateLastLogonTimeStamp
        }

        # Add the custom object to the result array
        $result += $deviceObject
    }
}

#Check if folder path exists
$savepath = "$env:systemdrive\_v2t"
If(!(test-path $savepath)) {
    New-Item -ItemType Directory -Force -Path $savepath | Out-Null
    }

# Generate a datestamp for the export file name
$dateStamp = Get-Date -Format "yyyyMMdd"

$csvParams = @{
    Path = "$savepath\$($tenantInfo.DisplayName)-AzureAD-devices-$dateStamp.csv"
    NoTypeInformation = $true
    Encoding = 'UTF8'
}

# Export the results to a CSV file
$result | Export-Csv @csvParams