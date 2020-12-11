function STFT = mi_stft_freq(s,gamma,sigma,ft,bt)
% Computes the STFT of a signal
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


f = 0:n-1; % Frequency partition.
S = fft(s); % Fourier transform of the function.

% Initialization
STFT = zeros(neta,n);

for j = ft-1
    g_hat = exp(-sigma^2*pi*(f-j).^2); % Fourier transform of the analysis window.
    STFT(j+1,:) = ifft(S'.*conj(g_hat)); % Filtering in frequency domain (fill the STFT row-wise)
end


end
