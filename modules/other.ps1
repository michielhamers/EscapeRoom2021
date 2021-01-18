function openbrowser($url,$expires){
    start-Process -FilePath $url -PassThru
    
    write-host "quit after $expires seconds" -nonewline
    1..$expires | ForEach-Object {
        write-host "." -nonewline
        sleep 1
    }
    get-process "*chrome*" | Stop-Process
    
}
function openvideo(){
    # werkend
     & ./media/chris.mp4 
     # Start-Process "./media/chris.mp4" 
}
function ballinbox(){
    for(){cls
        ($l="+$('-'*18)+")
        7..0|%{$j=$_
            "|$(-join(17..0|%{'* '[$j-[Math]::abs(7-$i%14)-or$_-[Math]::abs(17-$i%34)]}))|"}
            $l;$i++;sleep 0.5}
}

function een(){
    # mplayer -cookies -cookies-file /tmp/cook.txt $(youtube-dl -g --cookies /tmp/cook.txt "https://youtu.be/n8lip6bl6gg")  
    youtube-dl -g --cookies /tmp/cook.txt "https://youtu.be/n8lip6bl6gg" 
}
function afronden( $value, [MidpointRounding]$mode = 'AwayFromZero' ) {
    [Math]::Round( $value )

  }
function audio(){
    if ($iswindows -ne $true){
        open "/Users/mha22490/Music/Music/Media.localized/Unknown Artist/Unknown Album/Never Gonna Give You Up Original.mp3"
        sleep 10
        # Get-Process music |Stop-Process
    } else
    {
        write-host "not implemented yet"
        read-host "en nu?"
        $Song = New-Object System.Media.SoundPlayer
        $Song.SoundLocation = "path\to\track.mp3"
        $Song.Play()
    }
}

function waitforUSB($timeout){
    $usbgekoppeld=$false
    $timedout=$false;
    $aftellen=$timeout;
    do {
        $paden=Join-Path -path ((Get-PSDrive -PSProvider FileSystem).root) -ChildPath "ER.TXT"
        $paden | ForEach-Object {
            if (test-path $_) {
                $usbgekoppeld = $true
            }
        }
        $aftellen--;
        start-sleep 1
        if ($aftellen -le 0) {$timedout=$true;}
    } while (($usbgekoppeld -eq $false) -and (-not $timedout))
    return $usbgekoppeld;
}
Function Test-IsFileLocked {
    [cmdletbinding()]
    Param (
        [parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelineByPropertyName=$True)]
        [Alias('FullName','PSPath')]
        [string[]]$Path
    )
    Process {
        ForEach ($Item in $Path) {
            #Ensure this is a full path
            $Item = Convert-Path $Item
            #Verify that this is a file and not a directory
            If ([System.IO.File]::Exists($Item)) {
                Try {
                    $FileStream = [System.IO.File]::Open($Item,'Open','Write')
                    $FileStream.Close()
                    $FileStream.Dispose()
                    $IsLocked = $False
                } Catch [System.UnauthorizedAccessException] {
                    $IsLocked = 'AccessDenied'
                } Catch {
                    $IsLocked = $True
                }
                [pscustomobject]@{
                    File = $Item
                    IsLocked = $IsLocked
                }
            }
        }
    }
}
 