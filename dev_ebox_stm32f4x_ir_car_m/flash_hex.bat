echo off
cls

set project_dir=%cd%

set project_name=dev_ebox_stm32f4x_ir_car_m
echo project_dir=%project_dir%
set artefact_hex=%project_dir%\%project_name%.hex
set FlashTool=ST-LINK_CLI.exe
set Device=
set options= -c %Device% SWD freq=4000 HOTPLUG  LPM -P %artefact_hex% -V "after_programming" -Log -TVolt
call %FlashTool% %options%
rem Reset System
call %FlashTool% -Rst

