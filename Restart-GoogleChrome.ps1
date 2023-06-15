$processes = Get-Process -Name "Chrome"
foreach ($process in $processes) {
    if ($process.ProductVersion -lt "112.0.5615.121") {
        Stop-Process -Id $process.Id -Force
    }
}

$program = "chrome.exe"
if (-not (Get-Process $program -ErrorAction SilentlyContinue)) {
    Start-Process $program
}