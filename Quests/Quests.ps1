function startquest($questname){
    $a = controllerjsonfromfile |ConvertFrom-Json;
    $currentquest=$a.quests | Where-Object {$_.quest -eq $questname}
    switch ($currentquest.type) {
        "func" {
            psfilename=$currentquest.Question
            Invoke-expression $psfilename  
        }
        "ps1" {
            $psfilename=$currentquest.Question
            . ./quests/$psfilename
        }
        "Q" {
            do {
                $currentquest.answer=read-host $currentquest.Question
                if ($currentquest.answer -eq $currentquest.Correct) {
                    Write-host "Het antwoord is goed!";
                    $global:thisscreen | set-content ./Answers/$questname
                    $currentquest.active=$false;
                }
                else {
                    write-host "Het antwoord is fout!" -ForegroundColor RED;
                    
                }
                start-sleep 3
            } while ($currentquest.Correct -eq $false)
        }
        Default { 
            write-host $questname
            write-host $a.quests
            write-host $currentscreen
            read-host "BUG QUEST TYPE"
        }
    } 
}