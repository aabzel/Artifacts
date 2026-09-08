cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%

set SONAR_TOOL=C:\projects\debug\code_base_firmware\source\projects\sonar\sonar.exe

set PROBING_PULSE=ProbingChirpTD20ms_fs4345fe7655_A2000_SF48k_Tx.wav
set REC1=Rx_1_UT6307us.wav
set REC2=Rx_1_UT6307us.wav

set options=
set option=%options%; sonar_v_sound 0 321.61
set options=%options%; ll dds notice
set options=%options%; ll wav notice  
set options=%options%; aperture_synthesis_2_rec %PROBING_PULSE% %REC1% %REC2% 49 51

%SONAR_TOOL% %options%

 
