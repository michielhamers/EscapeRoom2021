write-host "Sluit de databar aan om de escaperoom te starten"
do {
    $usbconnected=waitforUSB 180
    start-sleep 1
} until ($usbconnected)
do {
    write-host "."
    start-sleep 1
} while ((Test-IsFileLocked -Path $global:quests_json).islocked)
$q = Get-Content $global:quests_json -Raw | ConvertFrom-Json;
$q.databar.Solved=$true;
$q | ConvertTo-Json | set-content $global:quests_json;
