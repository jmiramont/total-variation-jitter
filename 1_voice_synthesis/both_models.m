% Voice synthesis with model 1 and 2
clear all
close all


% Parameters
jitter_in = [linspace(0.2,1.2,25) linspace(1,15,25)];
param_in = [linspace(0.001,0.025,25) linspace(0.04,0.27,25)];

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

% Sintetizo voces
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
    s = s(ind);
    
    sPer = [sPer s];
    
    Y = [Y; y];
    jitter_real = [jitter_real; jitt_loc];
    T0s = [T0s; T0_original'];
    
    % Model ar
    
    param = param_in(i);
    [y,jitt_loc,s,T0_original,~] = sintetizador2(param,T,fs,K,F0);
    [aerror,ind] = min(abs(jitt_loc-jitter_in(i)));
    error = jitt_loc(ind)-jitter_in(i);
    
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
    y = y(ind,:);
    T0_original = T0_original(ind);
    s = s(ind);
    sPer = [sPer s];
    Y = [Y; y];
    jitter_real = [jitter_real; jitt_loc];
    T0s = [T0s; T0_original'];
end

%save('SENALES_PRUEBA_TOTAL_100.mat')
