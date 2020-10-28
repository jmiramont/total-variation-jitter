% Voice synthesis with model 1 (iid perturbations).
clear all
close all

%% Parameters for jitter range: 0.2 - 1.2 (Non-Pathological Voices)
jitter_in = linspace(0.2,1.2,250);

%% Parameters for jitter range: 1 - 15 (Pathological Voices)
%jitter_in = linspace(1,15,250); % iid 1_15

%% Other parameters
fs = 50000; % Sampling Frequency.
Npot2 = 2^floor(log2(fs));
T = 1*Npot2/fs; % Duration in seconds.
F0 = 100; % Desired average period length.
K = 100; % Number of signals to sinthesize.
Y = [];
sPer = [];
jitter_real = [];
T0s = [];
scurr = rng;

%% Voice sinthesis
for i = 1:length(jitter_in)
    [y,jitt_loc,s,T0_original] = sintetizador1(jitter_in(i),T,fs,K,F0);
    [~,ind] = min(abs(jitt_loc-jitter_in(i)));
    jitt_loc = jitt_loc(ind);
    
    while jitt_loc > 15
        [y,jitt_loc,s,T0_original] = sintetizador1(jitter_in(i),T,fs,K,F0);
        [~,ind] = min(abs(jitt_loc-jitter_in(i)));
        jitt_loc = jitt_loc(ind);
    end
    
    y = y(ind,:);
    T0_original = T0_original(ind);
    sPer{i} = s{ind};
    Y = [Y; y];
    jitter_real = [jitter_real; jitt_loc];
    T0s = [T0s; T0_original'];
end
% Check the jitter obtained visually.
% figure(); plot(jitter_in,jitter_in,'--'); hold on; plot(jitter_in, jitter_real)

%% Save for use later.
%save('SENALES_iid_SET2_200Hz.mat');