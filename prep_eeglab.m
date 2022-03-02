%%%%%%% scripts for pre-processing physionet EEG data (see manuscript for the data source)
%%% eeglab 13.3.2b was used for these purposes.
%%%% note that IC(s were manually removed from the data after running this script. 
clear;clc;close all
%%% get channel names
[~, ~, phsysionetchannels] = xlsread('/home/frederik/data/phsysionet_channels.xls','Blad1');
phsysionetchannels(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),phsysionetchannels)) = {''};
eeglab
cd /home/frederik/data/EEG_rest/raw/

%%% pre-process both EO and EC data
fold = dir(fullfile([pwd '/S*.edf']))
tel = 0;
for i = 1:length(fold);
    try
EEG = pop_fileio(['/home/frederik/data/EEG_rest/raw/' fold(i).name]);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',fold(i).name(1:end-4),'gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_select( EEG,'time',[0 60] );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
%%%% cleanline
EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:64] ,'computepower',0,'linefreqs',[60 120] ,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',1,'sigtype','Channels','tau',100,'verb',0,'winsize',4,'winstep',1);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
%%% filtering
EEG = pop_eegfiltnew(EEG, [], 1, 528, true, [], 0);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
%%% run ICA
EEG = pop_runica(EEG, 'extended',1,'interupt','on');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
eeglab redraw
for j = 1:64
EEG.chanlocs(j).labels =phsysionetchannels{j} ;end
%%% get channel locations
EEG=pop_chanedit(EEG, 'lookup','/home/frederik/Matlab_toolbox/eeglab13_3_2b/plugins/dipfit2.3/standard_BESA/standard-10-5-cap385.elp');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename', [fold(i).name(1:end-4) '_ica.set'],'filepath','/home/frederik/data/EEG_rest/prep/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
eeglab redraw
    catch
      tel = tel+1
      fprintf('an error occured for ')
      error_id{tel,1} = fold(i).name;
      error_id{tel,2} = i;
    end
end
try
save('/home/frederik/data/EEG_rest/errors_subjects','error_id')
catch
    disp('no error occured')
end