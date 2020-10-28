function exp_model1_200Hz_range_1()
load SENALES_iid_200Hz_0_1_nuevas.mat
for  k  = 1:size(Y,1)
    disp(k);
    [jitt_tv(k,:),jitt_mod(k),~,h(k),T0_estim(k)]...
        = jitterTV(Y(k,:),fs,sPer{k});
    if mod(k,10) == 0
        save('resultados_senales_iid_200Hz_0_1_1MOD.mat',...
            'jitt_tv','jitt_mod','jitter_real','h','T0_estim');
    end
    
 end
 end

