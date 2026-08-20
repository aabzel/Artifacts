cls
set SONAR_TOOL=C:\projects\workspace\code_base_firmware\source\projects\sonar\sonar.exe

del convolution_1.csv

set AMPLITUDE=25000


set SIGNAL_DURATION_S=0.020
set freq1=4345
set freq2=7655
set AMPLITUDE=2000
set SAMPLE_FREQ_HZ=48000
set PLAY_DURATION_S=1.1


set options= 
:: set options=%options%; svs 0 344.3
:: set options=%options%; sonar_v_sound 0 288.3
set options=%options%; svs 0 337.4
set options=%options%; sonar_proc_rec 0 %AMPLITUDE% %SIGNAL_DURATION_S% %freq1% %freq2% Rx_3_fs_2000_fe_10000_dt39ms_A400_UT17001us.wav 

%SONAR_TOOL% %options%
:: %SONAR_TOOL% svs 0 317.0 ; sccrec 0 400 0.03 1000 10000   Rx_3_fs_1000_fe_10000_dt30ms_A400_UT16879us.wav
:: %SONAR_TOOL% sccrec 0 400 0.03 1000 10000   Rx_1_fs_1000_fe_10000_dt30ms_A400_UT11213us.wav


::TRash
 ::%SONAR_TOOL% sccrec 0 400 0.03 1000 10000 Rx_4_fs_1000_fe_10000_dt30ms_A400.wav
python  plot_csv_file.py  convolution_1.csv 15 7 Met PosCorr
python  plot_csv_file.py  convolution_1.csv 15 11 Met PosCorrLog10

python  plot_csv_file.py  convolution_1.csv 15 9 Met NegCor
python  plot_csv_file.py  convolution_1.csv 15 13 Met NegCorLog10

python  plot_csv_file.py  convolution_1.csv 15 5 Met Corr
python  plot_csv_file.py  convolution_1.csv 3 11 Time PosCorr