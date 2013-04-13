clear;clc;close all
freq=5120; %sample frequence
n=32;    %sample round
f0=71.121;    %object work frequence
phase0 = 13.1244; %object phase in degree , /180*pi to get rad


dt=1/freq;
TS = n/f0;
T=0:dt:TS;
T=T(2:length(T));
smp = (length(T)/2);

win=hanning(smp)';%������,�����һƳΪת��Ϊ������
win1=win/sum(win);%��������һ��
winn=conv(win,win);%�������ľ���
win2=winn/sum(winn);%�����������Ĺ�һ��

phase0_degree = phase0/180*pi;
sig = 2*sin(2*pi*f0*T+phase0_degree)+sin(4*pi*f0*T+phase0_degree);
sig_compare = sin(2*pi*f0*T);

r=randn(1,length(sig));
a=sqrt(0.009*sum(sig.^2)./sum(sig.^2));
sig = sig+a;

subplot(3,1,1);
plot(T,sig,'r');
hold on
plot(T,sig_compare);
hold off


sig=sig.*win2;
pts = fix(smp-1);
ptsend = length(T)-pts;
sig=[0,sig(1:pts)]+sig(pts:pts*2);%����ΪN������FFT����������ΪAPFFT

sig_compare = sig_compare.*win2;
sig_compare=[0,sig_compare(1:pts)]+sig_compare(pts:pts*2);%����ΪN������FFT����������ΪAPFFT

fftsig = fft(sig,pts);
fftsig_compare = fft(sig_compare,pts);

df=freq/pts;
freqs = 0:df:freq;
amps = abs(fftsig)*2/pts;
amps_compare = abs(fftsig_compare)*2/pts;

freqNum = fix(pts/2);
freqs = freqs(1:freqNum);

[famp,findex] = max(amps);
freq0_computed = freqs(findex);

[famp_comare,findex] = max(amps_compare);
freq0_computed_compare = freqs(findex);

subplot(3,1,2);
stem(freqs,amps(1:length(freqs)),'r');
hold on;
stem(freqs,amps_compare(1:length(freqs)));
hold off

fpha = mod(phase(fftsig)*180/pi,360);
phase_computed = fpha(findex);

fpha_compare = mod(phase(fftsig_compare)*180/pi,360);
phase_computed_compare = fpha_compare(findex);

subplot(3,1,3);
plot(freqs,fpha(1:length(freqs)),'r');
hold on;
plot(freqs,fpha_compare(1:length(freqs)));


phase_diff = phase_computed - phase_computed_compare  


