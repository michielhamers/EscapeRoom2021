Clear-Host
. ./modules/ascii.ps1
. ./Quests/Quests.ps1
. ./modules/other.ps1
$screenneedupdate=$true;
function choosescreen(){
  Write-host "will this be which monitor?"
  $screennumber=Read-host "screen"
  return $screennumber
}
function Setcolors($achtergrond){
  $Host.UI.RawUI.BackgroundColor = ($bckgrnd = $achtergrond)
  $Host.UI.RawUI.ForegroundColor = 'White'
  $Host.PrivateData.ErrorForegroundColor = 'Red'
  $Host.PrivateData.ErrorBackgroundColor = $bckgrnd
  $Host.PrivateData.WarningForegroundColor = 'Magenta'
  $Host.PrivateData.WarningBackgroundColor = $bckgrnd
  $Host.PrivateData.DebugForegroundColor = 'Yellow'
  $Host.PrivateData.DebugBackgroundColor = $bckgrnd
  $Host.PrivateData.VerboseForegroundColor = 'Green'
  $Host.PrivateData.VerboseBackgroundColor = $bckgrnd
  $Host.PrivateData.ProgressForegroundColor = 'Cyan'
  $Host.PrivateData.ProgressBackgroundColor = $bckgrnd
}

function showscreen($x){
  $lastupdategamestatus="NEVERUPDATED"
  do {
    $screen=Get-Content ./screens/screen.json -Raw |ConvertFrom-Json
    switch ($x) {
      1 {$currentscreen=$screen.Screens.Screen1 }
      2 {$currentscreen=$screen.Screens.Screen2 }
      3 {$currentscreen=$screen.Screens.Screen3 }
      4 {$currentscreen=$screen.Screens.Screen4 }
      5 {$currentscreen=$screen.Screens.Screen5 }
      Default {$currentscreen=$screen.Screens.Screen1;}
    }
    if ($currentscreen.active){
      Setcolors $currentscreen.screenbackground;
    } else {
      Setcolors "red";
      Clear-host
      Read-host " bug found contact the admin"
    }
    ####
    # $lastupdategamestatus=$screen.CurrentGame.Game
    Clear-Host
    write-host "[$x]                                                       "$screen.CurrentGame.Game -ForegroundColor Yellow
    # write-host (bigtekst $currentscreen.header) -ForegroundColor Yellow
    header
    $showgeneralcountdown=$currentscreen.showgeneralcountdown;
    if ($currentscreen.Contentvisible) {
      write-host $currentscreen.content -ForegroundColor yellow
    } else {
      write-host ""
    }
    if ($screen.CurrentGame.Game -eq "Waitingtostart") {
      start-sleep 5
    } else {
      if ($showgeneralcountdown) {
        write-host "Minutes Left " 
        $StartDate=(GET-DATE)
        $EndDate=[datetime]$screen.CurrentGame.countdownto
        $verschil=(NEW-TIMESPAN –Start $StartDate –End $EndDate)
        $verschil_inmin=[int]$verschil.Hours*60
        $verschil_inmin+=$verschil.minutes
        # $verschil_inmins=$verschil_inmin.tostring
        # $minutesleft= afronden $verschil_inmins
        # write-host "test----------------==========="
        # write-host $verschil_inmin`
        # read-host "test na"
        # $left=$verschil_inmin
        $left_big=bigtekst $verschil_inmin;
        Write-Host $left_big;
      }
      if ($currentscreen.Questassigned) {
        startquest $currentscreen.Questassigned
      } else {
        write-host "Dit scherm wacht nu niet op invoer"
        Write-host "Scherm vernieuwd elke "$currentscreen.refresh "seconden" -NoNewline
        # $pos = $host.UI.RawUI.cursorPosition;
        1..$currentscreen.refresh | % {
          if ($screen.CurrentGame.Game -eq "Started"){
            Start-Sleep 0.5
            write-host "."   -nonewline
          }
          if ($screen.CurrentGame.Game -eq "Winner"){
            Start-Sleep 10
            write-host "."   -nonewline
          }
          
        }
      }  
    }

  } while (($screen.CurrentGame.active) -or ($screen.CurrentGame.Game -eq "Waitingtostart"))
}
function mainscreen(){

  $x=choosescreen;
  showscreen $x;
  Setcolors black
}
mainscreen;