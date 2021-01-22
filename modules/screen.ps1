function choosescreen(){
  $thisscherm=[int]$global:thisscreen
  if (($thisscherm -ge 1) -and ($thisscherm -le 100)) {
    write-host "[$thisscherm]"
  } else {
    Write-host "will this be which monitor? (or 0 = exit)"
    $thisscreen=Read-host "screen"
    $global:thisscreen=$thisscreen;
  }
  if ($global:thisscreen -eq "0") {
    exit
  }
}
function showscreen(){
  do {
    $screennumer=$global:thisscreen
    $a = controllerjsonfromfile | ConvertFrom-Json
    $currentscreen=$a.Screens | Where-Object {$_.Screen -eq $screennumer}
    #####################################################################################
    if ($currentscreen.active){
      Setcolors $currentscreen.screenbackground;
    } 
    else
    {
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
        1..15 | ForEach-Object{
          start-sleep -seconds 1
        }
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
    if ($currentscreen.Questassigned) {
      startquest $currentscreen.Questassigned
    }
  } while (($a.CurrentGame.active) -or ($a.CurrentGame.Game -eq "Waitingtostart"))
}
function mainscreen(){
  choosescreen;
  showscreen;
  Setcolors black
}
mainscreen;