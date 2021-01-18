write-host "Sluit de databar aan om de escaperoom te starten"
do {
    $usbconnected=waitforUSB 180
    start-sleep 1
} until ($usbconnected)
$q = readjsonfromurl -Raw | ConvertFrom-Json;
$q.databar.Solved=$true;
$q | ConvertTo-Json | set-content $global:quests_json;
