echo off
cls

set project_name=start_mik32_v1_eeprom_bootloader_m
set project_dir=%cd%
set workspace_dir=%project_dir%\..\..\..\
echo workspace_dir=%workspace_dir%

echo project_dir=%project_dir%
set artefact_hex=build\%project_name%.hex

set PYTHON_BIN=python.exe
set script=%workspace_dir%tool\tool_mik32\mik32-uploader\mik32_upload.py
echo script=%script%

::set script=mik32_upload.py
set FlashTool=%PYTHON_BIN% %script%


set MCU_CFG=mik32.cfg
set PROG_CFG=start-link.cfg

set gdb_server=--openocd-exec=openocd.exe
set bit_rate=--adapter-speed=3200
set programmer=--openocd-interface=%PROG_CFG%
set Device=--openocd-target=%MCU_CFG%

set options="%artefact_hex%"
set options=%options% --run-openocd
set options=%options% %gdb_server% 
set options=%options% %programmer% 
set options=%options% %Device% 
::set options=%options% %bit_rate% 

%FlashTool% %options%

