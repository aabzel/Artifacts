echo off
cls

set com_num=4
set can_bit_rate=250000
set src_addr=0xC

set options_bunch=%com_num% %can_bit_rate% %src_addr% 
CANcat.exe   ccc %options_bunch%  
