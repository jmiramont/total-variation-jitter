% Filtrado inverso
clear all
close all

% '43-a_n.wav' from Saarbrucken Voice Database
[x,fs] = audioread('43-a_n.wav'); 

%new_fs = 50000;
%--------------------------------------------------------------------------
% Cambiando la fs:
%x = downsample(x,3);
%new_fs = fs/3;
%N = length(x);
%x = x(1:2^floor(log2(N)));
%fs = new_fs;
%--------------------------------------------------------------------------


N =  length(x);
X = fft(x)/N;
S = abs(X);
%p =round( fs/1000 + 5);
f=linspace(0,fs/2,round(N/2));
p = round(fs/1000)+4;
%p = 45;

% Pre-enfasis
xf = filtfilt([1 -0.98],1,x);

[a,g] = lpc(x,p);

x = filter(a,1,xf);

h = freqz(1,a,f,fs);

h = abs(h)/max(abs(h));
S = S/max(S);

figure()
plot(f,abs(S(1:round(N/2)))); hold on;
plot(f,abs(h),'--r','LineWidth',2); hold on
save('coeficientes_a_50.mat','a','fs');



% figure()
% plot(x); hold on;
% plot(y);

