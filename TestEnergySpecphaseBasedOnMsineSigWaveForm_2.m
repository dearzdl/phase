%  ����һ��FFT������У�����Ƶ�ʳɷ�
%  ver1 2014-2-4 23:19:39  based on Energy and Cross
%  Update 2014-2-7 22:40:09
%  Reupdate2014-9-5 14:40:08
clear,clc
close all
DataDir    = 'E:\�Ĵ�ʯ�����ù��̷������ͣ������2014��1��21��\740-ST-0102A 20140108����\';

Fs = 25600;
Ns0 = 8192;
Rows = 200;



DataName = 'SUD_740-ST-0102A_3H.txt';
fid =fopen([DataDir,DataName]);
VibSig = fscanf(fid, '%g', [Ns0 Rows]);   
VibSig = VibSig'.*0.1;  % Convert to um
fclose(fid);

RPM = dlmread([DataDir,'SUD_740-ST-0102A_REV1.txt']);
RPM = RPM(1:Rows);


%%
% ����У����
clc
DataNo = 150;
xt = VibSig(DataNo,:);
f0 = RPM(DataNo)/60;
[Cf, CA, CP]= EnergySpecphaseBasedOnMsineSigWaveForm(xt,Fs,f0);
myspecfft(xt,Fs,1);


%%
% ��������ʵ��2

clear,clc

DataDir ='G:\FengKun\MATLABWORK\MyGeneralFunctions\ExamplesAndTests\Spectral\Data\K4003_1H_��ʷ����ͼ\' ;
DataName = 'K4003_1H2014-08-28 152028.637.txt' ; Fs = 5120;f0 = 2986/60;

% DataDir = 'G:\FengKun\MATLABWORK\MyGeneralFunctions\ExamplesAndTests\Spectral\Data\���ַ������740ST0101B����_25600hz\';
% DataName = 'Vib740ST0101B1H_2014-08-29 225812.090.txt'; Fs = 25600;f0 = 3000/60;

% DataDir = 'G:\FengKun\MATLABWORK\MyGeneralFunctions\ExamplesAndTests\Spectral\Data\���ͻ�����4���ڲ���\';
% DataName = 'wave_001.txt';  Fs = 25600; f0 = 12.5;

xt = load ([DataDir,DataName]);

[Cf, CA, CP]= EnergySpecphaseBasedOnMsineSigWaveForm(xt,Fs,f0);  %ֱ����� 0.5X 1X 2X 3X��У�����



   