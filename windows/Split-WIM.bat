set SRC=REPLACE_WITH_SOURCE_DRIVE_LETTER
set DST=REPLACE_WITH_DESTINATION_DRIVE_LETTER

cmd /c "DISM /Split-Image /ImageFile:"%SRC%:\sources\install.wim" /SWMFile:"%DST%:\sources\install.swm" /FileSize:3800"
