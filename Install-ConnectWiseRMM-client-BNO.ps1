#Check if folder path exists
$savepath = "$env:systemdrive\_v2t"
If(!(test-path $savepath)) {
    New-Item -ItemType Directory -Force -Path $savepath | Out-Null
    }

#Set the security protocol to TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Set the download URL for resource
$downloadUrl = 'https://prod.setup.itsupport247.net/windows/DPMA/32/BardonsandOliver_DPMA_ITSPlatform_TKN30b62214-03c5-48ac-bbd9-729e6e4cb344/MSI/setup'

# Split the URL by slashes
$urlParts = $downloadUrl.Split('/')

# Get the third part of the URL
$RMMsite = $urlParts[-3]

# Set the path where you want to save the file
$installerpath = "$savepath\$RMMsite.msi"

# Download the RMM agent
Invoke-WebRequest -Uri $downloadUrl -OutFile $installerpath

# Define the arguments as a hashtable
$arguments = @{
    FilePath = "msiexec.exe"
    ArgumentList = "/i", "`"$installerpath`"", "/qn", "/norestart"
}

# Install the MSI file using splatting
Start-Process @arguments -Wait