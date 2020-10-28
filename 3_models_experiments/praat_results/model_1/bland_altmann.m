function [difmedia, uloa, lloa, CI] = bland_altmann(x,x_hat,varargin)


% Default parameters.
USEX = 0;
NONPARAMETRIC = 0;
RELATIVE = 0;
ENUMERATE = 0;
ABSERROR = 0;
if nargin > 2
    for i = 1:length(varargin)
        switch varargin{i}
            case 'usex'
                USEX = 1;
            case 'nonparametric'
                NONPARAMETRIC = 1;
            case 'relative'
                RELATIVE = 1;
            case 'enumerate'
                ENUMERATE = 1;
            case 'abs'
                ABSERROR = 1;    
        end
    end
end

ejex = 0.5*(x+x_hat);
if USEX
    ejex = x;
end
[ejex,I] = sort(ejex);

if RELATIVE
    ejey = (x-x_hat)./x*100;
else
    ejey = x-x_hat;
end

if ABSERROR
    ejey = abs(ejey);
end


ejey = ejey(I);
difmedia = mean(ejey);


% Limits of Agreement
if NONPARAMETRIC
    bootfun = @(data)mean(data);
    [mediaci,bootstat] = bootci(250,{bootfun, ejey},'type','student');
    bootfun = @(data)quantile(data,0.975);
    %bootstat = bootstrp(25000,bootfun,ejey,'type','student');
    [uci,bootstat] = bootci(250,{bootfun, ejey},'type','student');
    %uloa = mean(bootstat);
    bootfun = @(data)quantile(data,0.025);
    %bootstat = bootstrp(25000,bootfun,ejey,'type','student');
    [lci,bootstat] = bootci(250,{bootfun, ejey},'type','student');
    %lloa = median(bootstat);
    lloa = quantile(ejey,0.025);    
    uloa = quantile(ejey,0.975);
else
    
    sd = std(ejey);
    uloa = difmedia + 2*sd;
    lloa = difmedia - 2*sd;
end


vlimits = max([mean(ejey)+uloa mean(ejey)-lloa]);


figure();
plot(ejex,ejey,'go','MarkerSize',1,'MarkerFaceColor','g'); hold on;
plot(ejex,difmedia*ones(size(ejex)),'--b','LineWidth',1); hold on;
plot(ejex,uloa*ones(size(ejex)),'-.r','LineWidth',1);
plot(ejex,lloa*ones(size(ejex)),'-.r','LineWidth',1);
plot(ejex,lci(1)*ones(size(ejex)),':r','LineWidth',1);
plot(ejex,lci(2)*ones(size(ejex)),':r','LineWidth',1);
plot(ejex,uci(1)*ones(size(ejex)),':r','LineWidth',1);
plot(ejex,uci(2)*ones(size(ejex)),':r','LineWidth',1);
plot(ejex,mediaci(1)*ones(size(ejex)),':b','LineWidth',1); hold on;
plot(ejex,mediaci(2)*ones(size(ejex)),':b','LineWidth',1); hold on;


plot(ejex,zeros(size(ejex)),'k');

%legend('mean','95% LoA','Location','southeast','Orientation','horizontal');

if ENUMERATE
    for i = 1:length(x)
        text(ejex(i),ejey(i),sprintf('%d',i));
    end
end


ylim([-abs(vlimits) abs(vlimits)]*1.5)
xlim([min(ejex) max(ejex)])
%xticks(round(min(ejex):max(ejex)));
grid on

xcoor = xlim();
yunit = diff(ylim())/100;

CI.uci = uci;
CI.lci = lci;
CI.mediaci = mediaci;

% Mean of the differences:
% text(xcoor(2)*0.4,difmedia+2*yunit*sign(difmedia),...
%     sprintf('$mean = %2.2f$',difmedia),'Interpreter','latex');
% % Upper Limit
% text(xcoor(2)*0.4,lloa+2*yunit*sign(lloa),...
%     ['$ 2.5\% = ' sprintf('%2.2f $',lloa)],'Interpreter','latex');
% % Lower Limit
% text(xcoor(2)*0.4,uloa+2*yunit*sign(uloa),...
%     ['$ 97.5\% = ' sprintf('%2.2f $',uloa)],'Interpreter','latex');

% % Labels
% xlabel('jitt_{real}');
% ylabel('jitt_{real}-jitt_{tv}');
% title('Jitter (Total Variation)');


