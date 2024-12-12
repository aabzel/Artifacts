Стилистический-Анализатор: Проверка наличия комментария в конце фигурной скобки
https://habr.com/ru/articles/865536/


:: Windows cmd script
cls

set line_threshold=5
set file_name=C:/project/HAL/GPIO/gpio_drv.c 
code_style_check.exe eob %line_threshold% %file_name%
::  eob - end of block