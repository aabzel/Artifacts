@echo off
cls

set command=
set command=%command%; ll akip1160 info
set command=%command%; aks 5 4.7 0.4 1
akip1160_6.exe %command%
