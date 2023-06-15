# Set variables
$userEmail = "alazar@v2portal.com"
$destinationSiteURL = "https://v2technology.sharepoint.com/sites/archive-userdata"
$destinationLibraryTitle = "Documents"

# Connect to SharePoint Online and OneDrive for Business
Connect-PnPOnline -Url $destinationSiteURL -Interactive
$oneDriveUrl = "https://v2technology-my.sharepoint.com/personal/" + $userEmail.Replace("@","_").Replace(".","_")
Connect-PnPOnline -Url $oneDriveUrl -Interactive

# Get user's display name to use as folder name
$user = Get-PnPUserProfileProperty -Account $userEmail
$folderName = $user.displayname

# Create folder in SharePoint Teams site
Add-PnPFolder -Name $folderName -Folder "$destinationSiteURL/$destinationLibraryTitle/"

# Get all files and folders from the user's OneDrive
$items = Get-PnPListItem -List "Documents"

# Copy files and folders to the SharePoint Teams site
foreach ($item in $items) {
    if ($item.FileSystemObjectType -eq "File") {
        # Copy file
        Copy-PnPFile -SourceUrl $item.FieldValues.FileRef -TargetUrl "$destinationSiteURL/$destinationLibraryTitle/$folderName/" -OverwriteIfAlreadyExists
    }
    else {
        # Copy folder
        $subFolderName = $item.FieldValues.FileLeafRef
        Add-PnPFolder -Name $subFolderName -Folder "$destinationSiteURL/$destinationLibraryTitle/$folderName/"
        $subItems = Get-PnPListItem -List "Documents" -FolderServerRelativeUrl "/personal/$userEmail/Documents/$subFolderName"
        foreach ($subItem in $subItems) {
            # Copy subfolder files
            Copy-PnPFile -SourceUrl $subItem.FieldValues.FileRef -TargetUrl "$destinationSiteURL/$destinationLibraryTitle/$folderName/$subFolderName/" -OverwriteIfAlreadyExists
        }
    }
}