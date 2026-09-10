cls
set batdir=%~dp0
echo batdir=%batdir%
cd %batdir%

set CONVOLUTION_FILE=convAccFFT1.csv
del %CONVOLUTION_FILE%

set SONAR_TOOL=C:\projects\workspace\code_base_firmware\source\projects\sonar\sonar.exe
set SONAR_TOOL=C:\projects\debug\code_base_firmware\source\projects\sonar\sonar.exe

set SONAR_NUM=0

set options=
set options=%options%; sonar_v_sound %SONAR_NUM% 337.4
set options=%options%; ll dds notice
set options=%options%; ll Sonar notice
set options=%options%; ll wav notice
set options=%options%; sonar_convolution_file_name %SONAR_NUM% %CONVOLUTION_FILE%
set options=%options%; sonar_accumulate_fft %SONAR_NUM%

%SONAR_TOOL% %options%

python plot_csv_file.py %CONVOLUTION_FILE% 11 15 DistM RealLog2
python plot_csv_file.py %CONVOLUTION_FILE% 11 7 DistM Abs
python plot_csv_file.py %CONVOLUTION_FILE% 11 13 DistM AbsLog2
python plot_csv_file.py %CONVOLUTION_FILE% 11 3 DistM Real




