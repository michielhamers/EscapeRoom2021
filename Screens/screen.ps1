function choosescreen(){
  $screennumer=$global:thisscreen
  if ($global:thisscreen -eq "0"){
    Write-host "will this be which monitor?"
    $screennumber=Read-host "screen"
    $global:thisscreen=$screennumber
  };
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

function showscreen(){
  do {
    $screen=Get-Content $global:screen_json -Raw |ConvertFrom-Json
    $currentscreen=$a.Screens | Where-Object {$_.Screen -eq $global:thisscreen}
    if ($currentscreen.active){
      Setcolors $currentscreen.screenbackground;
    } else {
      Setcolors "red";
      Clear-host
      $currentscreen
      $a.screens 
      Read-host " bug found contact the admin"
    }
    ####
    # $lastupdategamestatus=$screen.CurrentGame.Game
    Clear-Host
    write-host "[$global:thisscreen]                                                       "$screen.CurrentGame.Game -ForegroundColor Yellow
    # header
    write-host (bigtekst $currentscreen.header) -ForegroundColor Yellow
    $showgeneralcountdown=$currentscreen.showgeneralcountdown;
    if ($currentscreen.Contentvisible) {
      if ($screen.CurrentGame.Game -eq "Winner"){
        write-host (bigtekst $currentscreen.content) -ForegroundColor yellow
      } else {
        write-host $currentscreen.content -ForegroundColor yellow
      }
    } else {
      write-host ""
    }
    if ($screen.CurrentGame.Game -eq "stopped"){
      start-sleep 5
    }
    if ($screen.CurrentGame.Game -ne "stopped"){

    
    if ($screen.CurrentGame.Game -eq "Waitingtostart") {
      if ($currentscreen.Questassigned -eq "databar") {
        startquest $currentscreen.Questassigned
      }
      start-sleep 5
    } else {
      if ($showgeneralcountdown) {
        write-host "Minutes Left " 
        $StartDate=(GET-DATE)
        $temptijd=(get-date $screen.CurrentGame.countdownto -format o)
        $EndDate=[datetime]$temptijd
        if (-not $enddate) {
          Write-host " FOUT"
          Read-host " en nu?"
        }
        $verschil=(NEW-TIMESPAN -Start $StartDate -End $EndDate)
        $verschil_inmin=[int]$verschil.Hours*60
        $verschil_inmin+=$verschil.minutes
        $left_big=bigtekst $verschil_inmin;
        Write-Host $left_big;
      }
      if ($currentscreen.Questassigned) {
        startquest $currentscreen.Questassigned
      } else {
        write-host "Dit scherm wacht nu niet op invoer"
        Write-host "Scherm vernieuwd elke "$currentscreen.refresh "seconden" -NoNewline
        # $pos = $host.UI.RawUI.cursorPosition;
        1..$currentscreen.refresh | ForEach-Object {
          if ($screen.CurrentGame.Game -eq "Started"){
            Start-Sleep 1
            write-host "."   -nonewline
          }
          if ($screen.CurrentGame.Game -eq "Winner"){
            Start-Sleep 1
            write-host "."   -nonewline
          }
          if ($screen.CurrentGame.Game -eq "Loser"){
            Start-Sleep 1
            write-host "."   -nonewline
          }
          
        }
      }  
    }
    }

  } while (($screen.CurrentGame.active) -or ($screen.CurrentGame.Game -eq "Waitingtostart"))
}
function mainscreen(){

  choosescreen;
  showscreen;
  Setcolors black
}
mainscreen;