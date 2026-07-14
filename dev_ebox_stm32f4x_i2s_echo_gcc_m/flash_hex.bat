echo off
cls

set project_name=dev_ebox_stm32f4x_i2s_echo_gcc_m
set project_dir=%cd%
set workspace_dir=%project_dir%\..\..\..\
echo workspace_dir=%workspace_dir%

echo project_dir=%project_dir%
set artefact_hex=%project_dir%\build\%project_name%.hex
echo artefact_hex=%artefact_hex%

set FlashTool=ST-LINK_CLI.exe
rem set Device= ID=0x463 SN=066CFF323535474B43013113 
set Device=
set options= -c %Device% 
set options=%options% SWD freq=2000 UR  
set options=%options% -P %artefact_hex% 
set options=%options% -V "after_programming" 
set options=%options% -Log
set options=%options% -TVolt

call %FlashTool% %options%
rem Reset System
call %FlashTool% -Rst
