﻿# Split path
$Path = Split-Path -Parent "C:\_v2t\*.*"

# Create variable for the date stamp in log file
$LogDate = (Get-Date).ToString('yyyy-MM-dd_hh-mm-ss')

# Define CSV and log file location variables
# They have to be on the same location as the script
$Csvfile = $Path + "\azusers-$logDate.csv"

# Get all Azure AD users
$AzADUsers = Get-AzureADUser -All $true | Select-Object -Property *

# Display progress bar
$progressCount = 0
for ($i = 0; $i -le $AzADUsers.Count; $i++) {

    Write-Progress `
        -Id 0 `
        -Activity "Retrieving User " `
        -Status "$progressCount of $($AzADUsers.Count)" `
        -PercentComplete (($progressCount / $AzADUsers.Count) * 100)

    $progressCount++
}

# Create list
$AzADUsers | Sort-Object GivenName | Select-Object `
@{Label = "First name"; Expression = { $_.GivenName } },
@{Label = "Last name"; Expression = { $_.Surname } },
@{Label = "Display name"; Expression = { $_.DisplayName } },
@{Label = "User principal name"; Expression = { $_.UserPrincipalName } },
@{Label = "Street"; Expression = { $_.StreetAddress } },
@{Label = "City"; Expression = { $_.City } },
@{Label = "State/province"; Expression = { $_.State } },
@{Label = "Zip/Postal Code"; Expression = { $_.PostalCode } },
@{Label = "Country/region"; Expression = { $_.Country } },
@{Label = "Job Title"; Expression = { $_.JobTitle } },
@{Label = "Department"; Expression = { $_.Department } },
@{Label = "Company"; Expression = { $_.CompanyName } },
@{Label = "Description"; Expression = { $_.Description } },
@{Label = "Office"; Expression = { $_.PhysicalDeliveryOfficeName } },
@{Label = "Telephone number"; Expression = { $_.TelephoneNumber } },
@{Label = "E-mail"; Expression = { $_.Mail } },
@{Label = "Mobile"; Expression = { $_.Mobile } },
@{Label = "User type"; Expression = { $_.UserType } },
@{Label = "Dirsync"; Expression = { if (($_.DirSyncEnabled -eq 'True') ) { 'True' } Else { 'False' } } },
@{Label = "Account status"; Expression = { if (($_.AccountEnabled -eq 'True') ) { 'Enabled' } Else { 'Disabled' } } } |

# Export report to CSV file
Export-Csv -Encoding UTF8 -Path $Csvfile -NoTypeInformation