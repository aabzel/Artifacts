cls
::echo off

set flash_tool="C:\Program Files (x86)\SEGGER\JLink\JFlash.exe"
set mcu_config=STM32F407ZG_JTAG.jflash
set firmware=olimex_stm32_h407_mbr_gcc_m.hex

set option=
set option=%option% -openprj%mcu_config% 
set option=%option% -open%firmware% 
set option=%option% -programverify 
set option=%option% -startapp  
set option=%option% -exit

%flash_tool% %option% 

