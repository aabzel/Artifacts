@echo off
::cls

set COM_NUM=4
set MODE=VOLT

set command=
set command=%command%; ll XDM1241 info
::set command=%command%; ll SerialPort info
set command=%command%; xdm1241_get %COM_NUM% %MODE%

xdm1241.exe %command%  
