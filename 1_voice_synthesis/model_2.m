% Voice synthesis with model 2 (autocorrelated perturbations).
clear all
close all

%% Parameters for jitter range: 0.2 - 1.2
% param_in = linspace(0.001,0.025,250); % Jitter de 0.2 ~ 1.2
% jitter_in = linspace(0.2,1.2,250);

%% Parameters for jitter range: 1 - 15
 param_in = linspace(0.04,0.27,250); % Jitter de 1 ~ 15
 jitter_in = linspace(1,15,250);

%% Other parameters
fs = 50000; % Sampling Frequency.
Npot2 = 2^floor(log2(fs));
T = 1*Npot2/fs; % Duration in seconds.
F0 = 200;
K = 100; % Number of signals to sinthesize for each value of JD.
Y = [];
s = [];
jitter_real = [];
T0s = [];
scurr = rng;

%% Voice sinthesis
for i = 1:length(param_in)
    param = param_in(i);
    [y,jitt_loc,s,T0_original,~] = sintetizador2(param,T,fs,K,F0);
    [aerror,ind] = min(abs(jitt_loc-jitter_in(i)));
    error = jitt_loc(ind)-jitter_in(i);
    
    % This loop controls the jitter of the synthesized voice in order to
    % fill the jitter range uniformly.
    while aerror>jitter_in(i)*0.01
        if error > 0
            param = param*0.9;
        else
            param = param*1.1;
        end
        [y,jitt_loc,s,T0_original] = sintetizador2(param,T,fs,K,F0);
        [aerror,ind] = min(abs(jitt_loc-jitter_in(i)));
        error = jitt_loc(ind)-jitter_in(i);
    end
    
    jitt_loc = jitt_loc(ind);
    fin_param(i) = param;
    
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
%save('SENALES_ar_SET2_200Hz.mat');
