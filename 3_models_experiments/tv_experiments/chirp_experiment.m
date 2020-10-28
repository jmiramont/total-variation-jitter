% Prueba Chirp

clear all;
%close all;


fs = 50000;
L = (2^(floor(log2(fs)))/fs);
t = 0:1/fs:L-1/fs;
N = length(t);

beta = 200;

alpha = 4;

phi = @(tau) (beta*tau+ alpha*tau.^2);

x = cos(2*pi*phi(t));

n = 0 ;
ti(1)=0;
while ti(end)<t(end)    
ti(n+1) = (-beta + sqrt(beta^2+4*alpha*n))/(2*alpha);
n = n+1 ;
end

Ti = diff(ti);
jitt_teorico = (1/beta - 1/(beta+2*alpha*L))/L  * 100;
jitt_real = mean(abs(diff(Ti)))/mean(Ti) * 100;

gamma = 0;

T0 = mean(Ti);
F0 = 1/T0;
sigma = 0.02; %4.3*T0*sqrt(2*pi)/6 * fs/N;



%%
N = length(x);
x = x-mean(x);

gamma = 0;
ft = 1:1:N/128;
bt = 1:1:N;

%% T0 estimation and extraction of the first mode.
fmin =60; % Lowest voice fundamental frequency. 
sigma_max = 4.3*sqrt(2*pi)/6 * fs/N * (1/fmin);
STFTx = mi_stft_freq(x,gamma,sigma_max,ft,bt);

% Ridge detection
I = 3; alfa = 0; beta = 0;
ridge = ridgeDetection(STFTx,I,alfa,beta);
phi_raw = (ft(ridge)-1) * fs/N;

% Reduces border effects
h = round(10*sigma_max/sqrt(2*pi)*N);
phi_raw = phi_raw(h+1:end-h);

% T0 estimation
T0 = median(1./phi_raw);

% Extracts first mode.
sigma = T0*6/sqrt(2*pi) * fs/N;
STFTx2 = mi_stft_freq(x,gamma,sigma,ft,bt);
[y_hat,~] = modeExtraction(STFTx2,ridge,N/T0/fs+1);
y_hat = real(y_hat);

%%
p=3.46;
sigma = p*T0*sqrt(2*pi)/6 * fs/N;
[STFTx,~,~,~,~,~,omega2,omega3,...
    ~,~,phi22p,phi23p,phi24p,omega4] = sstn_test_modL(y_hat,gamma,sigma,ft,bt);

%% Ridge detection
I = 3; alfa = 0; beta = 0;
ridge = ridgeDetection(STFTx,I,alfa,beta);   %(STFT,2*size(STFT,1),fmax,I);

%% IF and Chirp Rate estimation
phip_4 = zeros(1,length(ridge));
phi2p_4 = zeros(1,length(ridge));
phip_3 = zeros(1,length(ridge));
phi2p_3 = zeros(1,length(ridge));
phip_2 = zeros(1,length(ridge));
phi2p_2 = zeros(1,length(ridge));

for i = 1: length(ridge)
    phip_4(i) = (omega4(ridge(i),i)) * fs/N;
    phi2p_4(i) = - real(phi24p(ridge(i),i)) * (fs/N)^2;
    phip_3(i) = (omega3(ridge(i),i)) * fs/N;
    phi2p_3(i) = - real(phi23p(ridge(i),i)) * (fs/N)^2;
    phip_2(i) = (omega2(ridge(i),i)) * fs/N;
    phi2p_2(i) = - real(phi22p(ridge(i),i)) * (fs/N)^2;
    
end

% Reduces border effects
h = round(6*sigma/sqrt(2*pi)*N);
phip_4 = phip_4(h+1:end-h);
phi2p_4 = phi2p_4(h+1:end-h);
phip_3 = phip_3(h+1:end-h);
phi2p_3 = phi2p_3(h+1:end-h);
phip_2 = phip_2(h+1:end-h);
phi2p_2 = phi2p_2(h+1:end-h);


N2 = length(phip_4);
L2 = N2/fs;

% Estimates jitter.
jitt_tv(1,:) = sum(abs(phi2p_4./(phip_4).^2))/fs/(L2-T0)*100;
jitt_tv(2,:) = sum(abs(phi2p_3./(phip_3).^2))/fs/(L2-T0)*100;
jitt_tv(3,:) = sum(abs(phi2p_2./(phip_2).^2))/fs/(L2-T0)*100;

% Errors
error_tv(1,:) = abs(jitt_real - jitt_tv(1,:));
error_tv(2,:) = abs(jitt_real - jitt_tv(2,:));
error_tv(3,:) = abs(jitt_real - jitt_tv(3,:));

% Errors
error_tvR(1,:) = abs(jitt_real - jitt_tv(1,:))/jitt_real*100;
error_tvR(2,:) = abs(jitt_real - jitt_tv(2,:))/jitt_real*100;
error_tvR(3,:) = abs(jitt_real - jitt_tv(3,:))/jitt_real*100;

% Error
Error = abs(jitt_real - jitt_teorico)/jitt_real*100;
