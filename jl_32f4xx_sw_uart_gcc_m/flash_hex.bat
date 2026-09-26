echo off
cls

set project_name=jl_32f4xx_sw_uart_gcc_m
set project_dir=%cd%
set workspace_dir=%project_dir%\..\..\..\
echo workspace_dir=%workspace_dir%

echo project_dir=%project_dir%
set artefact_hex=%project_dir%\%project_name%.hex
echo artefact_hex=%artefact_hex%

set FlashTool=ST-LINK_CLI.exe
set Device=
set options= -c %Device% 
set options=%options% JTAG freq=2000 UR  
set options=%options% -P %artefact_hex% 
set options=%options% -V "after_programming" 
set options=%options% -Log
set options=%options% -TVolt

call %FlashTool% %options%
rem Reset System
call %FlashTool% -Rst
