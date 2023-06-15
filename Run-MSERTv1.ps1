#Check is folder path exists
$path = "$env:systemdrive\_starfish\MSERT"
If(!(test-path $path))
{
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    }

#Download latest copy of MSERT
#https://docs.microsoft.com/en-us/windows/security/threat-protection/intelligence/safety-scanner-download
#https://docs.microsoft.com/en-us/dotnet/api/system.net.webclient.downloadfile?view=net-5.0
$webClient = New-Object –TypeName System.Net.WebClient
$webClient.DownloadFile('https://go.microsoft.com/fwlink/?LinkId=212732', "$path\MSERT.exe")

#Run scan
Start-Process -FilePath $env:systemdrive\_starfish\MSERT\MSERT.exe -ArgumentList "/F:Y /Q" -Wait

#copy log files with date and hostname appendment to _starfish/msert folder
$msertlog = "$env:windir\debug\msert.log"
$path_to_file = "C:\_starfish\MSERT\$($env:computername)-msert-$((Get-Date).ToString('yyyy-MM-dd')).log"
Copy-Item -Path $msertlog -Destination $path_to_file