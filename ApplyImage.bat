@echo off
@if %1.==. echo ERROR: To run this script, add a path to a Windows image file.
@if %1.==. echo Example: ApplyImage D:\install.wim
@if %1.==. goto END

@echo list disk> listdisks
diskpart /s listdisks
del listdisks

@echo == Please select a disk ==
@set /p DISKID=Disk ID:

(@echo select disk %DISKID%)> createpartitions
@echo clean>> createpartitions
@echo convert gpt>> createpartitions
@echo create partition efi size=100>> createpartitions
@echo format quick fs=fat32 label="System">> createpartitions
@echo assign letter="S">> createpartitions
@echo create partition msr size=16>> createpartitions
@echo create partition primary>> createpartitions
@echo shrink minimum=500>> createpartitions
@echo format quick fs=ntfs label="Windows">> createpartitions
@echo assign letter="W">> createpartitions
@echo create partition primary>> createpartitions
@echo format quick fs=ntfs label="Recovery">> createpartitions
@echo assign letter="R">> createpartitions
@echo set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac">> createpartitions
@echo gpt attributes=0x8000000000000001>> createpartitions
@echo list volume>> createpartitions
@echo exit>> createpartitions

diskpart /s createpartitions
@call powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
dism /Get-ImageInfo /ImageFile:%1
@echo == Please enter the Index ID of the Windows Edition you want to install ==
@set /p wimindex=Index ID:
dism /Apply-Image /ImageFile:%1 /Index:%wimindex% /ApplyDir:W:\
@echo == Do you want to add drivers? ==
@set /p ADDDRIVERS=(Y or N):
@if %ADDDRIVERS%.==y. set ADDDRIVERS=Y
@if %ADDDRIVERS%.==Y. GOTO DRIVERS
@if not %ADDDRIVERS%.==Y GOTO SKIPDRIVERS

:DRIVERS
@echo == Please enter the path to a directory which contains drivers ==
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
