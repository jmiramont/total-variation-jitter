%% 0 - 1
clear all
SNR = 20:10:50;

for i = 1:length(SNR)
    load(sprintf('resultados_senales_iid_100Hz_0_1_con_ruido_%d.mat',SNR(i)));
    relative_error(:,i) = abs(jitt_mod-jitt_tv(:,1)');%./jitt_mod*100;
end


figure()
boxplot(relative_error);
ylim([-0.02 0.2])
xticklabels({SNR})
%ylabel('$|$relative error$|$ (\%)', 'Interpreter','latex');
xlabel('SNR ($dB$)', 'Interpreter','latex');
grid on;
%title('$[0.2\%,1.2\%]$ - TV','Interpreter','latex')
ff = gcf;
ff.set('units','centimeters','Position',[0,0,3,3]);
savefig('jitter_TV_0_1_con_ruido_absolutos.fig')
%% 1 - 15
clear all
SNR = 20:10:50;

for i = 1:length(SNR)
    load(sprintf('resultados_senales_iid_100Hz_1_15_con_ruido_%d.mat',SNR(i)));
    relative_error(:,i) = abs(jitt_mod-jitt_tv(:,1)');%./jitt_mod*100;
end

figure()
boxplot(relative_error);
xticklabels({SNR})
%ylabel('$|$relative error$|$ (\%)', 'Interpreter','latex');
xlabel('SNR ($dB$)', 'Interpreter','latex');
grid on;
%title('$[1\%,15\%]$ - TV','Interpreter','latex')
ylim([-0.25 7])
ff = gcf;
ff.set('units','centimeters','Position',[0,0,3,3]);
savefig('jitter_TV_1_15_con_ruido_absolutos.fig')
