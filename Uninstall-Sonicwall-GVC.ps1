#Uninstall SonicWALL GVC
Start-Process msiexec.exe -Wait -ArgumentList '/x {7D7ED176-EA00-4B2B-B421-AA19A451F650} REBOOT=REALLYSUPPRESS /qn' 

#Uninstall GVC 5.0.0.1010
Start-Process msiexec.exe -Wait -ArgumentList '/x {B53B8B37-83FF-45A1-9136-D41305CE554E} REBOOT=REALLYSUPPRESS /qn'

#Uninstall GVC 4.10.7
Start-Process msiexec.exe -Wait -ArgumentList '/x {83C9BF15-02E7-4049-9758-EE61175CFB7B} REBOOT=REALLYSUPPRESS /qn'

#Uninstall GVC 4.9.14
Start-Process msiexec.exe -Wait -ArgumentList '/x {51E63C85-20E3-49E1-B0F2-4E0431A9CCA4} REBOOT=REALLYSUPPRESS /qn'

#Uninstall GVC 4.9.4
Start-Process msiexec.exe -Wait -ArgumentList '/x {E828FDAA-B4E0-46B6-B647-7C03CCF48C83} REBOOT=REALLYSUPPRESS /qn'

#Uninstall GVC 4.10.2
Start-Process msiexec.exe -Wait -ArgumentList '/x {7D7ED176-EA00-4B2B-B421-AA19A451F650} REBOOT=REALLYSUPPRESS /qn'