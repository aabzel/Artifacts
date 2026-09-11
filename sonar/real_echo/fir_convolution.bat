cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%


set CONVOLUTION_FILE=convolutionFIRrx7.csv

del %CONVOLUTION_FILE%


set SONAR_TOOL=C:\projects\workspace\code_base_firmware\source\projects\sonar\sonar.exe
set SONAR_TOOL="C:\projects\debug\code_base_firmware\source\projects\sonar\sonar.exe"

cd %batdir%

set SONAR_NUM=0
set PROBING_PULSE=RefChirpTD20msFs4345Fe7655A2kSF48k.wav
set REC_FILE=Rx_7_T38393us.wav

set options= 
set options=%options% ll dds notice
set options=%options%; ll wav notice
set options=%options%; sonar_convolution_file_name %SONAR_NUM% %CONVOLUTION_FILE% 
set options=%options%; sonar_fir_convolution %PROBING_PULSE% %REC_FILE% 

%SONAR_TOOL% %options%

python plot_csv_file.py %CONVOLUTION_FILE% 15 5 DistM Corr
python plot_csv_file.py %CONVOLUTION_FILE% 15 13 DistM Log10Abs

python plot_csv_file.py %CONVOLUTION_FILE% 15 7 DistM PosCor
python plot_csv_file.py %CONVOLUTION_FILE% 15 11 DistM CorPosLog






