#download and install healthsare
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile("http://wiki.j2interactive.com/filez/intersystems/healthshare_distro/HS-2017.2.1.801.3.18281-hscore15.032_hsaa15.032_hspi15.032_hsviewer15.032_linkage15.032-b8679-win_x64.exe","C:\Packages\healthshare.exe")
& C:\Packages\healthshare.exe /instance healthshare /qn INITIALSECURITY=Normal CACHEUSERPASSWORD=j2andUtoo

#download and install notepad++
$WebClient.DownloadFile("https://notepad-plus-plus.org/repository/7.x/7.6/npp.7.6.Installer.exe","C:\Packages\npp.exe")
Start-Process -FilePath "C:\Packages\npp.exe" -ArgumentList '/S' -Verb runas -Wait

#Open firewall on vm to allow management portal
New-NetFirewallRule -DisplayName "HealthShare Web Management Portal" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 57772