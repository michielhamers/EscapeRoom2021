
function bigtekst($tekst){
    $ctfile = 'e:/cache/$tekst';
    if (Test-Path $ctfile) {
        $returnvalue=Get-Content $cachedtekstfile -Raw
    }else {
        try{
        $Command = "(Invoke-Webrequest -Uri `"https://artii.herokuapp.com/make?text=$tekst`").Content"
        $returnvalue=Invoke-Expression $Command;
        $returnvalue |out-file $ctfile;
        }
        catch {
            $text | out-file $ctfile;
        }
    }
    return $returnvalue
}

