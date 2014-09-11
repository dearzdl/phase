function  [Cf, CA, CP]= EnergySpecphaseBasedOnMsineSigWaveForm(xt,Fs,f0)
%  ver1 2014-2-4 23:19:39  based on Energy and Cross
%  Update 2014-2-7 23:18:32
%  ReUPdate 2014-9-5 15:05:24
%  ����У��ʧ�ܷ�ֵУ�飬ʧ�ܵ���ԭʼ�׷�ֵ����
%  ���ӽ�ȡż������
%  ����
clc

%��ȡȡż������
if mod(length(xt),2) == 0
    Ns=length(xt);
else
    Ns=length(xt)-1;
    xt=xt(1:Ns);
end

df=Fs/Ns;



win = hann(Ns);
xt=2*xt.*win';                  
Xw=fft(xt-mean(xt))/(Ns);       


%%

Xf =Xw(1:Ns/2); % sig
n=1;
AfRecLambda = 1.5; %У��---����ԭʼƵ��AfRecLambda����С��ԭʼƵ��AfRecLambda-1������ΪУ��ʧ��
% No more FFT used in the following codes
[Cf0, CA0, CP0]  = Checkfc(0.5*f0,Xf,df,n,AfRecLambda);
[Cf1,  CA1, CP1] = Checkfc(f0,Xf,df,n,AfRecLambda);
[Cf2, CA2, CP2]  = Checkfc(2*f0,Xf,df,n,AfRecLambda);
[Cf3, CA3, CP3]  = Checkfc(3*f0,Xf,df,n,AfRecLambda);

CA = [CA0 CA1 CA2 CA3];
Cf = [Cf0 Cf1 Cf2 Cf3];
CP = [CP0 CP1 CP2 CP3];


function [Cf, CA, CP]= Checkfc(fc,Xf,df,n,AfRecLambda)
%%
% У��ָ��Ƶ��fc�������źŵ�����Xf
% ��Ƶ�׼���
% 

if  (n-floor(n)>0)
    disp('n must be integer! This n will be rounded!')
    n=floor(n);
end
if n>=4
    disp('n is very big, large error maybe gotten!');
end

% ���������������ҵ�fc������߷�ֵ���ߵ������ϵ�λ�á������������� %%
% fcԤ����
   if fc<=0
       disp('Error input frequency��check and input a correct one');
       Cf=0;
       CA=0;
       CP=0;
   else

       MidIndex=round(fc/df)+1;       %��fc���������λ��
       Num=1;                         %����������
       
       if MidIndex<1;
           m=1;
       else
           if (MidIndex<=Num)&&(MidIndex>1)
               Xfsub=Xf(MidIndex-1:MidIndex+Num);
          elseif (MidIndex<=Num)&&(MidIndex==1)
              Xfsub=Xf(MidIndex:MidIndex+Num);
           else
              Xfsub=Xf(MidIndex-Num:MidIndex+Num);  %ҪУ�����������������м�
           end   
              [AmaxXf,MaxI]=max(abs(Xfsub));
              m=MidIndex-Num-1+MaxI;                         %ҪУ���������ڵ������ϵ����
                      
      end
              
       %����������������ȡ��fcΪ�ο���У����Χ(����fc�������߷�ֵΪ���ģ����ҹ�2n+1��)��������������%
       if m<=n
           Cf=fc;
           CA=0;
           CP=0;      
       else
         SubRange=(m-n:m+n);
         Xfsub=Xf(SubRange);                                     %��mΪ���ĵ�У����Χ
       %������������������������������У����Ƶ�ʡ���ֵ����λ������������������������%
       Mand_i=(SubRange);
       Xabsf=abs(Xfsub);
       Cf=df*(  sum( Xabsf.^2.*Mand_i ) / sum(Xabsf.^2)  );
       Cf=Cf-df;
       CP=( angle(Xf(m))-pi*(Cf-(m)*df)/df )*180/pi-90;
       CA=sqrt( 2.66666666666667 *sum(Xabsf.^2) );
       CP=90-CP;
       if CP <= 0
           CP = CP + 360;
       end

       if (CA>= AfRecLambda * 2*AmaxXf)||(CA<= (AfRecLambda-1) * 2*AmaxXf);  % correcting failed !
           CA = 2*AmaxXf;           
       end
       
       
       if fc<=3.5*df  %���Ƶ�ʳɷ�̫��
       disp('Too low input frequency��may get meaningless result! ');
       Cf=fc;
       CA=2*AmaxXf;
       CP=0;
       end
       
       end
   end
   