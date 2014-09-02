function result = zdl_apfft(apsignal,ansignals,adblSampleFreq,adblTargetFreq)
%1. Ԫ��������2��������
mods = mod(ansignals,2);
if mods ~= 0
    n_sub = length(apsignal);
    if mod(n_sub,2) ~=0        
        n_sub = n_sub-1;
        apsignal = apsignal(1:n_sub);
    end
    
    ansignals = n_sub;
end
smp = fix(ansignals/2);
N = smp;
y = apsignal;

win = hanning(N)';
win1 = win/sum(win);    %����һ   ���ڰѼ�Ȩ��͵Ĵ����й�һ��



y1 = y(N:2*N-1);
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

ee = mod((p1-p2)/180/(1-1/N),1);    %Ƶ��ƫ�����ֵ  
df = adblSampleFreq/N;
aa = (a1.^2)./a2*2; %���У��ֵ  ΪʲôҪ����2
f1 = adblTargetFreq;
fftsig = zeros(3,3);
for i = 1:1:3
compute_x = i;
r=round(f1*compute_x/df);%�����߸���
%disp('Ƶ��У��ֵ')
fff=floor(f1*compute_x)+ee(r+1);
fftsig(i,1)=fff;
%disp('���У��ֵ')
aaa=aa(r+1);
fftsig(i,2)= aaa;
%disp('����λУ��ֵ');
ppp=p2(r+1);
fftsig(i,3)= ppp;
end 
result = fftsig;
   