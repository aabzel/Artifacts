@echo off
cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%

 
::ticket_set_opter.exe tsop test_tickets_market.csv.csv; tsr time* ; tsr ticket_set_opt_parse_ticket
ticket_set_opter.exe   ll TicketSetOpt  info; tsop test_tickets_market.csv
