%%%%%% specifiy a DCM for each subject
% clear all;clc;close all
%% go to folder were the MEEG objects are stored

dir_feed = '/Users/fvdsteen/data/EEG_rest/spm_data'
cd(dir_feed)
fold = dir(fullfile([dir_feed '/spm_meeg*EO_EC*.mat']));
%%% load a template DCM options
load('/Users/fvdsteen/data/EEG_rest/DCM_options.mat'); %%%see github
%%
clear DCM
for i = 1:length(fold)
   
    disp(fold(i).name)
    
    
    DCM.xY.Dfile =  [fold(i).name(1:end-4)]
    DCM.options=options;% set the correct DCM options
    
    DCM.options.mod_int = 1;%%%% model intrinsic connectivity changes
    DCM.Lpos =[0 -88 4; -42 -72 0; 44 -68 0]'; %%% put the sources positions (in MNI)
    DCM.Sname = {'V1' 'lV5' 'rV5'}%% names sources
    DCM.A{1} = [1 0 0;1 0 0;1 0 0]%% set forward connections
     DCM.A{2} = [0 1 1; 0 0 0;0 0 0]%% set backward connections
     
      DCM.A{3} = zeros(3,3)%% this is currently not used but needs to be set for the code to properly run
    DCM.B{1} =ones(3,3);%% allow extrinsic connectivity modulations
    DCM.C = sparse(3,0);%%% no external input
  
  xU.X = [0;1]% 'design matrix' voor connectivity modulations
    DCM.xU = xU;
    DCM  = spm_dcm_erp_data(DCM); %% get the data  (see spm_dcm_csd)
    DCM.M.dipfit.model = 'CMC';%% specific the 'CMC models'
    DCM.M.dipfit.type  = 'IMG'; %%% 'IMG' forward model (i.e. patch)
     DCM.options.Nmodes = 4;%% number of data modes
    DCM = spm_dcm_erp_dipfit(DCM,1);%% get lead field etc. for forward models
    DCM = spm_dcm_csd_data(DCM);%% extract cross spectral densities as data features
    DCM.options.DATA = 0;%% put this option to 0, because we extracted the data feature outside this function
    DCM.M.nograph=0;%% supress visual feedback during model fitting
    %%% specify priors

    % neural priors
    [pE,pC]  = spm_dcm_neural_priors(DCM.A,DCM.B,DCM.C,DCM.options.model);
    DCM.M.pE = pE;
    DCM.M.pC = pC;
    %%% allow all intrisic connections to be estimated
    DCM.M.pE.G = sparse(length(DCM.Sname),10);
     DCM.M.pC.G = sparse(length(DCM.Sname),10)+1/8;
     %% priors on the forward model
     [DCM.M.pE,DCM.M.pC] = spm_L_priors(DCM.M.dipfit,pE,pC);
         DCM.M.pE.G = sparse(length(DCM.Sname),10);
     DCM.M.pC.G = sparse(length(DCM.Sname),10)+1/8;
     DCM.M.pE.L = zeros(6,3);
    DCM.M.pE.L(3,1) = 0.5;
    DCM.M.pE.L(1,2) = 0.5;
    DCM.M.pE.L(1,3) = 0.5;
   
    %% max number of VB iterations
   DCM.M.Nmax    = 256;
    DCM.name = [name '_sub' num2str(i,'%.3u')];
    DCM.M.nograph = 1;
    %% save specified DCM.
    save(['/Users/fvdsteen/data/EEG_rest/' name '/' name '_sub'  num2str(i,'%.3u')],'DCM')
end

% spm_dcm_csd(DCM)