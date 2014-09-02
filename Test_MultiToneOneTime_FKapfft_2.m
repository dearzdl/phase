% apfft_afreq.m���Գ���
% �Զ�Ƶ�źŽ���У��
% Update:2009-12-11 14:12:08 
%���������ԣ�����apfft�ڲ��������ǲ���Ƶ��������1ʱ������ã�����Ϊ�÷���ʵ���ȼ������������е���λ��
%��������Ƶ��Ϊ512�����������Ϊ1023ʱ���ó���Ч�����
% 
clear all;clc;close all
%
% ���ɶ�Ƶ�ʳɷַ����ź�
fs=25600;  %����Ƶ��
N=2048;
t=0:1/fs:(N-1)/fs;
f1=40.4333333;   f2=95.933333;     f3=106.833333;  f4=125.5;
a1=0.88888888;   a2=0.0;     a3=0.0;  a4=0.0;
ph1=230.11111;   ph2=50.11111;     ph3=10.11111;  ph4=30.1111;


y=a1*sin(2*pi*t*f1+ph1*pi/180)+a2*sin(2*pi*t*f2+ph2*pi/180)...
   +a3*sin(2*pi*t*f3+ph3*pi/180)+a4*sin(2*pi*t*f4+ph4*pi/180);
[Af_0,xf]=myspecfft(y,fs,1);
xlim([0 500])
%%
% У�����
clc
f10=40;
f20=98;
f30=105;
f40=2;
%
[f_mod,a_mod,p_mod]=FK_apfft_afreqNoLowFreq(y,fs,[f1 f2 f3 f4],1)
