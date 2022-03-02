%%%%%%%%%%%%%script for running and plotting spectral analysis
%%%% go to where cleaned data
cd /Users/fvdsteen/data/EEG_rest/prep_cleaned/
%%
fold  = dir(fullfile([pwd '/*R01_ica*cleaned*.set']))
fold2 = dir(fullfile([pwd '/*R02_ica*cleaned*.set']))
clear open closed
%%% lopen over EO
for i = 1:length(fold)
disp(i)

EEG = pop_loadset('filename',fold(i).name,'filepath','/Users/fvdsteen/data/EEG_rest/prep_cleaned/');
tmp = EEG.data(:,end-1600:end);
for ichan =1:size(tmp,1)
open(:,ichan,i) =  pwelch(tmp(ichan,:),[],[],[],160);
end
end


% loop over EC
for i = 1:length(fold2)
disp(i)
EEG = pop_loadset('filename',fold2(i).name,'filepath','/Users/fvdsteen/data/EEG_rest/prep_cleaned/');
tmp = EEG.data(:,1:1601);
for ichan =1:size(tmp,1)
closed(:,ichan,i) =  pwelch(tmp(ichan,:),[],[],[],160);
end
end
%%%% get frequencies
[~,F]=pwelch(tmp(ichan,1:1601),[],[],[],160);


%% plot topoplot of averaged
disp(F(33))
mean_open = mean(open(33,:,:),3);%%%% 33n are the results at 10Hz
mean_closed = mean(closed(33,:,:),3);
%%%% topoplot of averaged power at 10 Hz
topoplot(mean_closed-mean_open, EEG.chanlocs,'electrodes','labels')
%%%% better colormap using cbrewer
cmap = cbrewer('div', 'RdBu', 200);
cmap(cmap<0) = 0;
colormap(cmap(end:-1:1,:));
colorbar
print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/topoplot_10Hz','-dpng','-r600')
%%  plot spectral response over posterior electrodes
chan_id = [56 61 62 60 63];%%%% channel ID's
plot_end = 145;%%% only plot up to 45Hz
%%% mean over subs and channels of interest
mean_open = mean(mean(open(:,chan_id,:),2),3);
mean_closed = mean(mean(closed(:,chan_id,:),2),3);
%%% get variance of channels of interest
var_closed = var(squeeze(mean(closed(:,chan_id,:),2))')/109
var_open = var(squeeze(mean(open(:,chan_id,:),2))')/109
ci    = spm_invNcdf(1 - 0.05);   

 %construct confidence intervals
c_closed = ci*sqrt(var_closed);
c_open = ci*sqrt(var_open);
% create figure
close all
figure
fill([F(1:plot_end)', F(plot_end:-1:1)'],[mean_open(1:plot_end)'+c_open(1:plot_end),...
    mean_open(plot_end:-1:1)'-c_open(plot_end:-1:1)],[.95 .95 1],'EdgeColor',[.8 .8 1])
   hold
plot(F(1:plot_end),mean_open(1:plot_end),'b','Linewidth',2)

fill([F(1:plot_end)', F(plot_end:-1:1)'],[mean_closed(1:plot_end)'+c_closed(1:plot_end),...
    mean_closed(plot_end:-1:1)'-c_closed(plot_end:-1:1)],[0.9255    0.4667    0.4667],'EdgeColor',[.85 0 0])
%   
plot(F(1:plot_end),mean_closed(1:plot_end), 'col', [0.4863    0.1451    0.1451],'Linewidth',2)
legend({'.95MSE Eyes open' 'Mean Eyes open' '.95MSE Eyes closed' 'Mean Eyes closed'})
sign_dif = zeros(size(b))
sign_dif(b<0.005) = 5
xlabel('Frequency')
ylabel('Power')
set(gca,'FontSize',16)
set(gcf,'Color',[1 1 1])
set(gca,'Box','off')
print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/spectrum_posterior_electrodes','-dpng','-r600')

%% non parametric statistics/load thresholded tmap for the statistics
condition1 = closed;
condition2 = open;
%%% the line of code below performs non-parametric stats test, commented
%%% here for speed.
% wrapper_perm(condition1,condition2,5000,'paired-ttest','both','all',{'FDR'},0.05,0.05,'single',1,'stats_EC_VS_OPEN',1)
load('/Users/fvdsteen/data/EEG_rest/stats_EC_VS_OPEN.mat')
close all
imagesc(Analysis.correction.FDR.thres);
cmap = cbrewer('div', 'RdBu', 200);
cmap(cmap<0) = 0;
colormap(cmap(end:-1:1,:));
colorbar;
set(gca,'YTick',4:10:146)
set(gca,'YTicklabels',num2str(round(F(4:10:146))))%% set rounded frequencies
set(gca,'FontSize',20)
ylabel('Frequency (Hz)')
xlabel('Channel')
print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/spectral_thresholded_t-image','-dpng','-r600')
