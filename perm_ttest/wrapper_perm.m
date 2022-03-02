function [] = wrapper_perm(x,y,samp,type,dir,what,correction,alph,cl_p,prec_fun,verbose,name,plot)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%performs permutation ttest%%%%%%% 
%%%%%%%%%%%%%%%%%%%  on 2dimensional matrices   %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%  USE AT OWN RISK!!!!!!!%%%%%%%
%%%%%%%%%%%%%%%%%(.....still it's awesome...)%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%INPUTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%x = data condition 1; data must be 3d matrix with subjects in the
%%%third dimension
%%%y is second condition
%%%type is either 'paired-ttest','two-sample-ttest','one-sample'....for
%%%now only paired-ttest works 
%%%dir of ttest: 'bigger' (x>y) and 'smaller' (x<y) or 'both' (x!=y)
%%%what: 'all' (entire matrix is analysed), 'all-nodiag' (diagonal
%%%elements are not analysed) and 'all-nodiag', 'tria' (only upper triangle of matrix is analysed)
%%%correction = 'analytical_uncorrected',
%%%'analytical_FDR','uncorrected','perm_based', 'FDR' and 'cluster_size'
%%% you can put multiple in array e.g. {'uncorrected' 'FDR' 'cluster_size'}
%%%alph: alpha level of test e.g. 0.05;
%%%cl_p: clutser forming threshold : e.g. 0.05
%%%prec_fun = 'single' or 'double' best is to use 'single' which required
%%%half memory and thus half the number of blocks
%%%verbose = 1 or 0; do 1 then you will get feedback in command window.
%%%name: name of the .mat file used for saving the analysis.
%%% plot= 0 or 1. plot (or not) the thresholded maps.
Analysis.condition1 = x;
Analysis.condition2 = y;
Analysis.samp = samp;
Analysis.type = type;
Analysis.dir = dir;
Analysis.what = what;
Analysis.alph = alph;
Analysis.cluster_threshold_p = cl_p;
Analysis.precision_samples = prec_fun;
Analysis.name = name;
[thres,pvals,tval,cl_th] = perm_pmat(x,y,samp,type,dir,what,correction,alph,cl_p,prec_fun,verbose);
Analysis.observed_tvals = tval;
Analysis.cluster_threshold_tval = cl_th;
for z = 1:length(correction)
    
    
    Analysis.correction.(correction{z}).thres = thres(:,:,z);
    
end
Analysis.uncorrected_pvals = pvals;

save(name,'Analysis');

if plot
    names = fieldnames(Analysis.correction);
    figure;
    subplot(ceil(length(fieldnames(Analysis.correction))/2),2,1)
    imagesc(Analysis.correction.(names{1}).thres);
    h =title(names{1});
    set(h,'interpreter','none')
    colorbar
    switch dir
        case 'bigger'
    caxis([0 max(max(Analysis.observed_tvals))]);
        case 'smaller'
            caxis([min(min(Analysis.observed_tvals)) 0]);
        case 'both'
            caxis([min(min(Analysis.observed_tvals)) max(max(Analysis.observed_tvals))]);
    end
    for z = 2:length(fieldnames(Analysis.correction))
        
        subplot(ceil(length(fieldnames(Analysis.correction))/2),2,z)
        imagesc(Analysis.correction.(names{z}).thres);
        h =title(names{z});
        set(h,'interpreter','none')
        colorbar
            switch dir
        case 'bigger'
    caxis([0 max(max(Analysis.observed_tvals))]);
        case 'smaller'
            caxis([min(min(Analysis.observed_tvals)) 0]);
        case 'both'
            caxis([min(min(Analysis.observed_tvals)) max(max(Analysis.observed_tvals))]);
    end
    end
    
end
