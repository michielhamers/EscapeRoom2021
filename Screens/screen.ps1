function choosescreen(){
  # $screennumer=$global:thisscreen
  if ($global:thisscreen -eq "0"){
    Write-host "will this be which monitor? (or 0 = exit)"
    $global:thisscreen=Read-host "screen"
    if ($global:thisscreen -eq "0") {
      exit
    }
      # $global:thisscreen=$screennumber
    }
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
    # $screennumer=$global:thisscreen
    do {
      write-host "."
      start-sleep 1
    } while ((Test-IsFileLocked -Path $global:screen_json).islocked)
    $a = Get-Content $global:screen_json -Raw | ConvertFrom-Json
    $currentscreen=$a.Screens | Where-Object {$_.Screen -eq $global:thisscreen}
    #####################################################################################
    if ($currentscreen.active){
      Setcolors $currentscreen.screenbackground;
    } else {
    Setcolors "red";
    Clear-host
    $currentscreen
    $a.Screens
    $a
    Read-host " bug found contact the admin"
    exit;
    }
    #####################################################################################
    Clear-Host
    write-host "[$global:thisscreen]                                                       "$a.CurrentGame.Game -ForegroundColor Yellow
    write-host (bigtekst $currentscreen.header) -ForegroundColor Yellow
    $showgeneralcountdown=$currentscreen.showgeneralcountdown;
    switch ($a.CurrentGame.Game) {
      "Started" {
        if ($currentscreen.Contentvisible){
          Write-Host $currentscreen.content -ForegroundColor yellow
        } else {
          Write-Host ""
        }
        if ($showgeneralcountdown) {
          write-host "Minutes Left " 
          $StartDate=(GET-DATE)
          $temptijd=(get-date $a.CurrentGame.countdownto -format o)
          $EndDate=[datetime]$temptijd
          if (-not $enddate) {
            Write-host " FOUT"
            Read-host " en nu?"
          }
          $verschil=(NEW-TIMESPAN -Start $StartDate -End $EndDate)
          $verschil_inmin=[int]$verschil.Hours*60 # keer 60 omdat 60 minuten in een uur passen
          $verschil_inmin+=$verschil.minutes
          $left_big=bigtekst $verschil_inmin;
          Write-Host $left_big;
        }
        if ($currentscreen.Questassigned) {
          startquest $currentscreen.Questassigned
        }
        1..$currentscreen.refresh | ForEach-Object {
            Start-Sleep 1
            write-host "."   -nonewline
          }
        start-sleep 1
        }
      "Winner" {
          write-host (bigtekst $currentscreen.content) -ForegroundColor yellow
          start-sleep 10
      }
      "Stopped" {
        write-host "Stopped" -ForegroundColor yellow
        start-sleep 10
      }
      "Waitingtostart" {
        write-host "" -ForegroundColor yellow
        if ($currentscreen.Questassigned -eq "databar") {
          startquest $currentscreen.Questassigned
        }
        start-sleep 5
        start-sleep 10
      }
      Default {
        Setcolors "red";
        Clear-host
        write-host "I don't know what to do?"
        $currentscreen
        $a.Screens
        $a
        read-host "En nu?"
      }
    }
  } while (($a.CurrentGame.active) -or ($a.CurrentGame.Game -eq "Waitingtostart"))
}
function mainscreen(){

  choosescreen;
  showscreen;
  Setcolors black
}
mainscreen;