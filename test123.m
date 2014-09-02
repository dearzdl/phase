close all;clc;clear all;

N=256;%���ڹ̶��ڸ����ݵ���
t=-N+1:N+1;
f1=19.3;
a1=2.90;
a2=0;
a3=0;
a4=0;
ph1=3.1;
ph2=0;
ph3=0;
ph4=0;
ComputeIndex = 2;
y= a1*cos(2*pi*t*f1/N+ph1*pi/180)   +a2*cos(2*pi*t*f1*2/N+ph2*pi/180)   +a3*cos(2*pi*t*f1*3/N+ph3*pi/180)   +a4*cos(2*pi*t*f1*0.5/N+ph4*pi/180);
y1 = y(N:2*N-1);    
win = hanning(N)';
win1 = win/sum(win);    %����һ   ���ڰѼ�Ȩ��͵Ĵ����й�һ��
y11 = y1.*win1;
y11_fft = fft(y11,N);%��N���FFT����
a1 = abs(y11_fft);  %FFT�����
p1 = mod(phase(y11_fft)*180/pi,360);   %FFT��λ�� angle(v)Ҳ������  

%�ٽ���apFFT��������
y2 = y(1:2*N-1);    %2N-1����������
win = hanning(N)';
winn = conv(win,win);   %apFFT��Ҫ�����
win2 = winn/sum(winn);  %����һ
y22 = y2.*win2;
y222 = y22(N:end)+[0 y22(1:N-1)];   %���ɳ�N��apFFT��������  ���
y2_fft = fft(y222,N);
a2 = abs(y2_fft);   %apFFT�����
p2 = mod(phase(y2_fft)*180/pi,360); 
                                                                        
%У�����ļ���  
ee = mod((p1-p2)/180/(1-1/N),1);    %Ƶ��ƫ�����ֵ  
aa = (a1.^2)./a2*2; %���У��ֵ  ΪʲôҪ����2
    
subplot(5,1,1);stem(a1,'.');title('FFT amplitude spectrum');ylim([0,1]);xlim([0 N/2]); grid
subplot(5,1,2);stem(a2,'.');title('apFFT amplitude spectrum');ylim([0,1]);xlim([0 N/2]); grid
subplot(5,1,3);stem(p2,'.');title('apFFT phase spectrum');ylim([0,400]);xlim([0 N/2]); grid
subplot(5,1,4);stem(ee,'.');title('frequency correction spectrum');ylim([-1,1]);xlim([0 N/2]); grid
subplot(5,1,5);stem(aa,'.');title('amplitude correction spectrum');ylim([0,1]);xlim([0 N/2]); grid
disp('Ƶ��ԭʼֵ')
Index=round(f1*ComputeIndex)%�����߸���
disp('Ƶ��У��ֵ')
Freq=floor(f1*ComputeIndex)+ee(Index+1)
disp('���У��ֵ')
Amp=aa(Index+1)
disp('����λУ��ֵ')
Phase=p2(Index+1)




