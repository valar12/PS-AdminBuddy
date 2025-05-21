# Step 1: Install and Import Required Microsoft Graph Submodules
$requiredModules = @(
    "Microsoft.Graph.Applications",
    "Microsoft.Graph.Identity.SignIns"
)

foreach ($module in $requiredModules) {
    if (-not (Get-Module -ListAvailable -Name $module)) {
        $installModuleParams = @{
            Name         = $module
            Scope        = "CurrentUser"
            Force        = $false
            AllowClobber = $true
        }
        Install-Module @installModuleParams
    }
    Import-Module $module
}

# Step 2: Connect to Microsoft Graph
$connectMgGraphParams = @{
    Scopes = @(
        "Application.ReadWrite.All",
        "Directory.ReadWrite.All",
        "AppRoleAssignment.ReadWrite.All",
        "DelegatedPermissionGrant.ReadWrite.All"
    )
    NoWelcome = $true
}

try {
    Connect-MgGraph @connectMgGraphParams
} catch {
    Write-Error "Failed to connect to Microsoft Graph: $_"
    exit 1
}

# Step 3: Check if Application Display Name Already Exists and Has "IDM-" Prefix
$appDisplayName = "IDM-v8"
$existingApps = Get-MgApplication -Filter "startswith(displayName,'IDM-')"

foreach ($app in $existingApps) {
    if ($app.displayName -eq $appDisplayName) {
        Write-Error "An application with the display name '$appDisplayName' already exists and has an 'IDM-' prefix. Exiting script."
        exit 1
    }
}

# Step 4: Prepare RequiredResourceAccess for Microsoft Graph Device and DeviceManagement Permissions
$graphAppId = '00000003-0000-0000-c000-000000000000' # Microsoft Graph App ID

# Retrieve Graph Service Principal to get permission IDs
$graphSp = Get-MgServicePrincipal -Filter "AppId eq '$graphAppId'"

# Define required app role values
$requiredPermissions = @(
    "Device.ReadWrite.All",
    "DeviceManagementManagedDevices.ReadWrite.All",
    "DeviceManagementServiceConfig.ReadWrite.All"
)

# Retrieve matching app roles
$graphRoles = $graphSp.AppRoles | Where-Object { $requiredPermissions -contains $_.Value }

# Build RequiredResourceAccess object
$requiredResourceAccess = @(
    @{
        ResourceAppId  = $graphAppId
        ResourceAccess = $graphRoles | ForEach-Object {
            @{
                Id   = $_.Id
                Type = 'Role'
            }
        }
    }
)

# Step 5: Create the Application
$newAppParams = @{
    DisplayName            = $appDisplayName
    RequiredResourceAccess = $requiredResourceAccess
}
$application = New-MgApplication @newAppParams

$appId = $application.AppId
$objectId = $application.Id
$directoryId = (Get-MgOrganization).Id

Write-Output "====================="
Write-Output "Application ID: $appId"
Write-Output "Object ID: $objectId"
Write-Output "Directory ID (Tenant ID): $directoryId"
Write-Output "====================="

# Step 6: Create Service Principal for the New Application if it doesn't exist
$sp = Get-MgServicePrincipal -Filter "AppId eq '$appId'"
if (-not $sp) {
    $sp = New-MgServicePrincipal -AppId $appId
}

# Step 7: Grant Admin Consent for Application Permissions (App Roles)
$graphSpId = $graphSp.Id

foreach ($role in $graphRoles) {
    New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id `
        -PrincipalId $sp.Id `
        -AppRoleId $role.Id `
        -ResourceId $graphSpId
}

# Step 8: Add a New Password (Client Secret) to the Application
$pwdParams = @{
    ApplicationId      = $application.Id
    PasswordCredential = @{
        StartDateTime = (Get-Date)
        EndDateTime   = (Get-Date).AddYears(1)   # Password expires in 1 year
        DisplayName   = "MigrationWiz"           # Customize as needed
    }
}

$clientSecret = Add-MgApplicationPassword @pwdParams

Write-Output "Generated Client Secret: $($clientSecret.SecretText)"
Write-Output "====================="

# Copy to clipboard
Add-Type -AssemblyName PresentationCore
[System.Windows.Clipboard]::SetText($clientSecret.SecretText)

Write-Host "The secret value is copied to the clipboard." -ForegroundColor Green