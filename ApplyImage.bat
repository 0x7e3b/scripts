@echo off
@if %1.==. echo ERROR: To run this script, add a path to a Windows image file.
@if %1.==. echo Example: ApplyImage D:\install.wim
@if %1.==. goto END

diskpart /s CreatePartitions-UEFI.txt
@call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
dism /Get-ImageInfo /ImageFile:%1
@echo Please enter the Index ID of the Windows Edtion you want to install.
@set /p wimindex=Index ID:
dism /Apply-Image /ImageFile:%1 /Index:%wimindex% /ApplyDir:W:\
@echo Do you want to add drivers?
@set /p ADDDRIVERS=(Y or N):
@if %ADDDRIVERS%.==y. set ADDDRIVERS=Y
@if %ADDDRIVERS%.==Y. GOTO DRIVERS
@if not %ADDDRIVERS%.==Y GOTO SKIPDRIVERS

:DRIVERS
@echo Please enter the path to a directory which contains drivers
@echo in .inf format.
@set /p DRVPATH=Path:
dism /Image:W:\ /Add-Driver /Driver:%DRVPATH% /recurse

:SKIPDRIVERS
W:\Windows\System32\bcdboot W:\Windows /s S:
md R:\Recovery\WindowsRE
xcopy /h W:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE\
W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows
W:\Windows\System32\Reagentc /Info /Target W:\Windows
powershell -c "&{Get-ProvisionedAppPackage -Path W:\ | Remove-ProvisionedAppPackage -Path W:\}"
:END