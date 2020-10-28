clear all
load resultados_senales_iid_200Hz_1_15_1MOD.mat
load resultados_PRAAT_senales_iid_200Hz_1_15.mat

jitterPRAAT=jitter_PRAAT_iid_200_1_15';


jitterPRAAT(jitt_mod>16) = [];
jitt_mod(jitt_mod>16) = [];

[jitt_mod,I] = sort(jitt_mod);
jitterPRAAT = jitterPRAAT(I);


[difmedia, lloa, uloa, CI] = bland_altmann(jitt_mod,jitterPRAAT,'usex','nonparametric','relative');
MAPE = mean(abs((jitt_mod-jitterPRAAT)./jitt_mod))*100;
bootfun = @(data)mean(data);
[mapeci,bootstats] = bootci(250,{bootfun,abs((jitt_mod-jitterPRAAT))./jitt_mod*100},'type','student');
% Labels
% xlabel('true jitter (\%)','Interpreter','latex');
% ylabel('RE (\%)','Interpreter','latex');
ylim([-12 70]);
xlim([1 15]);
vertlims = ylim;
yyaxis right
ylim(vertlims);
yticks(sort([lloa difmedia uloa]));
yticklabels(sort([lloa difmedia uloa]));
ytickformat('%2.2f')
set(gca,'YColor','black')
savefig('ba_PRAAT_iid_200_1_15.fig');
% close all