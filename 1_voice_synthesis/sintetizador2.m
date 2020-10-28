function [y,jitt_loc,sP,T0,phasef] = sintetizador2(JD,L,fs,K,F0)

load a_coeficients ; % LPC filter coeficients 

P0 = 1 / F0; % Desired average period length.

% Make sure that signal length that is a power of 2.
if mod(log2(L*fs),1) ~= 0
    N = 2^ceil(log2(L*fs));
    L = N/fs;
else
    N = L*fs;
end

y = zeros(K,N);
phasef = zeros(K,N);
dt = 1/fs;

% Model Parameters
b = JD;
PSI = 6/(2*pi);
B = 4/(2*pi);
R = 1-B/2;
a1 = 4*R.^2/(1+R.^2)*cos(PSI);
a2 = -R^2;
jitt_loc = zeros(K,1);

cosenophi = 2*R/(1+R^2)*cos(PSI);
phi = acos(cosenophi);
a0 = (1-R^2)*sin(phi);

for i = 1:K
    
    u = zeros(1,N);
    u(1) = 1;
    e = sqrt(dt)*twoPointRandomWalk(N);
    e(1) = 0;
    %z=b*e; % Correlation free model
    %z = filter(b,[1 -a1],e); % 1st order correlation.
    z = filter(a0*b,[1 -a1 -a2],e); % 2nd order correlation.

    z(1) = 0;
    Z = cumsum(z);
    n = 0:N-1;
    tita = mod(2*pi*F0*n*dt+2*pi*Z,2*pi);
    dtita =  [0 find(-diff(tita)>2*pi*0.85)];
    P = diff(dtita)*dt;
    
    % Correcting glitches:
    while ~isempty(find(P<0.5*P0,1))
        glitches = find(P<0.5*P0);
        dtita(glitches+1) = [];
        P = diff(dtita)*dt;
    end       
    
    u(dtita+1) = 1;
    u = filter(1,[1 -0.60],u);
    T0(i) = mean(P);
    jitt_loc(i) = 100 * mean(abs(diff(P))) / T0(i); % Basic jitter estim.
    y_aux = filter(1,a,u);
    y_aux = filter(1,[1 -0.99],y_aux);
    y_aux = y_aux-mean(y_aux);
    y_aux = y_aux/max(abs(y_aux));
    
    y(i,:) = y_aux(1:N);
    phasef(i,:) = tita; 
    sP{i} = P;
    
end