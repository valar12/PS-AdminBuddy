#Check is folder path exists
$path = "C:\_v2t\GVC\"

If(!(test-path $path))
{
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    }

#Download latest copy of client
$webClient = New-Object -TypeName System.Net.WebClient
$webClient.DownloadFile('https://software.sonicwall.com/GlobalVPNClient/184-011500-00_REV_A_GVCSetup64.exe', "$path\184-011500-00_REV_A_GVCSetup64.exe")

$webClient = New-Object -TypeName System.Net.WebClient
$webClient.DownloadFile('http://software.sonicwall.com/GlobalVPNClient/GVCUtil64.zip', "$path\GVCUtil64.zip")

#Extract GVC MSI
C:\_v2t\GVC\184-011500-00_REV_A_GVCSetup64.exe /c /t:C:\_v2t\GVC\GVCInstall64.msi

#Extract GVC cleaner
Expand-Archive -LiteralPath $path\GVCUtil64.zip -DestinationPath $path

#Stop Service
#Stop-Service -Name "SWIPsec.sys"

#Uninstall SonicWALL GVC
#Start-Process "msiexec.exe" -Wait -NoNewWindow -ArgumentList '/X{7D7ED176-EA00-4B2B-B421-AA19A451F650} /qn /norestart/'
Start-Process msiexec.exe -Wait -ArgumentList '/x {7D7ED176-EA00-4B2B-B421-AA19A451F650} /qn /l*v "C:\_v2t\GVC\removeGVC.log"' 

#Uninstall GVC 5.0.0.1010
Start-Process msiexec.exe -Wait -ArgumentList '/x {B53B8B37-83FF-45A1-9136-D41305CE554E} /qn /l*v "C:\_v2t\GVC\removeGVC.log"'

#Uninstall GVC 4.10.7
Start-Process msiexec.exe -Wait -ArgumentList '/x {83C9BF15-02E7-4049-9758-EE61175CFB7B} /qn /l*v "C:\_v2t\GVC\removeGVC.log"'

#Uninstall GVC 4.9.14
Start-Process msiexec.exe -Wait -ArgumentList '/x {51E63C85-20E3-49E1-B0F2-4E0431A9CCA4} /qn /l*v "C:\_v2t\GVC\removeGVC.log"'

#Install SonicWALL GVC
Start-Process "c:\_v2t\GVC\184-011500-00_REV_A_GVCSetup64.exe" -Wait -NoNewWindow -ArgumentList '/s /v"/qn"'