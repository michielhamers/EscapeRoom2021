## tooling for creating ascii art 
# usb https://manytools.org/hacker-tools/convert-images-to-ascii-art
$ASCIIART_USB="                                                      @@@&                      
                                                   #@@@(@@@@,                   
                                                 @@@@     ,@@@&                 
                                              #@@@(   @@     @@@@,              
                                       .@@@%  &@    *@         ,@@@&            
                                     &@@@@@@@@,         .@@   .@@@@             
                                  ,@@@@@@@@@@@@@&           %@@@(               
                                &@@@@@@@@@@@@@@@@@@,     .@@@@                  
                             ,@@@@@@@@@@@@@@@@@@@@@@@&  %@@(                    
                           &@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                       
                        ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(                      
                      &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                       
                   ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#                          
                 &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                            
               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#                               
               @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                                 
                &@@@@    #@@@@@@@@@@@@@@@@@#                                    
                  .@@@@*    @@@@@@@@@@@@@.                                      
                     @@@@@  @@@@@@@@@@#                                         
                       .@@@@@@@@@@@@                                            
                          @@@@@@@#                                              "
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
function asciiart($drawing){
    $returnvalue=""
    switch ($drawing) {
        usb { $returnvalue=$ASCIIART_USB  }
        Default { "ASCII Art $drawing not found"}
    }
    return $returnvalue
}