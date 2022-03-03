%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%script to plot BMA results%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% plotting results of extrinsic connections
close all
co = diag(BMA.Cp);
fh=figure
fh.WindowState = 'maximized'
subplot(1,2,1)
spm_plot_ci(BMA.Ep([1:4]),co([1:4]))
x_labels = {'V1 \rightarrow lV5' 'V1 \rightarrow rV5' 'lV5 \rightarrow V1' 'rV5 \rightarrow V1' }'
set(gca,'XTickLabel', x_labels);
% set(gca,'XTickLabel', x_labels);
set(gca,'XTickLabelRotation',70)
set(gca,'FontSize',28)
xlabel('Extrinsic modulations')
ylabel('Parameter Estimate')
tick= get(gca,'XTick')
set(gca,'linewidth',2)

subplot(1,2,2)
hb=bar(BMA.Pp(1:4),'Linewidth',1.5)
x_labels = {'V1 \rightarrow lV5' 'V1 \rightarrow rV5' 'lV5 \rightarrow V1' 'rV5 \rightarrow V1' }'
set(gca,'XTickLabel', x_labels);
set(gca,'XTickLabel', x_labels);
set(gca,'XTickLabelRotation',70)
set(gca,'linewidth',2)
box off
set(gca,'FontSize',28)
xlabel('Extrinsic modulations')
ylabel('Posterior Probability')
set(gca,'XTick',tick)
set(hb, 'FaceColor',[0.8 0.8 0.8], 'EdgeColor',[0.5 0.5 0.5])
print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/results_extrinsic_connections','-dpng','-r600')
%% plotting results of intrinsic connections

close all
co = diag(BMA.Cp);
x_labels = {}
%%% reorder labels (see spm_fx_cmc for more details)
j     = [5 2 3 4 6 7 1 8 9 10];
id_conc = [];
tel = 0;
for iroi = 1:3
for ig = 1:10
tel = tel+1
id =(j(ig)-1).*3 + iroi;
id_conc = [id_conc id];
fprintf('%i\n',id)
end
end
fh=figure
fh.WindowState = 'maximized';
subplot(2,1,1)
spm_plot_ci(BMA.Ep([id_conc+4]),co([id_conc+4]))
set(gca,'XTick',[1:30])
x_labels = {}
tel = 0;
for iroi = 1:3
for ig = 1:10
tel = tel+1
x_labels{tel} = ['G' num2str(ig)]
end
end
set(gca,'XTickLabel', x_labels);
% set(gca,'XTickLabel', x_labels);
% set(gca,'XTickLabelRotation',90)
set(gca,'FontSize',20)
xlabel('Intrinsic modulations')
ylabel('Posterior Mean')
hold;plot([10.5 10.5],[-1.5 1],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5)
plot([20.5 20.5],[-1.5 1],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5)
subplot(2,1,2)
bar(BMA.Pp([id_conc+4]),'Edgecolor',[1 1 1]/2,'Facecolor',[1 1 1]*.8,'LineWidth',1.5)
set(gca,'XTick',[1:30])
set(gca,'XTickLabel', x_labels);
ylim([0 1.01])
set(gca,'FontSize',20)
box off
ax = gca;               % get the current axis
ax.Clipping = 'off';
xlim([0 31])
xlabel('Intrinsic modulations')
ylabel('Posterior probability')
hold;plot([10.5 10.5],[0 1],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5)
plot([20.5 20.5],[0 1],'--','Color',[0.4 0.4 0.4],'LineWidth',1.5)
plot([0 31],[0.95 0.95],'--','Color',[1 1/4 1/4],'LineWidth',1.5)
% print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/results_intrinsic_connections','-dpng','-r600')
