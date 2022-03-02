%%%% script for semi-automaticl ICA removal and refererenceing
clear;clc;close all
cd '/home/frederik/data/EEG_rest/prep'
fold = dir(fullfile([pwd '/S*.set']))
eeglab
tel = 1;
while tel <= length(fold)

fprintf('............analysing subjec:%s number:%i\n...............\n..........',fold(tel).name,tel)    
EEG = pop_loadset('filename',fold(tel).name,'filepath','/home/frederik/data/EEG_rest/prep/');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
pop_selectcomps(EEG, [1:34] );
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = eeg_checkset( EEG );
eeglab redraw
pause

 x = input('which components to remove:   ')

EEG = pop_subcomp( EEG, x, 0);
EEG = eeg_checkset(EEG);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
eeglab redraw
EEG = eeg_checkset( EEG );
pop_eegplot( EEG, 1, 1, 1);
x = input('continue? 1 = yes 0 = no?')
if x==0
    tel =tel
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    continue

elseif x==1
  


x = input('reref? 1 = yes 0 = no?')
if x == 1
% [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_reref( EEG, []);
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
EEG = eeg_checkset( EEG );
EEG = pop_saveset( EEG, 'filename',[fold(tel).name(1:end-4) '_cleaned.set'],'filepath','/home/frederik/data/EEG_rest/prep_cleaned/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
pause
eeglab redraw
elseif x == 0 
EEG = eeg_checkset( EEG );
[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'overwrite','on','gui','off'); 
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
EEG = pop_saveset( EEG, 'filename',[fold(tel).name(1:end-4) '_not_reref.set'],'filepath','/home/frederik/data/EEG_rest/prep_cleaned/');
[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
pause
eeglab redraw
    
end
  tel = tel+1;
  end
end
