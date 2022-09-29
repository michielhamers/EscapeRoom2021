
function bigtekst($tekst){
    $ctfile = "e:/cache/$tekst";
    if (Test-Path $ctfile) {
        $returnvalue=Get-Content $ctfile -Raw
    }else {
        try{
        $Command = "(Invoke-Webrequest -Uri `"https://artii.herokuapp.com/make?text=$tekst`").Content"
        $returnvalue=Invoke-Expression $Command;
        $returnvalue |out-file $ctfile;
        }
        catch {
            Out-File -FilePath $ctfile -InputObject $tekst -Encoding ASCII -Width 80
        }
    }
    return $returnvalue
}

