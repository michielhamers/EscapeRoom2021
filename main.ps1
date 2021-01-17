clear-host
. ./modules/ascii.ps1
. ./Quests/Quests.ps1
. ./modules/other.ps1
                                                        

function clearlogs(){
    Remove-Item -Path .\temp\old\*.log
    move-Item -Path .\temp\*.log -Destination .\temp\old\
    Write-Output "Starting" |Out-File -FilePath temp/main.log
    $firstentryoflog='Start new logfile '+(get-date)
    Set-Content -Path .\temp\*.log -Filter *.log -Value $firstentryoflog
}
function header(){
    $t=bigtekst "Escaperoom"
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
        write-host $t[$i] -NoNewline -ForegroundColor $c -backgroundcolor blue
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
    Copy-Item ./Screens/empty/screen.json ./screens/screen.json;
    resetallquests;
}
function winner(){
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Winner"
    $a.Screens.Screen1.Content = "WINNER"
    $a.Screens.Screen1.Contentvisible = $true;
    $a.Screens.Screen1.screenbackground="green"
    $a.Screens.Screen1.refresh=30;
    $a.Screens.Screen2.Content = "WINNER"
    $a.Screens.Screen2.Contentvisible = $true;
    $a.Screens.Screen2.screenbackground="green"
    $a.Screens.Screen2.refresh=30;
    $a.Screens.Screen3.Content = "WINNER"
    $a.Screens.Screen3.Contentvisible = $true;
    $a.Screens.Screen3.screenbackground="green"
    $a.Screens.Screen3.refresh=30;
    $a.Screens.Screen4.Content = "WINNER"
    $a.Screens.Screen4.Contentvisible = $true;
    $a.Screens.Screen4.screenbackground="green"
    $a.Screens.Screen4.refresh=30;
    $a.Screens.Screen5.Content = "WINNER"
    $a.Screens.Screen5.Contentvisible = $true;
    $a.Screens.Screen5.screenbackground="green"
    $a.Screens.Screen5.refresh=30;
    $a | ConvertTo-Json | set-content $pathToJson
}
function loser(){
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Loser"
    $a.Screens.Screen1.Content = "Loser "
    $a.Screens.Screen1.Contentvisible = $true;
    $a.Screens.Screen1.screenbackground="red"
    $a.Screens.Screen2.Content = "Loser"
    $a.Screens.Screen2.Contentvisible = $true;
    $a.Screens.Screen2.screenbackground="red"
    $a.Screens.Screen3.Content = "Loser"
    $a.Screens.Screen3.Contentvisible = $true;
    $a.Screens.Screen3.screenbackground="red"
    $a.Screens.Screen4.Content = "Loser"
    $a.Screens.Screen4.Contentvisible = $true;
    $a.Screens.Screen4.screenbackground="red"
    $a.Screens.Screen5.Content = "Loser"
    $a.Screens.Screen5.Contentvisible = $true;
    $a.Screens.Screen5.screenbackground="red"
    $a | ConvertTo-Json | set-content $pathToJson
    # $a | ConvertTo-Json
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
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $true
    $a.CurrentGame.Game = "Started"
    $a.CurrentGame.countdownto=(get-date).AddMinutes($maintimer).tostring()
    $a.CurrentGame.LastUpdated=(get-date).tostring()
    $a | ConvertTo-Json | set-content $pathToJson
}
function getCurrentGameStatus(){
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    return $a;
}
function stopEscape(){
    write-host "stopEscape"
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    $a.CurrentGame.active = $false
    $a.CurrentGame.Game = "STOPPED"
    $a.CurrentGame.LastUpdated=(get-date).tostring()
    $a | ConvertTo-Json | set-content $pathToJson
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
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
      switch ($screen) {
        1 {$currentscreen=$a.Screens.Screen1 }
        2 {$currentscreen=$a.Screens.Screen2 }
        3 {$currentscreen=$a.Screens.Screen3 }
        4 {$currentscreen=$a.Screens.Screen4 }
        5 {$currentscreen=$a.Screens.Screen5 }
        Default {$currentscreen=$a.Screens.Screen2;}
      }
    $currentscreen.Questassigned = $quest
    $a.CurrentGame.LastUpdated=(get-date).tostring()
    $a | ConvertTo-Json | set-content $pathToJson
}
function stopquestonscreen ($screen){
    write-host "startquestonscreen "$screen $quest
    $pathToJson = "./Screens/screen.json"
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
      switch ($screen) {
        1 {$currentscreen=$a.Screens.Screen1 }
        2 {$currentscreen=$a.Screens.Screen2 }
        3 {$currentscreen=$a.Screens.Screen3 }
        4 {$currentscreen=$a.Screens.Screen4 }
        5 {$currentscreen=$a.Screens.Screen5 }
        Default {$currentscreen=$a.Screens.Screen2;}
      }
    $currentscreen.Questassigned = $false
    $a.CurrentGame.LastUpdated=(get-date).tostring()
    $a | ConvertTo-Json | set-content $pathToJson
}
function startquestsnake(){
    write-host "startquestsnake"
    startquestonscreen 1 "SnakeMovie"
    startquestonscreen 2 "SnakeQuestion"
    startquestonscreen 3 "SnakeGame"
    waitquestsnake
    stopquestonscreen 1
    stopquestonscreen 2
    stopquestonscreen 3
}
function waitquestsnake(){
    write-host "waitquestsnake "$screen $quest
    $pathToJson = "./Quests/quests.json";
    do {
        $a = Get-Content $pathToJson -Raw |ConvertFrom-Json;
        start-sleep 1
        write-host "." -NoNewline
    } while ($a.SnakeQuestion.Solved -eq $false);
  
    stopquestonscreen 3
}
function autodecide(){
    write-host "autodecide"

    $pathToJson = "./Screens/screen.json"

    
    $a = Get-Content $pathToJson -Raw |ConvertFrom-Json
    $countdownto=$a.CurrentGame.countdownto
    $secleft=(NEW-TIMESPAN –Start (get-date)  –End $countdownto).TotalSeconds

    $StartDate=[datetime](GET-DATE)
    $EndDate=[datetime]$a.CurrentGame.countdownto
    $verschil=(NEW-TIMESPAN –Start $StartDate –End $EndDate)
    $verschil_inmin=[int]$verschil.Hours*60
    $verschil_inmin+=$verschil.minutes

    if ($verschil_inmin -le 0){
        write-host "euh"
        write-host $verschil_inmin
        Loser
    } else {
        write-host "tijd over"
        # winner
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
    $pathToJson = "./Quests/quests.json";
    do {
        $a = Get-Content $pathToJson -Raw |ConvertFrom-Json;
        start-sleep 1
        write-host "." -NoNewline
    } while ($a.questa.Solved -eq $false);
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
