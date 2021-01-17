write-host "sluit de databar aan om de escaperoom te starten"
do {
    $usbconnected=waitforUSB 180
    start-sleep 1
} until ($usbconnected)
$a = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
$a.databar.Solved=$true;
$a | ConvertTo-Json | set-content $global:quests_json;
