

function resetallquests(){
        Copy-Item ./Quests/empty/quests.json $global:quests_json;
}
function startquest($questname){
    do {
        write-host "."
        start-sleep 1
    } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
    $q = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
    switch ($questname) {
        "hoofdpersonage"  {$currentquest=$q.questa}
        "SnakeQuestion"  {$currentquest=$q.SnakeQuestion}
        "SnakeGame" {$currentquest=$q.SnakeGame}
        "starthintmovie" {$currentquest=$q.starthintmovie}
        "SnakeMovie" {$currentquest=$q.SnakeMovie}
        "databar" {$currentquest=$q.databar}
        "questa" {$currentquest=$q.questa}
        "questb" {$currentquest=$q.questb}
        "questc" {$currentquest=$a.questc}
        "questd" {$currentquest=$a.questd}
        "queste" {$currentquest=$a.queste}
        "questf" {$currentquest=$a.questf}
        "questg" {$currentquest=$a.questg}
        "questh" {$currentquest=$a.questh}
        "questi" {$currentquest=$a.questi}
        "questj" {$currentquest=$a.questj}
        "questk" {$currentquest=$a.questk}
        "questl" {$currentquest=$a.questl}
        "questm" {$currentquest=$a.questm}
        Default  { read-host "Check quests.ps1 and add questname in list ";exit;}
    }
    if ($currentquest.type -eq "func") {
        $psfilename=$currentquest.Question
        Invoke-expression $psfilename 
    } elseif ($currentquest.type -eq "ps1") {
        $psfilename=$currentquest.Question
        . ./quests/$psfilename
    } elseif (($currentquest.Solved -eq $false) -and ($currentquest.active)){
        do {
            if ($currentquest.type -eq "Q") {
                $currentquest.answer=read-host $currentquest.Question;
                if ($currentquest.answer -eq $currentquest.Correct) {
                    Write-host "Het antwoord is goed!";
                    do {
                        write-host "."
                        start-sleep 1
                    } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
                    $q = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
                    switch ($questname) {
                        "questa"  {$q.questa.Solved=$true;$currentquest.solved=$true;}
                        "hoofdpersonage"  {$q.questa.Solved=$true;$currentquest.solved=$true;}
                        "SnakeQuestion"  {$q.SnakeQuestion.Solved=$true;$currentquest.solved=$true;}
                        "SnakeGame" {$q.SnakeGame.Solved=$true;$currentquest.solved=$true;}
                        Default  { exit;}
                    }
                    do {
                        write-host "."
                        start-sleep 1
                    } while ((Test-IsFileLocked -Path $global:quests_json).islocked)
                    $q | ConvertTo-Json | set-content $global:quests_json;
                    start-sleep 5
                }
            }

        } while (($currentquest.Solved -eq $false) -and ($currentquest.active))
    } 
}