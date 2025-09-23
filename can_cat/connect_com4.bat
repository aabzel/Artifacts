echo off
cls

set can_bit_rate=250000
set src_addr=0xC
set com_num=4
set dst_addr=0xD

set options_bunch=%com_num% %can_bit_rate% %src_addr% %dst_addr%
CANcat.exe  ll IsoTp debug; ccc %options_bunch%  0x112233445566778899AABBCCDDEEFF
