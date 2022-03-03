%%%%%% script for the sensitivities analysis
%%%%%%%%%%% and plotting%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ;clc;
% go to were DCM are stores
cd /Users/fvdsteen/data/EEG_rest/DCM_EO_EC/

fold = dir(fullfile([pwd '/DCM*results*']))
load(fold(1).name)


  % parameter indices we want (extrinsic and intrinsic)
     id = spm_find_pC(DCM,{'B' 'B_G'});               
    Pstr  = spm_fieldindices(DCM.M.pE,id);  

%%% necessary for getting the gradients of the parameter of interest (see spm_diff.m)
V = sparse(187,size(id,1))

for i = 1:size(V,2)
    
    V(id(i),i)=1
    
end
imagesc(V)

%% 
clear HCM
tel = 0
for isub = 1:length(fold)

load(fold(isub).name)
expl_d(isub)=explained_var_dcm(DCM);

if expl_d(isub)>50
tel = tel+1
HCM{tel,1} =DCM;

disp(isub);
%%% differentiate with respect to the intrinsic and extrinsic parameters. 
[dYdP{isub},y] = spm_diff(@(P,M,U)spm_csd_mtf(P,M,U),DCM.Ep,DCM.M,DCM.xU,[1],{V});
save(['/Users/fvdsteen/data/EEG_rest/DCM_sensitivity/' fold(isub).name(1:end-4) '_sensitivity'],'dYdP','dYdP2','-v7.3')
disp(isub);

else
    continue
end

end

%% get results of sensitivity analysis

tel = 0
clear x
for i = 1:length(dYdP)
    disp(i)
    if ~isempty(dYdP{i})
        tel = tel+1;
        for iparam = 1:34
            %%%% get the sensitivities of the CSD
        x(tel,iparam,:) = real(dYdP{i}{iparam}{2}(:,2,2));
        end
        
  
    else
        continue
    end
    
end
%% plot results
close all
x_labels = {}%
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

x_labels = {'V1 \rightarrow lV5' 'V1 \rightarrow rV5' 'lV5 \rightarrow V1' 'rV5 \rightarrow V1' }
tel = 4;
for iroi = 1:3
    for ig = 1:10

        tel = tel+1
        x_labels{tel} = ['G' num2str(ig)]

    end
end



fh=figure
fh.WindowState = 'maximized';
id_conc = [[1:4] id_conc+4]
co = diag(BMA.Cp);
%%%%% remove outlier gradients
TF = isoutlier(x,'gesd','MaxNumOutliers', 5)
xtmp = x;
xtmp(TF) = nan;
%%%%  average sensitivities over subjects

M_sens = squeeze(nanmean(xtmp,1))
%%%% plot sensitivities
imagesc(M_sens(id_conc,:)')
%% set properties of image
ticks = get(gca,'Xtick');

cmap = cbrewer('div', 'RdBu', 200);
cmap(cmap<0) = 0;
colormap(cmap(end:-1:1,:));
set(gca,'FontSize',30)
colorbar
set(gca,'Position',[0.07   0.3500    0.85  0.45])
grid off
box off
set(gca,'Xtick',[1:35]);
% set(gca,'Xticklabels',{})
ylabel('Frequency (Hz)')
set(gca, 'XAxisLocation', 'top')
set(gca,'Xticklabels',x_labels)
 xlabel('Connectivity parameters')
ax = axes('Position',[0.07   0.15000    0.85    0.15])
grid off
box off
alpha(.1)
bar(BMA.Ep(id_conc))
set(gca,'Xtick',ticks)
xlim([0.5 34.5])
set(gca,'XTick',[])
set(gca,'FontSize',30)
set(gca,'Color','none')
grid off
box off
% print('/Users/fvdsteen/data/EEG_rest/figure_EO_vs_EC/results_sensitivity','-dpng','-r600')

