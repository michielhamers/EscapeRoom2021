clear-host
. ./modules/ascii.ps1
. ./Quests/Quests.ps1
. ./modules/other.ps1
$global:screen_json = "./screens/screen.json";
$global:quests_json = "./quests/quests.json"; 
$global:thisscreen = 0;                                                   
function clearlogs(){
    # Remove-Item -Path .\temp\old\*.*
    # move-Item -Path .\temp\*.log -Destination .\temp\old\ 
    Write-Output "Starting" |Out-File -FilePath ./temp/main.log
    $firstentryoflog='Start new logfile '+(get-date)
    Set-Content -Path .\temp\*.log -Filter *.log -Value $firstentryoflog
}   
function header(){
    $t=bigtekst "Escaperoom ±"
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
    # write-host (bigtekst (get-date -format HH:mm)) -ForegroundColor yellow
}

function showgameconfig(){
    write-host "Timer" $maintimer -ForegroundColor white
    start-sleep 2
}

function resetgameroom(){
    write-host "resetgameroom"
    # Remove-Item -Path .\answers\*.txt  
    Copy-Item ./Screens/empty/screen.json $global:screen_json;
    resetallquests;
}
function winner(){
    write-host "WINNER"
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Winner"
    $a.screens | ForEach-Object {
        $_.Content= "Winner";
        $_.Contentvisible=$true;
        $_.screenbackground="green";
        $_.refresh=30;
        $_.Questassigned=$false
    }
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a | ConvertTo-Json | set-content $global:screen_json
}
function loser(){
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
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
    $CGS= getCurrentGameStatus
    write-host "Game menu " -ForegroundColor Yellow -nonewline
    write-host "[" -nonewline
    write-host $CGS.CurrentGame.Game -nonewline -ForegroundColor Yellow
    write-host " - " -nonewline
    write-host $CGS.CurrentGame.countdownto -nonewline
    write-host "] "
    write-host "0 - exit" -ForegroundColor RED
    write-host "Z - stopANDreset" -ForegroundColor blue
    write-host "1 - Use as screen" -ForegroundColor Green
    write-host "2 - Show Game Config"
    write-host "3 - Reset Escape Room" -ForegroundColor blue
    write-host "4 - auto decide (win or lose)"
    # write-host "41 - show current set of options"
    write-host "42 - Start game with current set of options" -ForegroundColor Yellow
    write-host "43 - STOP game" -ForegroundColor blue
    write-host "4242 - end game > WINNER" -ForegroundColor green
    write-host "4343 - end game > LOSER" -ForegroundColor red
    write-host "abcde > for quest a ...or b or c...." -ForegroundColor red
}
function startEscape(){
    write-host "startEscape"
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Started"
    $a.CurrentGame.countdownto=(get-date).AddMinutes($maintimer)
    $a.CurrentGame.countdownto=get-date $a.CurrentGame.countdownto -format o
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    write-host "countdown to" $a.CurrentGame.countdownto
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a | ConvertTo-Json | set-content $global:screen_json
}
function waitfordatabarquestcomple(){
    write-host "waitfordatabarquestcomple"
    do {
        do {
            write-host "."
            start-sleep 1
        } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
        $q = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
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
function getCurrentGameStatus(){
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
    return $a;
}
function stopEscape(){
    write-host "stopEscape";
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $false
    $a.CurrentGame.Game = "STOPPED"
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
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
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json

    $a.screens | Where-Object {$_.screen -eq $screen} | ForEach-Object {
        $_.Questassigned = $quest
    }
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a | ConvertTo-Json | set-content $global:screen_json

}
function stopquestonscreen ($screen){
    write-host "stopquestonscreen "$screen $quest
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
    $currentscreen=$a.screens | Where-Object {$_.screen -eq $screen} 
    $currentscreen.Questassigned = $false
    $a.CurrentGame.LastUpdated=(get-date -format o).tostring()
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
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
        do {
            write-host "."
            start-sleep 1
        } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
        $a = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
        start-sleep 1
        write-host "." -NoNewline
    } while ($a.SnakeQuestion.Solved -eq $false);
    stopquestonscreen 3
}
function waitquestsnake(){
    write-host "waitquestsnake "$screen $quest
    do {
        do {
            write-host "."
            start-sleep 1
        } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
        $q = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
        start-sleep 1
        write-host "." -NoNewline
    } while ($q.SnakeQuestion.Solved -eq $false);
    stopquestonscreen 3
}
function autodecide(){
    write-host "autodecide"
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw |ConvertFrom-Json
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
        do {
            write-host "."
            start-sleep 1
        } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
        $q = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
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
    # header;
    $maintimer=30 #30 minutes
    clearlogs;
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
