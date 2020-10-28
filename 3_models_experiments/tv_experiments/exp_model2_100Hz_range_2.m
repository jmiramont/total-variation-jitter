function exp_model2_100Hz_range_2()
load SENALES_ar_100Hz_1_15_nuevas.mat
for  k  = 1:size(Y,1)
    disp(k);
    [jitt_tv(k,:),jitt_mod(k),~,h(k),T0_estim(k)]  =...
        jitterTV(Y(k,:),fs,sPer{k});   
    if mod(k,10) == 0
        save('resultados_senales_ar_100Hz_1_15_1MOD.mat',...
            'jitt_tv','jitt_mod','jitter_real','h','T0_estim');
    end
end
end
