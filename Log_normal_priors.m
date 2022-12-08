%%%% generate sample from the normal distribution
close all; clear;clc
var_norm = 0.25
mu = 0
r = normrnd(mu,sqrt(var_norm),[1,100000]); %%% log scaling modulatory prior with mean = 0 and variance 0.25
%%% Exponentiate simulated log-scaling parameters
scaling = exp(r);

%%% plot probability normalized empirical histogram,
close all
figure
LH(1) = histogram(scaling,'Normalization','pdf')
%%%% sort scaling variable to get 5 and 95 percebtile 
sorted = sort(scaling);
disp(['5th percentile is:' num2str(sorted(0.05*length(r))) '\n'])
disp(['5th percentile is:' num2str(sorted(0.95*length(r))) '\n'])

hold
%%% plot percentiles
plot([sorted(0.05*length(r)) sorted(0.05*length(r))],[0 0.99],'r--','linewidth',2)
plot([sorted(0.95*length(r)) sorted(0.95*length(r))],[0 0.99],'r:','linewidth',2)

ylabel('Prior density')
xlabel('Modulatory scaling parameter')
set(gca,'FontSize',16)
xlim([0 6])

%%% make Log-normal distribution and plot
pd = makedist('Lognormal','mu',0,'sigma',0.5)
x = (0:0.001:6)';
y = pdf(pd,x);

LH(2) = plot(x,y,'r','linewidth',2);

legend({'simulation based distribution','5th precentile','95th percentile','log-normal distribution'})
% print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/figure_log_normal_prior','-dpng','-r600')

