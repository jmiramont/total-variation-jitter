clear all
close all
load resultados_senales_ar_200Hz_0_1_1MOD.mat
load resultados_PRAAT_senales_ar_200Hz_0_1.mat

jitterPRAAT=jitter_PRAAT_ar_200_0_1';

jitt_mod(isnan(jitt_tv))= [];
jitterPRAAT(isnan(jitt_tv))= [];


jitterPRAAT(jitt_mod<0.2) = [];
jitt_mod(jitt_mod<0.2) = [];
jitterPRAAT(jitt_mod>1.3) = [];
jitt_mod(jitt_mod>1.3) = [];

[jitt_mod,I] = sort(jitt_mod);
jitterPRAAT = jitterPRAAT(I);

[difmedia, lloa, uloa, CI] = bland_altmann(jitt_mod,jitterPRAAT,'usex','nonparametric','relative');
MAPE = mean(abs((jitt_mod-jitterPRAAT)./jitt_mod))*100;
bootfun = @(data)mean(data);
[mapeci,bootstats] = bootci(250,{bootfun,abs((jitt_mod-jitterPRAAT))./jitt_mod*100},'type','student');

% Labels
% xlabel('true jitter (\%)','Interpreter','latex');
% ylabel('R.E. (\%)','Interpreter','latex');
ylim([-13 0.5]);
xlim([0.2 1.2]);
xticks([0.4 0.8 1.2])
xticklabels([0.4 0.8 1.2])
vertlims = ylim;
yyaxis right
ylim(vertlims);
yticks(sort([lloa difmedia uloa]));
yticklabels(sort([lloa difmedia uloa]));
ytickformat('%2.2f')
set(gca,'YColor','black')
savefig('ba_PRAAT_ar_200_0_1.fig');
%close all

