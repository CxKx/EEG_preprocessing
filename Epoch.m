%% Epoch EEG data (Experiment specific)
% for random dot motion task with interrupted motion (EEG2)
% conditions:
%     Difficulty:
%                 easy
%                 hard
%     Interruption:
%                 contintuous
%                 reversal
%                 stop
%     Direction:
%                 left
%                 right
%    
%load data after preprocessing
partic=1;%current participant

load(strcat(num2str(Partic(partic)),'_EEG'))




%% Deleter False Responses
%define markers
Onset={'S 12'  'S 13'  'S 14'  'S 15'  'S 22'  'S 23'  'S 24'  'S 25' 'S 32'  'S 33'  'S 34'  'S 35'  };%trial onsets
Response={'R  1' 'R  2'};
Break={ 'S 26' 'S 27' 'S 36' 'S 37'};%interruption onset

delete3=[];
deletecheck=[];
for i=2:length(EEG.event)
    if length(EEG.event(i).type)==4
        if EEG.event(i).type=='R  3'
            delete3=[delete3 i];
        elseif any(strcmp(EEG.event(i).type,Response))
%             if (length(EEG.event(i-1).type) == 8) |EEG.event(i-1).type == 'S 22' |EEG.event(i-1).type == 'S 23' |EEG.event(i-1).type == 'S 24'|EEG.event(i-1).type == 'S 25' |EEG.event(i-1).type == 'S 12' |EEG.event(i-1).type == 'S 13'  |EEG.event(i-1).type == 'S 14'  |EEG.event(i-1).type == 'S 15'  |EEG.event(i-1).type == 'S 16'  |EEG.event(i-1).type == 'S 17'    |EEG.event(i-1).type == 'S 26'  |EEG.event(i-1).type == 'S 27'  |EEG.event(i-1).type == 'S 32' |EEG.event(i-1).type == 'S 33'  |EEG.event(i-1).type == 'S 34'  |EEG.event(i-1).type == 'S 35'  |EEG.event(i-1).type == 'S 36'  |EEG.event(i-1).type == 'S 37'  
%             else
%                 deletecheck=[deletecheck, i];
%             end
              if ~(any(strcmp(EEG.event(i).type,Response)) | any(strcmp(EEG.event(i).type,Break)))
                  deletecheck=[deletecheck, i];
              end
        end
    end
end

if ~isempty(delete3) | ~isempty(deletecheck)  
    EEG.event([delete3, deletecheck])=[];   
end

filename=strcat(num2str(Partic(partic)),'_EEG');
save(filename, 'EEG')


%% Epoch
%stimulus and response locked epoching
%each condition, correct and incorrect trials. Really long annoying way to
%write it but turned out more convenient than loops



%% S-Locked
EEG = pop_epoch( EEG, {  'S 12'  'S 13'  'S 14'  'S 15'  'S 22'  'S 23'  'S 24'  'S 25' 'S 32'  'S 33'  'S 34'  'S 35'  }, [-0.2  2], 'newname', strcat(num2str(Partic(partic)),'_epochs'), 'epochinfo', 'yes');
EEG = pop_rmbase( EEG, [-200    0]);
EEG = eeg_checkset( EEG );
cd(strcat(cd,'S')
filename=strcat(num2str(Partic(partic)),'_EEG');
save(filename, 'EEG')  
cont_e_r_i=[];%continuous easy right indeces
cont_h_r_i=[];
stop_e_r_i=[];
stop_h_r_i=[];
revs_e_r_i=[];
revs_h_r_i=[];
cont_e_l_i=[];
cont_h_l_i=[];
stop_e_l_i=[];
stop_h_l_i=[];
revs_e_l_i=[];
revs_h_l_i=[];
err_cont_e_r_i=[];
err_cont_h_r_i=[];
err_stop_e_r_i=[];
err_stop_h_r_i=[];
err_revs_e_r_i=[];
err_revs_h_r_i=[];
err_cont_e_l_i=[];
err_cont_h_l_i=[];
err_stop_e_l_i=[];
err_stop_h_l_i=[];
err_revs_e_l_i=[];
err_revs_h_l_i=[];

%for stop: R doesnt follow S (interuption markers)
             
[t1 timepoints nr_epochs]=size(EEG.data);
for epoch_i=1:nr_epochs   
    for event_i=1:length(EEG.event) 
        if EEG.event(event_i).epoch==epoch_i & EEG.event(event_i).type(1)=='S' & EEG.event(event_i).type(4)~='1' & EEG.event(event_i).type(4)~='6' & EEG.event(event_i).type(4)~='7'
            if EEG.event(event_i).type== 'S 12'
                if EEG.event(event_i+1).type=='R  1' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    cont_e_r_i=[cont_e_r_i, epoch_i];
                elseif  EEG.event(event_i+1).type=='R  2' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_cont_e_r_i=[err_cont_e_r_i, epoch_i];
                end
            elseif EEG.event(event_i).type== 'S 13'
                if EEG.event(event_i+1).type=='R  2' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    cont_e_l_i=[cont_e_l_i, epoch_i];
                elseif  EEG.event(event_i+1).type=='R  1' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_cont_e_l_i=[err_cont_e_l_i, epoch_i];
                end
            elseif EEG.event(event_i).type== 'S 14'
                if EEG.event(event_i+1).type=='R  1' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    cont_h_r_i=[cont_h_r_i, epoch_i];
                elseif  EEG.event(event_i+1).type=='R  2' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_cont_h_r_i=[err_cont_h_r_i, epoch_i];
                end                      
            elseif EEG.event(event_i).type== 'S 15'
                if EEG.event(event_i+1).type=='R  2' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    cont_h_l_i=[cont_h_l_i, epoch_i];
                elseif  EEG.event(event_i+1).type=='R  1' & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_cont_h_l_i=[err_cont_h_l_i, epoch_i];
                end                     
            elseif EEG.event(event_i).type== 'S 22'
                if (EEG.event(event_i+1).type=='R  1' | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  1'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    stop_e_r_i=[stop_e_r_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  2'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_stop_e_r_i=[err_stop_e_r_i, epoch_i];
                end
            elseif EEG.event(event_i).type== 'S 23'
                if (EEG.event(event_i+1).type=='R  2' | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  2')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    stop_e_l_i=[stop_e_l_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  1' | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_stop_e_l_i=[err_stop_e_l_i, epoch_i];
                end                        
            elseif EEG.event(event_i).type== 'S 24'
                if (EEG.event(event_i+1).type=='R  1'| ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    stop_h_r_i=[stop_h_r_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  2'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_stop_h_r_i=[err_stop_h_r_i, epoch_i];
                end                         
            elseif EEG.event(event_i).type== 'S 25'
                if (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  2')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    stop_h_l_i=[stop_h_l_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  1'| ( EEG.event(event_i+1).type=='S 26' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 26' & EEG.event(event_i+2).type=='S 27' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_stop_h_l_i=[err_stop_h_l_i, epoch_i];
                end 
                elseif EEG.event(event_i).type== 'S 32'
                if (EEG.event(event_i+1).type=='R  1' | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  1'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    revs_e_r_i=[revs_e_r_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  2'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_revs_e_r_i=[err_revs_e_r_i, epoch_i];
                end
            elseif EEG.event(event_i).type== 'S 33'
                if (EEG.event(event_i+1).type=='R  2' | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  2')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    revs_e_l_i=[revs_e_l_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  1' | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_revs_e_l_i=[err_revs_e_l_i, epoch_i];
                end                        
            elseif EEG.event(event_i).type== 'S 34'
                if (EEG.event(event_i+1).type=='R  1'| ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    revs_h_r_i=[revs_h_r_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  2'))  & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_revs_h_r_i=[err_revs_h_r_i, epoch_i];
                end                         
            elseif EEG.event(event_i).type== 'S 35'
                if (EEG.event(event_i+1).type=='R  2'  | ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  2') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  2')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    revs_h_l_i=[revs_h_l_i, epoch_i];
                elseif  (EEG.event(event_i+1).type=='R  1'| ( EEG.event(event_i+1).type=='S 36' &  EEG.event(event_i+2).type=='R  1') | (EEG.event(event_i+1).type=='S 36' & EEG.event(event_i+2).type=='S 37' &  EEG.event(event_i+3).type=='R  1')) & EEG.event(event_i+1).latency >=  EEG.event(event_i).latency +180
                    err_revs_h_l_i=[err_revs_h_l_i, epoch_i];
                end 

            end
        end
    end
end
     
    cont_easy_r=pop_selectevent(EEG,'epoch',cont_e_r_i);
    cont_easy_l=pop_selectevent(EEG,'epoch',cont_e_l_i);
    cont_hard_r=pop_selectevent(EEG,'epoch',cont_h_r_i);
    cont_hard_l=pop_selectevent(EEG,'epoch',cont_h_l_i);
    stop_easy_r=pop_selectevent(EEG,'epoch',stop_e_r_i);
    stop_easy_l=pop_selectevent(EEG,'epoch',stop_e_l_i);
    stop_hard_r=pop_selectevent(EEG,'epoch',stop_h_r_i);
    stop_hard_l=pop_selectevent(EEG,'epoch',stop_h_l_i);  
    revs_easy_r=pop_selectevent(EEG,'epoch',revs_e_r_i);
    revs_easy_l=pop_selectevent(EEG,'epoch',revs_e_l_i);
    revs_hard_r=pop_selectevent(EEG,'epoch',revs_h_r_i);
    revs_hard_l=pop_selectevent(EEG,'epoch',revs_h_l_i); 
    
    %sometimes we don'z have enough error trials
    if ~isempty(err_cont_e_r_i)
        err_cont_easy_r=pop_selectevent(EEG,'epoch',err_cont_e_r_i);
    else 
        err_cont_easy_r=[];
    end
    
    if ~isempty(err_cont_e_l_i)
        err_cont_easy_l=pop_selectevent(EEG,'epoch',err_cont_e_l_i);
    else
        err_cont_easy_l=[];
    end
   
    if ~isempty(err_cont_h_r_i)
        err_cont_hard_r=pop_selectevent(EEG,'epoch',err_cont_h_r_i);
    else
        err_cont_hard_r=[];
    end
    
    if ~isempty(err_cont_h_l_i)
        err_cont_hard_l=pop_selectevent(EEG,'epoch',err_cont_h_l_i);
    else
        err_cont_hard_l=[];
    end
    
    if ~isempty(err_stop_e_r_i)
        err_stop_easy_r=pop_selectevent(EEG,'epoch',err_stop_e_r_i);
    else
        err_stop_easy_r=[];
    end
    
    if ~isempty(err_stop_e_l_i)
        err_stop_easy_l=pop_selectevent(EEG,'epoch',err_stop_e_l_i);
    else
        err_stop_easy_l=[];
    end
    
    if ~isempty(err_stop_h_r_i)
        err_stop_hard_r=pop_selectevent(EEG,'epoch',err_stop_h_r_i);
    else
        err_stop_hard_r=[];
    end
    
    if ~isempty(err_stop_h_l_i)
        err_stop_hard_l=pop_selectevent(EEG,'epoch',err_stop_h_l_i);
    else
        err_stop_hard_l=[];
    end
  
    if ~isempty(err_revs_e_r_i)
        err_revs_easy_r=pop_selectevent(EEG,'epoch',err_revs_e_r_i);
    else 
        err_revs_easy_r=[];
    end
    
    if ~isempty(err_revs_e_l_i)
        err_revs_easy_l=pop_selectevent(EEG,'epoch',err_revs_e_l_i);
    else
        err_revs_easy_l=[];
    end
   
    if ~isempty(err_revs_h_r_i)
        err_revs_hard_r=pop_selectevent(EEG,'epoch',err_revs_h_r_i);
    else
        err_revs_hard_r=[];
    end
    
    if ~isempty(err_revs_h_l_i)
        err_revs_hard_l=pop_selectevent(EEG,'epoch',err_revs_h_l_i);
    else
        err_revs_hard_l=[];
    end
    
    
    filename=strcat(num2str(Partic(partic)),'_cont_easy_r');
    save(filename, 'cont_easy_r')
    filename=strcat(num2str(Partic(partic)),'_cont_easy_l');
    save(filename, 'cont_easy_l')
    filename=strcat(num2str(Partic(partic)),'_cont_hard_r');
    save(filename, 'cont_hard_r')
    filename=strcat(num2str(Partic(partic)),'_cont_hard_l');
    save(filename, 'cont_hard_l')
    filename=strcat(num2str(Partic(partic)),'_stop_easy_r');
    save(filename, 'stop_easy_r')
    filename=strcat(num2str(Partic(partic)),'_stop_easy_l');
    save(filename, 'stop_easy_l')
    filename=strcat(num2str(Partic(partic)),'_stop_hard_r');
    save(filename, 'stop_hard_r')
    filename=strcat(num2str(Partic(partic)),'_stop_hard_l');
    save(filename, 'stop_hard_l')
    filename=strcat(num2str(Partic(partic)),'_revs_easy_r');
    save(filename, 'revs_easy_r')
    filename=strcat(num2str(Partic(partic)),'_revs_easy_l');
    save(filename, 'revs_easy_l')
    filename=strcat(num2str(Partic(partic)),'_revs_hard_r');
    save(filename, 'revs_hard_r')
    filename=strcat(num2str(Partic(partic)),'_revs_hard_l');
    save(filename, 'revs_hard_l')
    
    filename=strcat(num2str(Partic(partic)),'_err_cont_easy_r');
    save(filename, 'err_cont_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_cont_easy_l');
    save(filename, 'err_cont_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_cont_hard_r');
    save(filename, 'err_cont_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_cont_hard_l');
    save(filename, 'err_cont_hard_l')
    filename=strcat(num2str(Partic(partic)),'_err_stop_easy_r');
    save(filename, 'err_stop_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_stop_easy_l');
    save(filename, 'err_stop_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_stop_hard_r');
    save(filename, 'err_stop_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_stop_hard_l');
    save(filename, 'err_stop_hard_l')
    filename=strcat(num2str(Partic(partic)),'_err_revs_easy_r');
    save(filename, 'err_revs_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_revs_easy_l');
    save(filename, 'err_revs_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_revs_hard_r');
    save(filename, 'err_revs_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_revs_hard_l');
    save(filename, 'err_revs_hard_l')
    
    
    clear cont_easy_r cont_easy_l cont_hard_r cont_hard_l stop_easy_r stop_easy_l stop_hard_r stop_hard_l revs_easy_r revs_easy_l revs_hard_r revs_hard_l
    
    clear err_cont_easy_r err_cont_easy_l err_cont_hard_r err_cont_hard_l err_stop_easy_r err_stop_easy_l err_stop_hard_r err_stop_hard_l err_revs_easy_r err_revs_easy_l err_revs_hard_r err_revs_hard_l


    
    
%% R-Locked

clear EEG 
load(strcat(cd,num2str(Partic(partic)),'_EEG.mat'))

%% stop markers
deletecheck=[];
for i=2:length(EEG.event)
    if length(EEG.event(i).type)==4 
        if EEG.event(i).type=='S 26' |EEG.event(i).type=='S 27'|EEG.event(i).type=='S 36'|EEG.event(i).type=='S 37'
            deletecheck=[deletecheck, i];
        end
    end
end


if ~isempty(deletecheck)  
    EEG.event([ deletecheck])=[];
end
    
%find responses of itnerest and rename them
keep=[];
for event_i=3:length(EEG.event)-1
        if length(EEG.event(event_i).type)==4 &(EEG.event(event_i).type == 'R  1' | EEG.event(event_i).type == 'R  2')
            if length(EEG.event(event_i+1).type)==8 & EEG.event(event_i +1).latency <= EEG.event(event_i).latency +100
            else
                 if length(EEG.event(event_i-2).type)~=8 | (length(EEG.event(event_i-2).type)==8 & EEG.event(event_i-2).latency >= EEG.event(event_i).latency+1000)
                    if length(EEG.event(event_i-1).type)==4  & (EEG.event(event_i-1).type == 'S 22' | EEG.event(event_i-1).type == 'S 23' |EEG.event(event_i-1).type == 'S 24'|EEG.event(event_i-1).type == 'S 25' |EEG.event(event_i-1).type == 'S 12' |EEG.event(event_i-1).type == 'S 13'  |EEG.event(event_i-1).type == 'S 14'  |EEG.event(event_i-1).type == 'S 15'|EEG.event(event_i-1).type == 'S 32' |EEG.event(event_i-1).type == 'S 33'  |EEG.event(event_i-1).type == 'S 34'  |EEG.event(event_i-1).type == 'S 35'  )
                        if (EEG.event(event_i-1).latency  <  EEG.event(event_i).latency-180)  
                            %rename
                            EEG.event(event_i).type=strcat(EEG.event(event_i).type,'r');
                            EEG.event(event_i-1).type=strcat(EEG.event(event_i-1).type,'r');
                            keep=[keep, event_i];
                    end
                 end           
            end
        end
    end
end 

%epoch
cd(strcat(cd,'R')
filename=strcat(num2str(Partic(partic)),'_ready');
save(filename, 'EEG')  
[EEG_base j]= pop_epoch( EEG, {  'S 12r'  'S 13r'  'S 14r'  'S 15r'  'S 22r'  'S 23r'  'S 24r'  'S 25r'   'S 32r'  'S 33r'  'S 34r'  'S 35r'}, [-0.2  0], 'newname', strcat(num2str(Partic(partic)),'_baseline'), 'epochinfo', 'yes');
[EEG i] = pop_epoch( EEG, {  'R  1r'  'R  2r'}, [-1  0.1], 'newname', strcat(num2str(Partic(partic)),'_R'), 'epochinfo', 'yes');
[t1 timepoints nr_epochs]=size(EEG.data);
[t1 t2 nr_base]=size(EEG_base.data);

%baseline
if nr_epochs==nr_base 
    for epoch_i=1:nr_epochs
        EEG.data(:,:,epoch_i)=EEG.data(:,:,epoch_i)-repmat( mean(EEG_base.data(:,:,epoch_i),2), 1, timepoints);
    end
    cd('Z:\Stop-RDM-EEG\eeg-data\R')
    filename=strcat(num2str(Partic(partic)),'_EEG');
    save(filename, 'EEG')
else
    Participant=Partic(partic)
    disp('no match')
end


%remove 'r'from triggers
%for partic=1:length(Partic)
    clear EEG 
    load(strcat('Z:\Stop-RDM-EEG\eeg-data\R\',num2str(Partic(partic)),'_EEG.mat'))
    for event_i=1:length(EEG.event) 
        if length(EEG.event(event_i).type)==5 & EEG.event(event_i).type(5)=='r'
            if EEG.event(event_i).type=='S 12r'
                EEG.event(event_i).type='S 12';
            elseif EEG.event(event_i).type=='S 13r'
                EEG.event(event_i).type='S 13';
            elseif EEG.event(event_i).type=='S 14r'
                EEG.event(event_i).type='S 14';
            elseif EEG.event(event_i).type=='S 15r'
                EEG.event(event_i).type='S 15';
            elseif EEG.event(event_i).type=='S 22r'
                EEG.event(event_i).type='S 22';
            elseif EEG.event(event_i).type=='S 23r'
                EEG.event(event_i).type='S 23';
            elseif EEG.event(event_i).type=='S 24r'
                EEG.event(event_i).type='S 24'; 
            elseif EEG.event(event_i).type=='S 25r'
                EEG.event(event_i).type='S 25';
            elseif EEG.event(event_i).type=='S 32r'
                EEG.event(event_i).type='S 32';
            elseif EEG.event(event_i).type=='S 33r'
                EEG.event(event_i).type='S 33';
            elseif EEG.event(event_i).type=='S 34r'
                EEG.event(event_i).type='S 34'; 
            elseif EEG.event(event_i).type=='S 35r'
                EEG.event(event_i).type='S 35';
            elseif EEG.event(event_i).type=='R  1r'
                EEG.event(event_i).type='R  1';
            elseif EEG.event(event_i).type=='R  2r'
                EEG.event(event_i).type='R  2';
            end
        end
    end
    Partic(partic)
    size(EEG.data)
    filename=strcat(num2str(Partic(partic)),'_EEG');
    save(filename, 'EEG')



%divide into conds
cont_e_r_i=[];
cont_h_r_i=[];
stop_e_r_i=[];
stop_h_r_i=[];
revs_e_r_i=[];
revs_h_r_i=[];
cont_e_l_i=[];
cont_h_l_i=[];
stop_e_l_i=[];
stop_h_l_i=[];
revs_e_l_i=[];
revs_h_l_i=[];
corr_cont_e_r_i=[];
corr_cont_h_r_i=[];
corr_stop_e_r_i=[];
corr_stop_h_r_i=[];
corr_revs_e_r_i=[];
corr_revs_h_r_i=[];
corr_cont_e_l_i=[];
corr_cont_h_l_i=[];
corr_stop_e_l_i=[];
corr_stop_h_l_i=[];
corr_revs_e_l_i=[];
corr_revs_h_l_i=[];
err_cont_e_r_i=[];
err_cont_h_r_i=[];
err_stop_e_r_i=[];
err_stop_h_r_i=[];
err_revs_e_r_i=[];
err_revs_h_r_i=[];
err_cont_e_l_i=[];
err_cont_h_l_i=[];
err_stop_e_l_i=[];
err_stop_h_l_i=[];
err_revs_e_l_i=[];
err_revs_h_l_i=[];

cont_easy_r=[];
cont_easy_l=[];
cont_hard_r=[];
cont_hard_l=[];
stop_easy_r=[];
stop_easy_l=[];%pop_selectevent(EEG,'epoch',stop_e_l_i);
stop_hard_r=[];%pop_selectevent(EEG,'epoch',stop_h_r_i);
stop_hard_l=[];%pop_selectevent(EEG,'epoch',stop_h_l_i);  
revs_easy_r=[];
revs_easy_l=[];
revs_hard_r=[];
revs_hard_l=[];
clear EEG
load(strcat(cd,num2str(Partic(partic)),'_ready'))
EEG_base = pop_epoch( EEG, {  'S 12r'  'S 13r'  'S 14r'  'S 15r'  'S 22r'  'S 23r'  'S 24r'  'S 25r'  'S 32r'  'S 33r'  'S 34r'  'S 35r' }, [-0.2  0], 'newname', strcat(num2str(Partic(partic)),'_baseline'), 'epochinfo', 'yes');
%get markers from baseline epochs and use indeces on acutal epochs

        [t1 timepoints nr_epochs]=size(EEG_base.data);
        for epoch_i=1:nr_epochs   
            for event_i=1:length(EEG_base.event) 
                if EEG_base.event(event_i).epoch==epoch_i & EEG_base.event(event_i).type(1)=='S' & EEG_base.event(event_i).type(4)~='1'
                    if EEG_base.event(event_i).type== 'S 12r' 
                            cont_e_r_i=[cont_e_r_i, epoch_i];
                    elseif EEG_base.event(event_i).type== 'S 13r'
                            cont_e_l_i=[cont_e_l_i, epoch_i];
                    elseif EEG_base.event(event_i).type== 'S 14r'
                            cont_h_r_i=[cont_h_r_i, epoch_i];                
                    elseif EEG_base.event(event_i).type== 'S 15r'
                            cont_h_l_i=[cont_h_l_i, epoch_i];                   
                    elseif EEG_base.event(event_i).type== 'S 22r'
                            stop_e_r_i=[stop_e_r_i, epoch_i];
                    elseif EEG_base.event(event_i).type== 'S 23r'
                            stop_e_l_i=[stop_e_l_i, epoch_i];                       
                    elseif EEG_base.event(event_i).type== 'S 24r'
                            stop_h_r_i=[stop_h_r_i, epoch_i];                      
                    elseif EEG_base.event(event_i).type== 'S 25r'
                            stop_h_l_i=[stop_h_l_i, epoch_i];   
                    elseif EEG_base.event(event_i).type== 'S 32r'
                            revs_e_r_i=[revs_e_r_i, epoch_i];
                    elseif EEG_base.event(event_i).type== 'S 33r'
                            revs_e_l_i=[revs_e_l_i, epoch_i];                       
                    elseif EEG_base.event(event_i).type== 'S 34r'
                            revs_h_r_i=[revs_h_r_i, epoch_i];                      
                    elseif EEG_base.event(event_i).type== 'S 35r'
                            revs_h_l_i=[revs_h_l_i, epoch_i];  
                    end
                end
            end
        end
    load(strcat('Z:\Stop-RDM-EEG\eeg-data\R\',num2str(Partic(partic)),'_EEG'))  
    cont_easy_r=pop_selectevent(EEG,'epoch',cont_e_r_i);
    cont_easy_l=pop_selectevent(EEG,'epoch',cont_e_l_i);
    cont_hard_r=pop_selectevent(EEG,'epoch',cont_h_r_i);
    cont_hard_l=pop_selectevent(EEG,'epoch',cont_h_l_i);
    stop_easy_r=pop_selectevent(EEG,'epoch',stop_e_r_i);
    stop_easy_l=pop_selectevent(EEG,'epoch',stop_e_l_i);
    stop_hard_r=pop_selectevent(EEG,'epoch',stop_h_r_i);
    stop_hard_l=pop_selectevent(EEG,'epoch',stop_h_l_i);  
    revs_easy_r=pop_selectevent(EEG,'epoch',revs_e_r_i);
    revs_easy_l=pop_selectevent(EEG,'epoch',revs_e_l_i);
    revs_hard_r=pop_selectevent(EEG,'epoch',revs_h_r_i);
    revs_hard_l=pop_selectevent(EEG,'epoch',revs_h_l_i);
    
    [t1 timepoints nr_epochs]=size(cont_easy_r.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(cont_easy_r.event) 
                if cont_easy_r.event(event_i).epoch==epoch_i & cont_easy_r.event(event_i).type(1)=='R' 
                    if cont_easy_r.event(event_i).type=='R  1'
                        corr_cont_e_r_i=[corr_cont_e_r_i, epoch_i];
                    else
                        err_cont_e_r_i=[err_cont_e_r_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(cont_easy_l.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(cont_easy_l.event) 
                if cont_easy_l.event(event_i).epoch==epoch_i & cont_easy_l.event(event_i).type(1)=='R' 
                    if cont_easy_l.event(event_i).type=='R  2'
                        corr_cont_e_l_i=[corr_cont_e_l_i, epoch_i];
                    else
                        err_cont_e_l_i=[err_cont_e_l_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(cont_hard_r.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(cont_hard_r.event) 
                if cont_hard_r.event(event_i).epoch==epoch_i & cont_hard_r.event(event_i).type(1)=='R' 
                    if cont_hard_r.event(event_i).type=='R  1'
                        corr_cont_h_r_i=[corr_cont_h_r_i, epoch_i];
                    else
                        err_cont_h_r_i=[err_cont_h_r_i, epoch_i];
                    end
                end
            end
    end
        
    [t1 timepoints nr_epochs]=size(cont_hard_l.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(cont_hard_l.event) 
                if cont_hard_l.event(event_i).epoch==epoch_i & cont_hard_l.event(event_i).type(1)=='R' 
                    if cont_hard_l.event(event_i).type=='R  2'
                        corr_cont_h_l_i=[corr_cont_h_l_i, epoch_i];
                    else
                        err_cont_h_l_i=[err_cont_h_l_i, epoch_i];
                    end
                end
            end
    end
    
    
        [t1 timepoints nr_epochs]=size(stop_easy_r.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(stop_easy_r.event) 
                if stop_easy_r.event(event_i).epoch==epoch_i & stop_easy_r.event(event_i).type(1)=='R' 
                    if stop_easy_r.event(event_i).type=='R  1'
                        corr_stop_e_r_i=[corr_stop_e_r_i, epoch_i];
                    else
                        err_stop_e_r_i=[err_stop_e_r_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(stop_easy_l.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(stop_easy_l.event) 
                if stop_easy_l.event(event_i).epoch==epoch_i & stop_easy_l.event(event_i).type(1)=='R' 
                    if stop_easy_l.event(event_i).type=='R  2'
                        corr_stop_e_l_i=[corr_stop_e_l_i, epoch_i];
                    else
                        err_stop_e_l_i=[err_stop_e_l_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(stop_hard_r.data);
    for epoch_i=1:nr_epochs   
        for event_i=1:length(stop_hard_r.event) 
            if stop_hard_r.event(event_i).epoch==epoch_i & stop_hard_r.event(event_i).type(1)=='R' 
                if stop_hard_r.event(event_i).type=='R  1'
                    corr_stop_h_r_i=[corr_stop_h_r_i, epoch_i];
                else
                    err_stop_h_r_i=[err_stop_h_r_i, epoch_i];
                end
            end
        end
    end
        
    [t1 timepoints nr_epochs]=size(stop_hard_l.data);
    for epoch_i=1:nr_epochs   
        for event_i=1:length(stop_hard_l.event) 
            if stop_hard_l.event(event_i).epoch==epoch_i & stop_hard_l.event(event_i).type(1)=='R' 
                if stop_hard_l.event(event_i).type=='R  2'
                    corr_stop_h_l_i=[corr_stop_h_l_i, epoch_i];
                else
                    err_stop_h_l_i=[err_stop_h_l_i, epoch_i];
                end
            end
        end
    end
    
     [t1 timepoints nr_epochs]=size(revs_easy_r.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(revs_easy_r.event) 
                if revs_easy_r.event(event_i).epoch==epoch_i & revs_easy_r.event(event_i).type(1)=='R' 
                    if revs_easy_r.event(event_i).type=='R  1'
                        corr_revs_e_r_i=[corr_revs_e_r_i, epoch_i];
                    else
                        err_revs_e_r_i=[err_revs_e_r_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(revs_easy_l.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(revs_easy_l.event) 
                if revs_easy_l.event(event_i).epoch==epoch_i & revs_easy_l.event(event_i).type(1)=='R' 
                    if revs_easy_l.event(event_i).type=='R  2'
                        corr_revs_e_l_i=[corr_revs_e_l_i, epoch_i];
                    else
                        err_revs_e_l_i=[err_revs_e_l_i, epoch_i];
                    end
                end
            end
    end
    
    [t1 timepoints nr_epochs]=size(revs_hard_r.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(revs_hard_r.event) 
                if revs_hard_r.event(event_i).epoch==epoch_i & revs_hard_r.event(event_i).type(1)=='R' 
                    if revs_hard_r.event(event_i).type=='R  1'
                        corr_revs_h_r_i=[corr_revs_h_r_i, epoch_i];
                    else
                        err_revs_h_r_i=[err_revs_h_r_i, epoch_i];
                    end
                end
            end
    end
        
    [t1 timepoints nr_epochs]=size(revs_hard_l.data);
    for epoch_i=1:nr_epochs   
            for event_i=1:length(revs_hard_l.event) 
                if revs_hard_l.event(event_i).epoch==epoch_i & revs_hard_l.event(event_i).type(1)=='R' 
                    if revs_hard_l.event(event_i).type=='R  2'
                        corr_revs_h_l_i=[corr_revs_h_l_i, epoch_i];
                    else
                        err_revs_h_l_i=[err_revs_h_l_i, epoch_i];
                    end
                end
            end
    end
    
    
    err_cont_easy_r=pop_selectevent(cont_easy_r,'epoch',err_cont_e_r_i);
    err_cont_easy_l=pop_selectevent(cont_easy_l,'epoch',err_cont_e_l_i);
    err_cont_hard_r=pop_selectevent(cont_hard_r,'epoch',err_cont_h_r_i);
    err_cont_hard_l=pop_selectevent(cont_hard_l,'epoch',err_cont_h_l_i);
    if ~isempty(err_stop_e_r_i)
        err_stop_easy_r=pop_selectevent(stop_easy_r,'epoch',err_stop_e_r_i);
    else
        err_stop_easy_r=[];
        Partic(partic)
    end
    if ~isempty(err_stop_e_l_i)
        err_stop_easy_l=pop_selectevent(stop_easy_l,'epoch',err_stop_e_l_i);
    else
        Partic(partic)
        err_stop_easy_l=[];
    end
    
    err_stop_hard_r=pop_selectevent(stop_hard_r,'epoch',err_stop_h_r_i);
    err_stop_hard_l=pop_selectevent(stop_hard_l,'epoch',err_stop_h_l_i);  
    err_revs_easy_r=pop_selectevent(revs_easy_r,'epoch',err_revs_e_r_i);
    err_revs_easy_l=pop_selectevent(revs_easy_l,'epoch',err_revs_e_l_i);
    err_revs_hard_r=pop_selectevent(revs_hard_r,'epoch',err_revs_h_r_i);
    err_revs_hard_l=pop_selectevent(revs_hard_l,'epoch',err_revs_h_l_i);
    
    cont_easy_r=pop_selectevent(cont_easy_r,'epoch',corr_cont_e_r_i);
    cont_easy_l=pop_selectevent(cont_easy_l,'epoch',corr_cont_e_l_i);
    cont_hard_r=pop_selectevent(cont_hard_r,'epoch',corr_cont_h_r_i);
    cont_hard_l=pop_selectevent(cont_hard_l,'epoch',corr_cont_h_l_i);
    stop_easy_r=pop_selectevent(stop_easy_r,'epoch',corr_stop_e_r_i);
    stop_easy_l=pop_selectevent(stop_easy_l,'epoch',corr_stop_e_l_i);
    stop_hard_r=pop_selectevent( stop_hard_r,'epoch',corr_stop_h_r_i);
    stop_hard_l=pop_selectevent(stop_hard_l,'epoch',corr_stop_h_l_i);  
    revs_easy_r=pop_selectevent(revs_easy_r,'epoch',corr_revs_e_r_i);
    revs_easy_l=pop_selectevent(revs_easy_l,'epoch',corr_revs_e_l_i);
    revs_hard_r=pop_selectevent(revs_hard_r,'epoch',corr_revs_h_r_i);
    revs_hard_l=pop_selectevent(revs_hard_l,'epoch',corr_revs_h_l_i);
    
    
    filename=strcat(num2str(Partic(partic)),'_cont_easy_r');
    save(filename, 'cont_easy_r')
    filename=strcat(num2str(Partic(partic)),'_cont_easy_l');
    save(filename, 'cont_easy_l')
    filename=strcat(num2str(Partic(partic)),'_cont_hard_r');
    save(filename, 'cont_hard_r')
    filename=strcat(num2str(Partic(partic)),'_cont_hard_l');
    save(filename, 'cont_hard_l')
    filename=strcat(num2str(Partic(partic)),'_stop_easy_r');
    save(filename, 'stop_easy_r')
    filename=strcat(num2str(Partic(partic)),'_stop_easy_l');
    save(filename, 'stop_easy_l')
    filename=strcat(num2str(Partic(partic)),'_stop_hard_r');
    save(filename, 'stop_hard_r')
    filename=strcat(num2str(Partic(partic)),'_stop_hard_l');
    save(filename, 'stop_hard_l')
    filename=strcat(num2str(Partic(partic)),'_revs_easy_r');
    save(filename, 'revs_easy_r')
    filename=strcat(num2str(Partic(partic)),'_revs_easy_l');
    save(filename, 'revs_easy_l')
    filename=strcat(num2str(Partic(partic)),'_revs_hard_r');
    save(filename, 'revs_hard_r')
    filename=strcat(num2str(Partic(partic)),'_revs_hard_l');
    save(filename, 'revs_hard_l')
    
    filename=strcat(num2str(Partic(partic)),'_err_cont_easy_r');
    save(filename, 'err_cont_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_cont_easy_l');
    save(filename, 'err_cont_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_cont_hard_r');
    save(filename, 'err_cont_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_cont_hard_l');
    save(filename, 'err_cont_hard_l')
    filename=strcat(num2str(Partic(partic)),'_err_stop_easy_r');
    save(filename, 'err_stop_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_stop_easy_l');
    save(filename, 'err_stop_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_stop_hard_r');
    save(filename, 'err_stop_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_stop_hard_l');
    save(filename, 'err_stop_hard_l')   
    filename=strcat(num2str(Partic(partic)),'_err_revs_easy_r');
    save(filename, 'err_revs_easy_r')
    filename=strcat(num2str(Partic(partic)),'_err_revs_easy_l');
    save(filename, 'err_revs_easy_l')
    filename=strcat(num2str(Partic(partic)),'_err_revs_hard_r');
    save(filename, 'err_revs_hard_r')
    filename=strcat(num2str(Partic(partic)),'_err_revs_hard_l');
    save(filename, 'err_revs_hard_l')


 
 %% Mirror Left/Right
 % right direction required right response (left dir=left resp). we'll
 % collapse over left and right trials so we'll mirror eeg activity
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 for lock=1:length(Lock)
     for accuracy=21:length(Accuracy)
         for cond=1:length(Conds)
             for diff=1:length(Diff)
                clear EEG
                load(char(strcat(cd,Lock{lock},'\',num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff),'_r')))
                right_data=eval(char(strcat(Accuracy(accuracy),Conds(cond),'_',Diff(diff),'_r')));
                load(char(strcat(cd,Lock{lock},'\',num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff),'_l')))
                left_data=eval(char(strcat(Accuracy(accuracy),Conds(cond),'_',Diff(diff),'_l')));
                if ~isempty(right_data) & ~isempty(left_data)
                    if accuracy==1
                        right_data.data=Mirror(right_data);
                    else
                        left_data.data=Mirror(left_data);
                    end

                    [t1 t2 nr_rights]=size(right_data.data);
                    [t1 t2 nr_lefts]=size(left_data.data);
                    Partic(partic);
                    if nr_rights > 1 & nr_lefts > 1                  
                        EEG=pop_mergeset(right_data, left_data);
                        EEG=eeg_checkset(EEG);
                    elseif nr_rights>1
                        EEG=right_data;
                        WaitSecs(10)
                    elseif nr_lefts>1
                        EEG=left_data;
                    elseif nr_lefts==1 && nr_rights==1
                        EEG=left_data;                       
                    end
                    cd(strcat(cd',Lock{lock},'\')) 
                    filename=char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff)));
                    save(filename, 'EEG')
                else
                   disp(char(strcat(cd,num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff),'_up'))) 
                   WaitSecs(10)
                end
             end
         end
     end
 end
 
 
 