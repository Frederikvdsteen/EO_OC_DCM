function [out] = t_map_res(x,y,Nperm,type,prec_fun,verbose) 

%%type: 'paired-ttest';'two-sample-ttest';'one-sample'
%%Nperm: number of permutation
%%prec_fun: 'single' or 'double', precision of matrices

Nblocks = mem_block(x,y,Nperm,type,prec_fun);
scond1 = size(x);
scond2 = size(y);
mat_first = scond1(1);
mat_second = scond1(2);
prec_fun=str2func(prec_fun);
x = prec_fun(x);
y = prec_fun(y);
Nperm_tmp = floor(Nperm/Nblocks);
Nperm_vec = repmat(Nperm_tmp,[1 Nblocks]);
Nperm_vec(end) = Nperm-(Nblocks-1)*Nperm_tmp;
            if verbose
                fprintf('.........permuting data.........\n');
%                 waitbar(iblock/Nblocks)
            end
switch type
    case 'paired-ttest'
        out = [];
%         h = waitbar(0,'processing blocks....');
        for iblock = 1:Nblocks
            if verbose
                fprintf('processing block %i/%i \n',iblock,Nblocks);
%                 waitbar(iblock/Nblocks)
            end
            Nperm = Nperm_vec(iblock);
subn = prec_fun(rand(1,scond1(3),Nperm));
subn(subn<0.5) = -1;
subn(subn>=0.5) = 1;
subn_rep = repmat(subn,[mat_first *mat_second,1,1]);%%big memory mat_first*matsecond*(scond1(3)+scond2(3))*Nperm
cond1_res = reshape(x,[mat_first *mat_second scond1(3)]);
cond2_res = reshape(y,[mat_first *mat_second  scond1(3)]);
cond2_shuff = bsxfun(@times,cond2_res,subn_rep);%%big memorybig memory mat_first*matsecond*(scond1(3)+scond2(3))*Nperm
cond1_shuff = bsxfun(@times,cond1_res,-subn_rep);%%big memorybig memory mat_first*matsecond*(scond1(3)+scond2(3))*Nperm
clear subn_rep
diff = bsxfun(@minus,cond1_shuff,cond2_shuff);%%big memory
clear cond2_shuff cond1_shuff subn_rep
tmap = bsxfun(@rdivide,squeeze(mean(diff,2)),squeeze(std(diff,0,2)))*sqrt(scond1(3));
clear diff
outtmp = reshape(tmap,[mat_first mat_second Nperm]);
out = cat(3,outtmp,out);
        end
%         close(h)
clear tmap

    case 'two-sample-ttest'
        out = [];
        for iblock = 1:Nblocks
            
            if verbose
                fprintf('processing block %i/%i \n',iblock,Nblocks);
%                 waitbar(iblock/Nblocks)
            end
            Nperm = Nperm_vec(iblock);
        cond1_res = reshape(x,[mat_first *mat_second scond1(3)]);
cond2_res = reshape(y,[mat_first *mat_second scond2(3)]);
        cond_cat = cat(2,cond1_res,cond2_res);
        cond_cat_rep = repmat(cond_cat,[1 1 Nperm]); %%%%big memory:mat_first*matsecond*(scond1(3)+scond2(3))*Nperm
        tmp = [0:(scond1(3)+scond2(3)):((scond1(3)+scond2(3))*Nperm)-(scond1(3)+scond2(3))];
        [~, b]=sort(randn(Nperm,(scond1(3)+scond2(3))),2);
        tmp2 = bsxfun(@plus,b' , tmp);
tmp2_res = reshape(tmp2,[1 Nperm*((scond1(3)+scond2(3)))]);
cond_shuff = cond_cat_rep(:,tmp2_res);%%%big memory:mat_first*matsecond*(scond1(3)+scond2(3))*Nperm
clear cond_cat_rep 
cond_shuff = reshape(cond_shuff,[size(cond_cat,1) size(cond_cat,2) Nperm]);%%%big mrmory
cond1_shuff = cond_shuff(:,1:scond1(3),:);%%%big mrmory
cond2_shuff = cond_shuff(:,scond1(3)+1:end,:);%%%big mrmory
clear cond_shuff
num_t =mean(cond1_shuff,2)-mean(cond2_shuff,2);
den_t =  sqrt(var(cond1_shuff,[],2)/scond1(3) + var(cond2_shuff,[],2)/scond2(3));
tmap = squeeze(num_t)./squeeze(den_t);
outtmp =  reshape(tmap,[mat_first mat_second Nperm]);
out = cat(3,outtmp,out);
        end
    case 'one-sample'

end

end