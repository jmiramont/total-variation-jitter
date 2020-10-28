function [y,jitt_loc,sP,T0] = sintetizador1(JD,L,fs,K,F0)

load a_coeficients ; % LPC filter coeficients

%---------------------------- Default Parameters---------------------------
% L = 1;
% fs = 50000; % Sampling Frequency.
% JD = 5; % Desired Jitter in %.
% K = 1; % Ammount of signals.
% F0 = 150; % Fundamental frequency.
%--------------------------------------------------------------------------


P0 = 1 / F0; % Desired average period length.

% Signal length that is a power of 2.
if mod(log2(L*fs),1) ~= 0
    N = 2^ceil(log2(L*fs));
    L = N/fs;
else
    N = L*fs;
end

y = zeros(K,N);
jitt_loc = zeros(K,1);
M = 2*ceil(L/P0); % Number of periods.
sP = {};
for i = 1:K
    % Period series
    u = zeros(1,N); % Signal (simulated glotic source)
    % ---------------------------------------------------------------------
    % ----------------------------- iid Model -----------------------------
    % ---------------------------------------------------------------------
    sigmap = JD * sqrt(pi) * P0 / 200;
    P = randn(1,M);
    P = normalize(P);
    P = P * sigmap;
    P = P + P0;
    
    
    % Sinthesis
    idx = 1; % Impulse index.
    for n = 1 : M
        u(idx) = 1;
        aux = P(n)*fs;
        if rand > mod(aux,1)
           idx = idx + floor(aux);
        else
           idx = idx + ceil(aux);
        end
        
        if length(u) > N
            u = u(1:N);
            P = P(1:n-1);
            break;
        end
        
    end
    
    plocs = find(u);
    realP = diff(plocs)/fs;
    q(i) = mean(abs(diff(realP)));
    T0(i) = mean(realP);
    
    u = filter(1,[1 -0.60],u);
    jitt_loc(i) = 100 * q(i) / T0(i); % Basic jitter estim.
    y_aux = filter(1,a,u);
    y_aux = filter(1,[1 -0.99],y_aux);
    
    y_aux = y_aux-mean(y_aux);
    y_aux = y_aux/max(abs(y_aux));
    
    y(i,:) = y_aux;
    sP{i} = realP;
    

    
end