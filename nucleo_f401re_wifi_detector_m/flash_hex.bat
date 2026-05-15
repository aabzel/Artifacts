echo off
cls

set project_name=nucleo_f401re_wifi_detector_m
set project_dir=%cd%
set workspace_dir=%project_dir%\..\..\..\
echo workspace_dir=%workspace_dir%

echo project_dir=%project_dir%
set artefact_hex=%project_dir%\build\%project_name%.hex
set FlashTool=ST-LINK_CLI.exe
rem set Device= ID=0x463 SN=066CFF323535474B43013113 
set Device=
set options= -c %Device% SWD freq=2000 UR -P %artefact_hex% -V "after_programming" -Log -TVolt
call %FlashTool% %options%
rem Reset System
call %FlashTool% -Rst

:: call %workspace_dir%\tool\launch_terminal.bat 5 460800 "olimex_h407_pastilda"
