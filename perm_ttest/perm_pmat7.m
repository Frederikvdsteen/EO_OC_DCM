function [thres,pvals,tval, cl_th] = perm_pmat(x,y,samp,type,dir,what,correction,alph,cl_p,prec_fun,verbose)

%%%% x = data condition 1: connectivity matrix; 3de dimensions are the
%%%%
%%%% y = data condition 2
%%%data must be string pointing to the directory, variable of data files
%%%needs to be nnamed data (both conditions)
%%%samp number of permutation samples
%%%plot
%%% plot: needs to be 0 or 1 with shows the plot
% alpha2 = alph*100;

try
    load(x);
    cond1 = data;
    clear data
catch
    cond1 = x;
end

if isempty(y) ~= 1
    try
        load(y);
        cond2 = data;
        clear data;
    catch
        cond2 = y;
    end
end
try
    n = [0:0.01:5];
    
    if strcmp(type,'two-sample-ttest')
        ptmp =1-tcdf(n,size(cond1,3)+size(cond2,3)-2);
    else
        ptmp =1-tcdf(n,size(cond1,3)-1);
    end
    [~, b] = (min(abs(repmat(cl_p,1,length(n))-ptmp)));
    cl_th = n(b);
catch
    cl_th = [];
end
%% determine observed t-map
tval = t_map(cond1,cond2,type);

%% make samples
tval_samp = t_map_res(cond1,cond2,samp,type,prec_fun,verbose);
%% determine cutoff
            if verbose
                fprintf('.........thresholding statistics map.........\n');
%                 waitbar(iblock/Nblocks)
            end
for z = 1:length(correction)
 if verbose
     fprintf('thresholding %i/%i \n',z,length(correction));
 end
 if strcmp(correction{z},'analytical_uncorrected') || strcmp(correction{z},'analytical_FDR')
     [thres(:,:,z), pvals] = thres_tmap(cond1,cond2,correction{z},what,dir,alph,cl_th,prec_fun,type);
 else
[thres(:,:,z), pvals] = thres_tmap(tval,tval_samp,correction{z},what,dir,alph,cl_th,prec_fun,type);
 end
end
 if verbose
     fprintf('.....Analysis Finished.........\n');
 end
% save('pmat','pmat')
end

