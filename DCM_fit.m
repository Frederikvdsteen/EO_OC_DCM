clear;clc;close all;
cd  '/Users/fvdsteen/data/EEG_rest/DCM_EO_EC'

fold = dir(fullfile([pwd '/*.mat']));
%% paralell loop for fitting 

parfor idcm =1:length(fold)
   
        tmp = load(fold(idcm).name,'DCM');
        DCM = tmp.DCM;
        DCM = spm_dcm_csd(DCM);
        save_dcm([fold(idcm).name],DCM);
  
    
end

function [] = save_dcm(d_name,DCM)

save(d_name,'DCM');

end