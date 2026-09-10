cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%

set SONAR_TOOL=C:\projects\debug\code_base_firmware\source\projects\sonar\sonar.exe

set options=
set option=%options%; sonar_v_sound 0 340.45
set options=%options%; ll dds notice
set options=%options%; ll wav notice  
set options=%options%; aperture_synthesis_n_rec

%SONAR_TOOL% %options%

 
