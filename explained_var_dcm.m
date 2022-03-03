function [x] = explained_var_dcm(DCM)

pss=sum(sum(sum(abs(spm_vec(DCM.Hc)).^2)));
rss=sum(sum(sum(abs(spm_vec(DCM.Rc)).^2)));
x= 100*pss/(rss+pss);

end