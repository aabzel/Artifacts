@echo off
cls

set command=
set command=%command%; ll akip1160 info
set command=%command%; aks 5 1.8 0.8 1
akip1160_6.exe %command%
