echo off
cls

set project_name=jz_f407vet6_mbr_light_gcc_m
set project_dir=%cd%
set workspace_dir=%project_dir%\..\..\..\
echo workspace_dir=%workspace_dir%

echo project_dir=%project_dir%
set artefact_hex=%project_dir%\%project_name%.hex
set FlashTool=ST-LINK_CLI.exe
rem set Device= ID=0x463 SN=066CFF323535474B43013113 
set Device=
set options= -c %Device% 
set options=%options% JTAG freq=4000 HOTPLUG LPM
set options=%options% -P %artefact_hex% 
set options=%options% -V "after_programming" 
set options=%options% -Log
set options=%options% -TVolt

call %FlashTool% %options%
rem Reset System
call %FlashTool% -Rst

:: call %workspace_dir%\tool\launch_terminal.bat 5 460800 "jz_f407vet6_mbr_light_gcc_m"
