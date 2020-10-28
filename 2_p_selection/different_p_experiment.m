clear all
close all
clc

% Load signals.
load('SENALES_PRUEBA_TOTAL_100.mat') % Some test signals.

p = 3.0:0.02:3.98;

for i = 2:length(p)
    jitt_tv  = []; jitt_mod = [];
    
    for  k  = 1:size(Y,1)
        disp(i)
        disp(k)
        [jitt_tv(k,:),jitt_mod(k),T0(k)] = jitterTV_different_p(Y(k,:),fs,sPer{k},p(i));
        save(sprintf('results_%2.2f.mat',p(i)),'jitt_tv','jitt_mod','m','T0');
    end

end
