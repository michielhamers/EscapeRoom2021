clear-host
. ./modules/ascii.ps1
. ./Quests/Quests.ps1
. ./modules/other.ps1
$global:screen_json = "./screens/screen.json";
$global:quests_json = "./quests/quests.json"; 
$global:thisscreen = 0; 
$global:maintimer = 30; #amount of minutes for default escape                                             
function screenjsonfromurl(){
    # $StatusCode="200";
    # do{
    #     $Command = "(Invoke-Webrequest -SkipCertificateCheck -Uri `"http://syn-nas.home:2021/EscapeRoom/Screens/screen.json`").RawContent"
    #     # $Command = "(Invoke-Webrequest -Uri `"http://syn-nas.home:2021/EscapeRoom/quests/quests.json`").Content"
    #     try {
    #         $returnvalue=Invoke-Expression $Command;
    #         # $R = Invoke-WebRequest -URI http://<non_existing_site>?q=how+many+feet+in+a+mile
    #     }
    #     catch {
    #         $StatusCode=$_.Exception.Message
    #     }
    # } while ($StatusCode -ne "200")
    $returnvalue = screenjsonfromfile
    return $returnvalue
  }
function screenjsonfromfile(){
    return get-content $global:screen_json -raw
}
function questjsonfromurl(){
    # $StatusCode="200";
    # do{
    #     $Command = "(Invoke-Webrequest -SkipCertificateCheck -Uri `"http://syn-nas.home:2021/EscapeRoom/quests/quests.json`").RawContent"
    #     try {
    #         $returnvalue=Invoke-Expression $Command;
    #         # $R = Invoke-WebRequest -URI http://<non_existing_site>?q=how+many+feet+in+a+mile
    #     }
    #     catch {
    #         $StatusCode=$_.Exception.Message
    #     }
    # } while ($StatusCode -ne "200")
    $returnvalue = screenquestsfromfile
    return $returnvalue
  }
function screenquestsfromfile(){
    return get-content $global:quests_json -raw
}
function clearlogs(){
    Write-Output "Starting" |Out-File -FilePath ./temp/main.log
    $firstentryoflog='Start new logfile '+(get-date)
    Set-Content -Path .\temp\*.log -Filter *.log -Value $firstentryoflog
}   
function header(){
    $t=bigtekst "EscapeRoom ±"
    # write-host ()  -ForegroundColor red;
    for ($i=0;$i -lt $t.length;$i++) {
        if ($i%2) {
         $c = "green"
        }
        elseif ($i%3) {
         $c = "magenta"
        }
        elseif ($i%5) {
         $c = "white"
        }
        else {
           $c = "green"
        }
        write-host $t[$i] -NoNewline -ForegroundColor $c -backgroundcolor black
        }
        write-host "";
}

function showgameconfig(){
    write-host "Timer" $global:maintimer -ForegroundColor white
}

function ResetGameRoom(){
    clearlogs;
    write-host "ResetGameRoom"
    Remove-Item -Path .\Answers\*.txt
    Copy-Item ./Screens/empty/screen.json $global:screen_json;
    Copy-Item ./Quests/empty/quests.json $global:quests_json;
}
function winner(){
    write-host "WINNER"
    $a = screenjsonfromurl |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Winner"
    $a.screens | ForEach-Object {
        $_.Content= "Winner";
        $_.Contentvisible=$true;
        $_.screenbackground="green";
        $_.refresh=30;
        $_.Questassigned=$false
    }
    $a | ConvertTo-Json | set-content $global:screen_json
}
function loser(){
    $a = screenjsonfromurl |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Loser"
    $a.screens | ForEach-Object {
        $_.Content= "Loser";
        $_.Contentvisible=$true;
        $_.screenbackground="red";
        $_.refresh=30;
        $_.Questassigned=$false
    }
    $a | ConvertTo-Json | set-content $global:screen_json
}
function menu(){
    header
    $a = screenjsonfromurl |ConvertFrom-Json
    write-host "Game menu " -ForegroundColor Yellow -nonewline
    write-host "[" -nonewline
    write-host $a.CurrentGame.Game -nonewline -ForegroundColor Yellow
    write-host " - " -nonewline
    write-host $a.CurrentGame.countdownto -nonewline
    write-host "] "
    write-host "0 - exit" -ForegroundColor RED
    write-host "Z - stopANDreset" -ForegroundColor blue
    write-host "1 - Use as screen" -ForegroundColor Green
    write-host "2 - Show Game Config"
    write-host "3 - Reset Escape Room" -ForegroundColor blue
    write-host "4 - auto decide (win or lose)"
    write-host "42 - Start game with current set of options" -ForegroundColor Yellow
    write-host "42usb - start full escape after usb connect"
    write-host "43 - STOP game" -ForegroundColor blue
    write-host "4242 - end game > WINNER" -ForegroundColor green
    write-host "4343 - end game > LOSER" -ForegroundColor red
    write-host "abcde > for quest a ...or b or c...." -ForegroundColor red
}
function startEscape(){
    write-host "startEscape"
    $a = screenjsonfromurl |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Started"
    $a.CurrentGame.countdownto=(get-date).AddMinutes($global:maintimer)
    $a.CurrentGame.countdownto=get-date $a.CurrentGame.countdownto -format o
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    write-host "countdown to" $a.CurrentGame.countdownto
    $a | ConvertTo-Json | set-content $global:screen_json
}
function waitfordatabarquestcomple(){
    write-host "waitfordatabarquestcomple"
    do {
        $q = questjsonfromurl |ConvertFrom-Json;
        start-sleep 1
        write-host "." -NoNewline
    } while ($q.databar.Solved -eq $false);
}
function usbconnectandstart(){
    startquestonscreen -screen 1 -quest databar
    waitfordatabarquestcomple;
    start-sleep 1
    stopquestonscreen 1
    start-sleep 1
    thegreatescape
}
function stopEscape(){
    write-host "stopEscape";
    $a = screenjsonfromurl |ConvertFrom-Json
    $a.CurrentGame.active = $false
    $a.CurrentGame.Game = "STOPPED"
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    $a | ConvertTo-Json | set-content $global:screen_json
}
function useasscreenonly(){
    write-host "useasscreenonly"
    do {
     . ./Screens/screen.ps1
      clear-host;
    } while ($true)
}
function startquestonscreen ($screen, $quest){
    write-host "startquestonscreen "$screen $quest
    $a = screenjsonfromurl |ConvertFrom-Json
    $a.screens | Where-Object {$_.screen -eq $screen} | ForEach-Object {
        $_.Questassigned = $quest
    }
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    $a | ConvertTo-Json | set-content $global:screen_json
}
function stopquestonscreen ($screen){
    write-host "stopquestonscreen "$screen $quest
    $a = screenjsonfromurl |ConvertFrom-Json
    $currentscreen=$a.screens | Where-Object {$_.screen -eq $screen} 
    $currentscreen.Questassigned = $false
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    $a | ConvertTo-Json | set-content $global:screen_json
}
function startquestsnake(){
    write-host "startquestsnake"
    # startquestonscreen 1 "SnakeMovie"
    startquestonscreen 2 "SnakeQuestion"
    startquestonscreen 3 "SnakeGame"
    waitquestsnake
    # stopquestonscreen 1
    stopquestonscreen 2
    stopquestonscreen 3
}
function waitquestsolved($quest,$screen){
    write-host "waitquest "$screen $quest
    do {
        $q = questjsonfromurl |ConvertFrom-Json
        start-sleep 1
        write-host "." -NoNewline
    } while ($q.SnakeQuestion.Solved -eq $false);
    stopquestonscreen 3
}
function waitquestsnake(){
    write-host "waitquestsnake "$screen $quest
    do {
        $q = questjsonfromurl |ConvertFrom-Json
        start-sleep 1
        write-host "." -NoNewline
    } while ($q.SnakeQuestion.Solved -eq $false);
    stopquestonscreen 3
}
function autodecide(){
    write-host "autodecide"
    $a = screenjsonfromurl |ConvertFrom-Json
    $StartDate=[datetime](GET-DATE -format o)
    $EndDate=[datetime]$a.CurrentGame.countdownto
    $verschil=(NEW-TIMESPAN –Start $StartDate –End $EndDate)
    $verschil_inmin=[int]$verschil.Hours*60
    $verschil_inmin+=$verschil.minutes
    write-host "[" -nonewline
    write-host $a.CurrentGame.Game -nonewline -ForegroundColor Yellow
    write-host " - " -nonewline
    write-host $a.CurrentGame.countdownto -nonewline
    write-host "] time of print $startdate"
    if ($verschil_inmin -le 0){
        write-host "euh"
        write-host $verschil_inmin
        Loser
    } else {
        write-host "tijd over"
    }

}
function stopANDreset(){
    stopEscape
    1..15 |ForEach-Object {
        write-host "." -nonewline
        start-sleep 1
    }
    resetgameroom
}
function startquestA(){
    startquestonscreen 2 "questa"
    do {
        start-sleep 1
        write-host "." -NoNewline
        $q = questjsonfromurl |ConvertFrom-Json
    } while ($q.questa.Solved -eq $false);
    stopquestonscreen 2
}
function starthintmovie(){
    write-host "starthintmovie"
    startquestonscreen 2 "starthintmovie"
}
function startwebje(){
    write-host "startwebje"
    startquestonscreen 2 "webje"
}
function thegreatescape(){
    startEscape
    start-sleep 1
    autodecide
    start-sleep 1
    startquestA
    start-sleep 1
    autodecide
    start-sleep 1
    startquestonscreen 4 "questb"
    # waitquestdone
    start-sleep 1
    autodecide
    start-sleep 1
    startquestsnake
    winner;
}
function main(){
    Setcolors "black"
    clear-host;
    do {
        menu;
        $response=read-host ":"
        switch ($response){
            "9" {thegreatescape}
            "0" {write-host "Exiting;"}
            "z" {stopANDreset}
            "1" {useasscreenonly}
            "2" {showgameconfig}
            "3" {resetgameroom}
            "42" {startEscape;}
            "42usb" {usbconnectandstart;}
            "4" {autodecide}
            "43" {stopEscape;}
            "4242" {winner;}
            "4343" {loser;}
            "A" {startquestA}
            "b" {startquestonscreen 4 "questb"}
            "c" {startquestsnake}
            "d" {starthintmovie}
            "e" {startwebje}
            Default {"Choose something from menu."}
        }
    } while ($response -ne 0)
}
main;