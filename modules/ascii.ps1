
function bigtekst($tekst){
    $cachedtekst="./Cached/$tekst"
    if (Test-Path $cachedtekst) {
        $returnvalue=Get-Content $cachedtekst -Raw
    }else {
        $Command = "(Invoke-Webrequest -Uri `"https://artii.herokuapp.com/make?text=$tekst`").Content"
        $returnvalue=Invoke-Expression $Command;
        $returnvalue |out-file $cachedtekst
    }
    return $returnvalue
}

