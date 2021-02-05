# # # Invoke-Command –ComputerName 192.168.178.1 –ScriptBlock {Start-Process notepad.exe}
# # # # $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
# # # otool -L /usr/local/microsoft/powershell/6/libmi.dylib

# # Invoke-Command –ComputerName localhost –ScriptBlock {
# #     # Start-Process notepad.exe
# #     & .\media\chris.mp4 
# # }

# # $Command = "(Invoke-Webrequest -Uri `"https://raw.githubusercontent.com/michielhamers/github-slideshow/master/index.html`").Content"
# # Invoke-Expression $Command;



# # # $pos = $host.UI.RawUI.cursorPosition;


# # #postitie:
# # # [console]::SetCursorPosition($x1,$yQ);
# # # [console]::SetCursorPosition(0,$ln);[console]::WriteLine(” “*$ww)}


# # # //cursur uit :
# # # [console]::CursorVisible = $False

# # ## all pause methods:
# # # https://adamtheautomator.com/how-to-pause-a-powershell-script/

# # ### read with timeout linux /mac
# # # read -p 'Press enter to continue' -t 5


# # # ## read with timeout on windows
# # # ## Pause for 2 seconds
# # # timeout /t 2

# # # # Pause for 5 seconds but disallow keystroke breaks
# # # timeout /t 5 /nobreak

# # # # Pause indefinitely until a key is pressed
# # # timeout /t -1


# $json = @"
# {
# "Stuffs": 
#     [
#         {
#             "Name": "Darts",
#             "Type": "Fun Stuff"
#         },

#         {
#             "Name": "Clean Toilet",
#             "Type": "Boring Stuff"
#         }
#     ]
# }
# "@

# $x = $json | ConvertFrom-Json

# $x.Stuffs[0] # access to Darts
# $x.Stuffs[1] # access to Clean Toilet
# $darts = $x.Stuffs | where { $_.Name -eq "darts" } #Darts

# # $darts.type
# # $x.Stuffs | where { $_.Name -like "dar*" } | Select -ExpandProperty Type
# write-host " hoi "
# Write-Host ""
# write-host "a"
# cls
# $x | where { $_ -like "stuff*" }  | % {$_ }

#mac specifiek

blueutil --paired
#connect 8bit controller
blueutil --connect  "e4-17-d8-fc-0b-75"
#disconnect 8bit controller 
blueutil --disconnect "e4-17-d8-fc-0b-75"
