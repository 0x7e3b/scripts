diskpart /s CreatePartitions-UEFI.txt
call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
set /p wimfile=Please enter the WIM-File location:
dism /Get-ImageInfo /ImageFile:%wimfile%
set /p wimindex=Please enter the edition number:
dism /Apply-Image /ImageFile:%wimfile% /Index:%wimindex% /ApplyDir:W:\
dism /Image:W:\ /Add-Driver /Driver:%2 /recurse
W:\Windows\System32\bcdboot W:\Windows /s S:
md R:\Recovery\WindowsRE
xcopy /h W:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE\
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows
W:\Windows\System32\Reagentc /Info /Target W:\Windows
powershell -c "Get-ProvisionedAppPackage -Path W:\ | Remove-ProvisionedAppPackage -Path W:\"