    write-host (asciiart usb)

    
    write-host "Sluit de databar aan om de escaperoom te starten"

    do {
        $usbconnected=waitforUSB 10
        start-sleep 1
    } until ($usbconnected)
    if ($usbconnected){
        if ((Test-Path ./Answers/databar) -eq $false) {
            $Global:thisscreen | Set-Content ./Answers/databar
        } 
        write-host "Databar connected."
    }
    start-sleep 3