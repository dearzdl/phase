function [mod_f,mod_a,mod_p]=FK_apfft_afreqNoLowFreq(y,fs,Fr,ifplot)
%
% fft/apfftʱ����λ��У����+ȫƵ����Ƶ����Ƶ��У���㷨
%
% ���룺
% y���������ź�
% fs������Ƶ��
% Fr����У����Ƶ�ʣ������Ƕ��Ƶ��д��������ʽ
% ifreal���Ƿ���ʵ�ź�
% ifplot: �Ƿ����ȫ��λƵ��ͼ
% �����
% mod_f: У����Ƶ��
% mod_a: У�����ֵ
% mod_p: У������λ
%
%Ĭ��ʹ��hanning ��
%
% 2009-12-3 by qinqiang
%     
% FengKun: 2010-1-27 10:14:43
%
%fft/apfftʱ����λ��ŵ㣺
%1������ֱ����������У��������׺���λ�ף��Լ�������ɢ���ߵ�Ƶ��ƫ��У��ֵ
%2�����Էֱ���Խ��ܼ��Ķ��Ƶ�ʳɷ�
%3�������
%

bei=2;  %����ʵ�źţ��������ķ�ֵҪ��2

NFFT=floor((length(y)+1)/2);
Deltaf=fs/NFFT;

y1 = y(NFFT:2*NFFT-1);%��N����������
win =  hanning(NFFT)';
win1 = win/sum(win);%����1
y1= y1.*win1;
y1_fft = fft(y1,NFFT);  %%% FFT Cal No1 of 2
a1 = abs(y1_fft);%FFT�����
p1 = mod(phase(y1_fft)*180/pi,360);%FFT��λ��


y2 = y(1:2*NFFT-1);%��N����������
winn =  conv(win,win);%apFFT��Ҫ�����  ���
win2 = winn/sum(winn);%����1
y2= y2.*win2;
y2=y2(NFFT:end)+[0 y2(1:NFFT-1)];%���ɳ�N��apFFT��������
y2_fft = fft(y2,NFFT);  %%% FFT Cal No2 of 2
a2 = abs(y2_fft);%apFFT����� 
p2=mod( phase(y2_fft)*180/pi,360);%apFFT��λ��
df=mod((p1-p2)/180/(1-1/NFFT),1);%Ƶ��ƫ��У��ֵ


aa=(a1.^2)./(a2+eps)*bei;  %���У��ֵ
%%%Ĭ��������ɵĸ�У���׵ĵ�һ�����߱�ʾԭʼ�ź�ֱ���ɷ�
aa(1)=a1(1)*2/NFFT*bei;
p2(1)=0;
df(1)=0;
%%%%Ĭ��������ɵĸ�У���׵ĵڶ������߱�ʾԭʼ�ź��еĳ���Ƶ�ɷ�
% [a_2,f_2,p_2]=dipinjz2(y(1:round(3*NFFT/4)),fs);%���ź��еĳ���Ƶ�ɷֽ��й���
% aa(2)=a_2;
% df(2)=mod(f_2-fs/NFFT,1);
% p(2)=p_2;
%%%%%%%%%%%%%%%%%%%%%%%%%%



r=round(Fr/fs*NFFT)+1;
r1=floor(Fr/fs*NFFT)+1;
%Ŀ��Ƶ�ʵ�Ƶ��ƫ��У��ֵ      
mod_f=(r1-1+df(r))*fs/NFFT;
 
      
      %%%%%%%%%%%%%%%%%
      for i=1:length(Fr)%%%%%%%%����ֱ�����2Hzʱ�����ڹ۲�Ƶ��Fr=6.1,ʵ��Ƶ�ʵ���5.9�����
                        %%%%%%%%�����df=1.9,У��Ƶ��ȴ����floor(Fr/2)*2+df=7.9
                        %%%%%%%%������Ϊʵ��Ƶ��Ϊ5.9��ԭ���ϸó����Ĭ��Ƶ����4��6֮�䣬�����df=1.5������
                        %%%%%%%%Ӧ��Ϊ4+1.5=5.9������������Ϊ�Ĺ�ϵ�����۲�Ƶ����ΪFr=6.1������֪����
                        %%%%%%%%Ƶ�ʴ����6��8Hz֮�䣬���df=1.9,�õ������У��Ƶ�ʵ���floor(Fr/2)*2+df=7.9
                        %%%%%%%%�������һ���жϷ�����������������
          dmf=mod_f(i)-Fr(i);
          if abs(dmf)>0.5*fs/NFFT
              mod_f(i)=mod_f(i)-sign(dmf)*fs/NFFT;
          end
      end
      
      
%Ŀ��Ƶ�ʵ����У��ֵ;
      mod_a=aa(r);
%Ŀ��Ƶ�ʵĳ���λУ��ֵ
      mod_p=p2(r);                                             %�����е����λ
      mod_p=mod_p-mod(2*pi*mod_f*(NFFT-1)/fs*180/pi,360)+90;   %���ݳ�ʼ�����λ
      mod_p=mod(mod_p,360);
      
for i=1:length(Fr)  %���⴦���Ƶ����
    if Fr(i)<2*Deltaf
        mod_f(i)=Deltaf;mod_a(i)=aa(2);
        mod_p(i)=0;
    end
end
       
 %�����������ͼ��     
if ifplot==1
    figure;
subplot(5,1,1);stem(a1,'.');title('FFT��ֵ��');ylim([0,max(a1)+0.2]);xlim([0 NFFT]);grid
subplot(5,1,2),stem(a2,'.');title('apFFTȫ��λ��ֵ��');ylim([0,max(a2)+0.2]);xlim([0 NFFT]);grid
subplot(5,1,3),stem(p2,'.');title('apFFTȫ��λ��λ��(�����е㴦��λ)');ylim([0,400]);xlim([0 NFFT]);grid
subplot(5,1,4);stem(df,'.');title('Ƶ��ƫ����');ylim([0,1]);xlim([0 NFFT]);grid
subplot(5,1,5);stem(aa,'.');title('У����ֵ��');ylim([0,max(y)+1]);xlim([0 NFFT]);grid
end
