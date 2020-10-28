function [jitt_tv,jitt_mod,T0] = jitterTV_different_p(x,fs,sP,p)
% Measures voice jitter by the Total Variation method, using an estimation
% of the instantaneous frequency and the chirp rate of the signal, computed
% by means of the FSSTN operators.
% Inputs: 
%     -x: Signal.
%     -fs: Sampling frequency.
%     -sP: Original period series for true jitter comparison.
%     -p: Number of periods that fit in the analysis window.
% Outputs:
%     -jitt_tv: Voice jitter by total variation, with different SSTN orders.
%     -jitt_mod: True jitter for comparison.
%     -T0: Average fundamental period estimation.
% -------------------------------------------------------------------------
% J.M. Miramont - Universidad Nacional de Entre Rios -
% National Scientific and Technical Research Council, Argentina.
% jmiramont@conicet.gov.ar
%--------------------------------------------------------------------------

N = length(x);
x = x-mean(x);

gamma = 0;
ft = 1:1:N/128;
bt = 1:1:N;

%% T0 estimation and extraction of the first mode.
fmin = 60;
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

%% Computes FSSTN operators
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

% Reduce border effects
h = round(6*sigma/sqrt(2*pi)*N);
phip_4 = phip_4(h+1:end-h);
phi2p_4 = phi2p_4(h+1:end-h);
phip_3 = phip_3(h+1:end-h);
phi2p_3 = phi2p_3(h+1:end-h);
phip_2 = phip_2(h+1:end-h);
phi2p_2 = phi2p_2(h+1:end-h);

N2 = length(phip_4);
L2 = N2/fs;

% Estimate jitter.
jitt_tv(1,:) = sum(abs(phi2p_4./(phip_4).^2))/fs/(L2-T0)*100;
jitt_tv(2,:) = sum(abs(phi2p_3./(phip_3).^2))/fs/(L2-T0)*100;
jitt_tv(3,:) = sum(abs(phi2p_2./(phip_2).^2))/fs/(L2-T0)*100;

% True jitter for comparison.
Nh = round(h/T0/fs); 
sPmod = sP(Nh+1:end-Nh);
jitt_mod = mean(abs(diff(sPmod)))/mean(sPmod)*100;

end

