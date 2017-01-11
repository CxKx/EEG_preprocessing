%% PrepProcessing EEG data (including lots of visual inspection and manual selection)
% requires eeglab
% includes manual artifact rejection & channel selection

Partic=[1:20]; %participants total
partic=20; %current participant


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load and Clean Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%Load Raw Data
EEG = pop_loadbv(strcat(cd,'\RawData'), strcat(num2str(Partic(partic)), '.vhdr'));

% add channel locations
EEG.chanlocs = readlocs(strcat(cd,'\ChannelLocations'),'defaultelp', 'besa')

% take out emg channels
temp_eeg=EEG;
EEG.data=EEG.data([20,62:64],:,:);
EEG=eeg_checkset(EEG);

filename=strcat(num2str(Partic(partic)),'_EMG');
save(filename, 'EEG')

EEG=temp_eeg;
EEG.data=EEG.data([1:19,21:61],:,:);
EEG=eeg_checkset(EEG);

%% Re-reference to Average
EEG = pop_reref( EEG, []);

%  filter
EEG = pop_eegfiltnew(EEG, 0.1, [], [], 0, [], 0);
EEG = pop_eegfiltnew(EEG, [], 45, [], 0, [], 0);

% save 
filename=strcat(num2str(Partic(partic)),'_EEG');
save(filename, 'EEG')

%% Remove Bad Channlels Manually
pop_eegplot( EEG, 1, 1, 1);
figure; pop_spectopo(EEG, 1, [], 'EEG' , 'percent',15,'freq', [10 20 30],'freqrange',[2 60],'electrodes','off');
% manually select bad channels:
bad=[];
% delete channels (interpolate only after ICA)
 EEG=pop_select(EEG, 'nochannel', bad);
 

 %% Reject Break Data
 % use gui to visually inspect data and manually remove large artifacts
 eeglab redraw


 %% Run ICA
EEG=pop_runica(EEG, 'icatype', 'runica')
filename=strcat(num2str(Partic(partic)),'_EEG');
save(filename, 'EEG')

%% Remove Blink Component
pop_selectcomps(EEG, [1:35] );
%manually select blink component
EEG = pop_subcomp( EEG, [1], 0);
%[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'setname','26_ICA','gui','off'); 


%% Artifact Rejection
 % use gui to visually inspect data and manually remove remaining artifacts
eeglab redraw


%% Interpolate Removed Channels
channel_interpol=readlocs(strcat(cd,'\ChannelLocation'),'defaultelp', 'besa')
[nr_chan t]=size(EEG.data);
if nr_chan < 60
    EEG=pop_interp(EEG,channel_interpol,'spherical');
    filename=strcat(num2str(Partic(partic)),'_EEG');
    save(filename, 'EEG')
end

