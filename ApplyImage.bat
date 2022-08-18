call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c

dism /Apply-Image /ImageFile:%1 /Index:1 /ApplyDir:W:\

W:\Windows\System32\bcdboot W:\Windows /s S:

md R:\Recovery\WindowsRE
xcopy /h W:\Windows\System32\Recovery\Winre.wim R:\Recovery\WindowsRE\

W:\Windows\System32\Reagentc /Setreimage /Path R:\Recovery\WindowsRE /Target W:\Windows

W:\Windows\System32\Reagentc /Info /Target W:\Windows

powershell -c "Get-ProvisionedAppPackage -Path W:\ | Remove-ProvisionedAppPackage -Path W:\"