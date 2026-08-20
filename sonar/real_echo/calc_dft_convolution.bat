cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%

del convolutionDFT.csv

set SONAR_TOOL=C:\projects\debug\code_base_firmware\source\projects\sonar\sonar.exe
set SONAR_TOOL=C:\projects\workspace\code_base_firmware\source\projects\sonar\sonar.exe

set SONAR_NUM=0
set PROBING_PULSE=ChirpTD20msFs4345Fe7655A2000SF48kFIR.wav
set REC_FILE=Rx_3_fs_2000_fe_10000_dt39ms_A400_UT17001us.wav

set options= 
set options=%options%; sonar_v_sound 0 337.4
set options=%options%; ll dds notice
set options=%options%; ll Sonar notice
set options=%options%; ll wav notice
set options=%options%; sonar_dft_convolution %PROBING_PULSE% %REC_FILE%

%SONAR_TOOL% %options%

python plot_csv_file.py convolutionDFT.csv 1 7 TimeS Abs
python plot_csv_file.py convolutionDFT.csv 1 9 TimeS Arg
python plot_csv_file.py convolutionDFT.csv 1 3 TimeS Real
python plot_csv_file.py convolutionDFT.csv 1 5 TimeS Image




