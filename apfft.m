function [amps,phases] = apfft(apsignal,ansignals)

mods = mod(ansignals,2);
if mods ~= 0
    ansignals(length(ansignals)) = 0;
end
smp = ansignals/2;

sig = apsignal;

win=hanning(smp)';%������,�����һƳΪת��Ϊ������
winn=conv(win,win);%�������ľ��
win2=winn;%����������Ĺ�һ��

len = length(win2);
sig=sig(1:len).*win2;
pts = smp-1;
data1 = sig(pts:pts*2);
data0 = [0,sig(1:pts)];
sig= data0+data1;%����ΪN������FFT��������ΪAPFFT

fftsig = fft(sig,pts);
amps = abs(fftsig)*2/pts;
phases = (angle(fftsig)*180/pi);