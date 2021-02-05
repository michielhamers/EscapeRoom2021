    write-host (asciiart usb)

    
    write-host "Sluit de geheime usb stick hier aan."

    do {
        $usbconnected=waitforUSB 10 "GEHEIM.TXT"
        start-sleep 1
    } until ($usbconnected)
    if ($usbconnected){
        if ((Test-Path ./Answers/databar) -eq $false) {
            $Global:thisscreen | Set-Content ./Answers/databar
        } 
        write-host "Geheime usb connected."
    }
    start-sleep 3