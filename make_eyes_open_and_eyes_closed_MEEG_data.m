%%%% this script converts preprocessed EEGLAB data into SPM12 MEEG objacts
%%% with both EO (last 10secs) and EC (first 10secs) data stored in a single MEEG object
%%%% files for EO and EC EEGLAB cleaned data
fold = dir(fullfile(['/Users/fvdsteen/data/EEG_rest/prep_cleaned/*R01*cleaned*.set']))
files for EC data
fold2 = dir(fullfile(['/Users/fvdsteen/data/EEG_rest/prep_cleaned/*R02*cleaned*.set']))

STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];


%% 
tmp = [];
for i = 1:length(fold);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
%%%% load pre-processed EEGLAB data EO
EEG = pop_loadset('filename',fold(i).name,'filepath','/Users/fvdsteen/data/EEG_rest/prep_cleaned/');
%%% load pre-processed EEGLAB data EC
EEG2 = pop_loadset('filename',fold2(i).name,'filepath','/Users/fvdsteen/data/EEG_rest/prep_cleaned/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

%% load template MEEG object (made available at github)
D = spm_eeg_load('/Users/fvdsteen/data/EEG_rest/spm_files/test5');
%% make new MEEG object 
 D = clone(D,['/Users/fvdsteen/data/EEG_rest/spm_data/spm_meeg_' fold(i).name(1:4) '_EO_EC'],[64 size(EEG.data(:,end-1600:end),2) 2],0)
%% put the EEG data in the MEEG object  
D(:,:,1) = EEG.data(:,end-1600:end);
D(:,:,2) =EEG2.data(:,1:1601);
%% identify and set bad channels in the MEEG object
if isfield(EEG,'badchans')
    for ibad = 1:length(EEG.badchans)
    D = badchannels(D,EEG.badchans(ibad),1);
    fprintf('subject%i has bad channel',i)
    tmp = [tmp i]
    end
end
% D.save
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
end
