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

$a.screens | where {$_.screen -eq 5}


