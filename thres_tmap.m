function [thres, pval] = thres_tmap(tval,tval_samp,correction,what,dir,alph,cthres,prec_fun,type)
%%tval: observed test statistic map
%%tval_samp: permuted samples of tmap
%%correction: apply multiple comparisons correction: 'uncorrected',
%%'perm-based', 'FDR','cluster-size','cluster-max','cluster-sum'
%%what:'all' , 'all-nodiag', 'tria'
%%dir: direction of test: 'bigger','smaller','both'
%%alph: correction threshold
%%cthres = cluster threshold(tval)
%% calculate uncorrected non parametric pvalue
switch dir
    case 'bigger'
        tmp = bsxfun(@ge,tval_samp,tval);
        pval = (sum(tmp,3))/size(tval_samp,3);
        
    case 'smaller'
        tmp = bsxfun(@lt,tval_samp,tval);
        pval = (sum(tmp,3))/size(tval_samp,3);
    case 'both'
        tmp1 = bsxfun(@ge,tval_samp,abs(tval));
        tmp2 = bsxfun(@lt,tval_samp,-abs(tval));
        pval = (sum(tmp1,3))/size(tval_samp,3) + (sum(tmp2,3))/size(tval_samp,3);
        
end
prec_fun=str2func(prec_fun);

%% get logical indices of elements in matrix
switch what
    case 'all'
        ind =  logical(ones(size(tval,1),size(tval,2)));
    case 'all-nodiag'
        ind = logical(ones(size(tval,1),size(tval,2)))-diag(diag(logical(ones(size(tval,1),size(tval,2)))));
    case 'tria'
        ind = triu(logical(ones(size(tval,1),size(tval,2))),1);
end
pval(~ind) = nan;
try
pval(isnan(tval)) =nan;
catch
end
%% calculation of analytical pval
if strcmp(correction,'analytical_uncorrected')||strcmp(correction,'analytical_FDR')
    cond1_res = reshape(tval,[size(tval,1)*size(tval,2) size(tval,3)] );
    try
        cond2_res = reshape(tval_samp,[size(tval_samp,1)*size(tval_samp,2) size(tval_samp,3)]);
    catch
    end
    switch type
        case 'paired-ttest'
            switch dir
                case 'both'
                    [H,P,CI,STATS] = ttest(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','both');
                case 'bigger'
                    [H,P,CI,STATS] = ttest(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','right');
                case 'smaller'
                    [H,P,CI,STATS] = ttest(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','left');
            end
        case 'two-sample-ttest'
            switch dir
                case 'both'
                    [H,P,CI,STATS] = ttest2(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','both');
                case 'bigger'
                    [H,P,CI,STATS] = ttest2(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','right');
                case 'smaller'
                    [H,P,CI,STATS] = ttest2(cond1_res,cond2_res,'dim',2,'alpha', alph,'tail','left');
            end
        case 'one-sample-ttest'
            switch dir
                case 'both'
                    [H,P,CI,STATS] = ttest(cond1_res,0,'dim',2,'alpha', alph,'tail','both');
                case 'bigger'
                    [H,P,CI,STATS] = ttest(cond1_res,0,'dim',2,'alpha', alph,'tail','right');
                case 'smaller'
                    [H,P,CI,STATS] = ttest(cond1_res,0,'dim',2,'alpha', alph,'tail','left');
            end
    end
    if strcmp(correction,'analytical_FDR')
    thres = reshape(STATS.tstat,[size(tval,1) size(tval,2)]);
        pvaltmp = reshape(P,[size(tval,1) size(tval,2)]);
                [h, ~, ~]=fdr_bh(pvaltmp,alph);
        h(isnan(h)) = 0;
        thres(~h) = 0;
        thres(~ind) = nan;
        
    elseif strcmp(correction,'analytical_uncorrected')
    thres = reshape(STATS.tstat,[size(tval,1) size(tval,2)]);
    thres(isnan(thres)) = 0;
    H(isnan(H)) = 0;
    thres(~reshape(H,[size(tval,1) size(tval,2)])) = 0;
    end
    pval = reshape(P,[size(tval,1) size(tval,2)]);
end

%% threshold

switch correction
    case 'uncorrected'
        
        thres = tval;
        thres(pval>alph) = 0;
        thres(~ind) = nan;
        
        
    case 'perm_based'
        thres = tval;
        ind_rep = repmat(ind,[1 1 size(tval_samp,3)]);
        tval_samp(~ind_rep) = nan;
        switch dir
            case 'bigger'
                max_t = squeeze(max(max(tval_samp)));
                perm_thres = prctile(max_t,100-100*alph);
                thres(tval<perm_thres) = 0;
                
            case 'smaller'
                min_t = squeeze(min(min(tval_samp)));
                perm_thres = prctile(min_t,100*alph);
                thres(tval>perm_thres) = 0;
            case 'both'
                min_t = squeeze(min(min(tval_samp)));
                max_t = squeeze(max(max(tval_samp)));
                perm_thres1 = prctile(min_t,100*(alph/2));
                perm_thres2 = prctile(max_t,100-100*(alph/2));
                thres(abs(tval)<perm_thres2) = 0;
                thres(-abs(tval)>perm_thres1) = 0;
                
        end
        thres(~ind) = nan;
    case 'FDR'
        thres = tval;
        
        [h, ~, ~]=fdr_bh(pval,alph);
        h(isnan(h)) = 0;
        thres(~h) = 0;
        thres(~ind) = nan;
    case 'cluster_size'
        
        thres = zeros(size(tval,1),size(tval,2));
        tval_c=tval;
        tval_c(~ind) = 0;
        [out, num_el, freemem] = mem_block(tval,tval_samp,size(tval_samp,3),'cluster_size',func2str(prec_fun));
        switch dir
            case 'bigger'
                cthres_rep = prec_fun(repmat(cthres,[size(tval_samp,1) size(tval_samp,2) size(tval_samp,3)]));
                tval_c(tval_c<cthres) = 0;
                try
                obs_cl = bwconncomp(tval_c);
                c_extent = zeros(1,obs_cl.NumObjects);
                for i =1:obs_cl.NumObjects
                    c_extent(1,i) = length(obs_cl.PixelIdxList{i});
                end
                catch
                    c_extent = 0;
                end
                cl_ini = bsxfun(@ge,tval_samp,cthres_rep);
                clear cthres_rep
                tval_samp_thres = tval_samp;
                clear tval_samp
                tval_samp_thres(~cl_ini) = 0;
                for z = 1:size(cl_ini,3)
                    %                     disp(z);
                    try
                    cl_tmp = bwconncomp(tval_samp_thres(:,:,z));
                    clear cl_res;
                    for k =1:cl_tmp.NumObjects
                        cl_res(k) = length(cl_tmp.PixelIdxList{k});
                    end
                    
                        cl_max(z) = max(cl_res);
                    catch
                        cl_max(z) = 0;
                    end
                end
                
                cl_prtil = prctile(cl_max,100-100*alph);
                try
                id_cl = cell2mat(obs_cl.PixelIdxList(c_extent>cl_prtil)');
                thres(id_cl) = tval_c(id_cl);
                catch
                           thres = zeros(size(tval,1), size(tval,2))     ;    
                end
            case 'smaller'
                cthres_rep = prec_fun(repmat(cthres,[size(tval_samp,1) size(tval_samp,2) size(tval_samp,3)]));
                tval_c(tval_c>-cthres) = 0;
                obs_cl = bwconncomp(tval_c);
                c_extent = zeros(1,obs_cl.NumObjects);
                for i =1:obs_cl.NumObjects
                    c_extent(1,i) = length(obs_cl.PixelIdxList{i});
                end
                cl_ini = bsxfun(@lt,tval_samp,-cthres_rep);
                clear cthres_rep
                tval_samp_thres = tval_samp;
                clear tval_samp
                tval_samp_thres(~cl_ini) = 0;
                for z = 1:size(cl_ini,3)
                    %                     disp(z);
                    cl_tmp = bwconncomp(tval_samp_thres(:,:,z));
                    clear cl_res;
                    for k =1:cl_tmp.NumObjects
                        cl_res(k) = length(cl_tmp.PixelIdxList{k});
                    end
                    try
                        cl_max(z) = max(cl_res);
                    catch
                        cl_max(z) = 0;
                    end
                end
                
                cl_prtil = prctile(cl_max,100-100*alph);
                
                id_cl = cell2mat(obs_cl.PixelIdxList(c_extent>cl_prtil)');
                thres(id_cl) = tval(id_cl);
            case 'both'
                cthres_rep = prec_fun(repmat(cthres,[size(tval_samp,1) size(tval_samp,2) size(tval_samp,3)]));
                tval_c(tval_c<cthres) = 0;
                obs_cl = bwconncomp(tval_c);
                c_extent = zeros(1,obs_cl.NumObjects);
                for i =1:obs_cl.NumObjects
                    c_extent(1,i) = length(obs_cl.PixelIdxList{i});
                end
                
                cl_ini = bsxfun(@ge,tval_samp,cthres_rep);
                clear cthres_rep
                tval_samp_thres = tval_samp;
                tval_samp_thres(~cl_ini) = 0;
                for z = 1:size(cl_ini,3)
                    %                     disp(z);
                    cl_tmp = bwconncomp(tval_samp_thres(:,:,z));
                    clear cl_res;
                    for k =1:cl_tmp.NumObjects
                        cl_res(k) = length(cl_tmp.PixelIdxList{k});
                    end
                    try
                        cl_max(z) = max(cl_res);
                    catch
                        cl_max(z) = 0;
                    end
                end
                
                cl_prtil = prctile(cl_max,100-100*(alph/2));
                clear cl_max
                id_cl = cell2mat(obs_cl.PixelIdxList(c_extent>cl_prtil)');
                thres(id_cl) = tval_c(id_cl);
                
                tval_c=tval;
                tval_c(tval_c>-cthres) = 0;
                obs_cl = bwconncomp(tval_c);
                c_extent = zeros(1,obs_cl.NumObjects);
                for i =1:obs_cl.NumObjects
                    c_extent(1,i) = length(obs_cl.PixelIdxList{i});
                end
                clear tval_samp_thres
                cthres_rep = repmat(cthres,[size(tval_samp,1) size(tval_samp,2) size(tval_samp,3)]);
                cl_ini = bsxfun(@lt,tval_samp,-cthres_rep);
                clear cthres_rep
                tval_samp_thres = tval_samp;
                tval_samp_thres(~cl_ini) = 0;
                for z = 1:size(cl_ini,3)
                    %                     disp(z);
                    cl_tmp = bwconncomp(tval_samp_thres(:,:,z));
                    clear cl_res;
                    for k =1:cl_tmp.NumObjects
                        cl_res(k) = length(cl_tmp.PixelIdxList{k});
                    end
                    try
                        cl_max(z) = max(cl_res);
                    catch
                        cl_max(z) = 0;
                    end
                end
                
                cl_prtil = prctile(cl_max,100-100*(alph/2));
                
                id_cl = cell2mat(obs_cl.PixelIdxList(c_extent>cl_prtil)');
                thres(id_cl) = tval(id_cl);
                
        end
        
end


thres(~ind) = 0;
thres(isnan(thres)) = 0;
end