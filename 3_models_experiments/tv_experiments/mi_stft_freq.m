function STFT = mi_stft_freq(s,gamma,sigma,ft,bt)
% sstn : computes the STFT of a signal
%   Uses a Gaussian window.
%
% INPUTS:
%   s: real or complex signal, must be of length 2^N
%   gamma: threshold
%   sigma: window parameter
%   ft: frequency bins
%   bt: time bins
%
% OUTPUTS:
%   STFT: the short-time Fourier transform


% checking length of signal
n = length(s);
nv = log2(n);
if mod(nv,1)~=0
    warning('The signal is not a power of two, truncation to the next power');
    s = s(1:2^floor(nv));
end
n = length(s);
neta = length(ft);
s = s(:);

% Window definition
f = 0:n-1;
S = fft(s);

% Initialization
STFT = zeros(neta,n);

%Tc = 6/(sigma*sqrt(2*pi));
%myhann=@(t,T)0.5*(1+cos(2*pi*t/T)).*indicatriz(t,T);


for j = ft-1
    
    g_hat = exp(-sigma^2*pi*(f-j).^2);
    %g_hat = myhann((f-j),Tc);
    STFT(j+1,:) = ifft(S'.*conj(g_hat));
end


end

function chi = indicatriz(t,T)
chi=zeros(1,length(t));
chi(t>=-0.5*T & t<=0.5*T)=1;
end









