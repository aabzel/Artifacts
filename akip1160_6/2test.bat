@echo off
cls

:: akip1160_6.exe ll PLL debug; plfc 155000000
:: akip1160_6.exe  vc 10000 150000
::akip1160_6.exe plst 84000000 8000000
::akip1160_6.exe ll Pll debug;plst 72000000 8000000
:: ll BitFifo Debug;ll ARRAY Debug; ta bit_fifo
::akip1160_6.exe stm32_can_segment_calc 24000000
set command=
set command=%command%; ll akip1160 info
set command=%command%; aks 5 4.7 0.4 1
akip1160_6.exe %command%

::akip1160_6.exe    ll akip1160 Debug;vi; aks 5 4 0.4 0