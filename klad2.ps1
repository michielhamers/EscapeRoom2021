$pathToJson = "./Screens/screen.json"
$a = Get-Content $pathToJson -Raw |ConvertFrom-Json
# 
# $a | ConvertTo-Json | set-content $pathToJson
# $a | where $_.Name -like "Screen*"   
# $a
write-host " --- "
$a.Screens | % {
    $_.Name
}
# | Select -ExpandProperty Type

<<<<<<< Updated upstream
$a.screens | where {$_.screen -eq 5}


=======
Function Show-SegmentDisplay {
    param(
        [Parameter(Mandatory=$true)][string]$InputString
    )
    $SegmentDisplay = @{
        '0' = '1111110'
        '1' = '0110000'
        '2' = '1101101'
        '3' = '1111001'
        '4' = '0110011'
        '5' = '1011011'
        '6' = '1011111'
        '7' = '1110000'
        '8' = '1111111'
        '9' = '1111011'
        'A' = '1110111'
        'B' = '0011111'
        'C' = '1001110'
        'D' = '0111101'
        'E' = '1001111'
        'F' = '1000111'
    }
    ForEach ($Char in $InputString.ToCharArray()) {
        $DisplayString = ""
        ForEach ($Segment in $SegmentDisplay[$Char].ToCharArray()) {
            If ($Segment -eq "1") {
                $DisplayString += "|"
            } Else {
                $DisplayString += " "
            }
        }
        Write-Host $DisplayString
    }
}
Show-SegmentDisplay "1234"
>>>>>>> Stashed changes
