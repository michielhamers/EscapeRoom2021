

function resetallquests(){
        Copy-Item ./Quests/empty/quests.json $global:quests_json;
}
function startquest($questname){
    write-host "Start: $questname"
    # $pathToJson = "./Quests/quests.json";
    $a = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
    switch ($questname) {
        "hoofdpersonage"  {$currentquest=$a.questa}
        "SnakeQuestion"  {$currentquest=$a.SnakeQuestion}
        "SnakeGame" {$currentquest=$a.SnakeGame}
        "starthintmovie" {$currentquest=$a.starthintmovie}
        "SnakeMovie" {$currentquest=$a.SnakeMovie}
        "databar" {$currentquest=$a.databar}
        "questa" {$currentquest=$a.questa}
        "questb" {$currentquest=$a.questb}
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
                $currentquest.Attempt++;
                $a | ConvertTo-Json | set-content $global:quests_json;
                if ($currentquest.answer -eq $currentquest.Correct) {
                    Write-host "Het antwoord is goed!";
                    $a = Get-Content $global:quests_json -Raw |ConvertFrom-Json;
                    switch ($questname) {
                        "questa"  {$a.questa.Solved=$true;$currentquest.solved=$true;}
                        "hoofdpersonage"  {$a.questa.Solved=$true;$currentquest.solved=$true;}
                        "SnakeQuestion"  {$a.SnakeQuestion.Solved=$true;$currentquest.solved=$true;}
                        "SnakeGame" {$a.SnakeGame.Solved=$true;$currentquest.solved=$true;}
                        Default  { exit;}
                    }
                    $a | ConvertTo-Json | set-content $global:quests_json;
                    start-sleep 5
                }
            }

        } while (($currentquest.Solved -eq $false) -and ($currentquest.active))
    } 
    write-host "Finished: $questname"
}