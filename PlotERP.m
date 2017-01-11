
%% PLOT: ERPs and LRPs (individuals and grand averages)
% needs eeglab (csd toolbox optional)
% add own paths


 
%% Individual Averages Plot

ppt = PPT2007; %plot in ppt

%define electrode of interest and conditions to be plotted separately (each
%one needs to be already saved on its own (see Epoch.m)
Participants=[1:23]
 y1=[-2 7]; 
 Electr_oi=5;
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
for partic=1:length(Partic)
 for lock=1:length(Lock)
      figure
       hold on
     if lock==1
        x1=[-100 1000];
     else
        x1=[-1000 100];
     end
     for accuracy=2:length(Accuracy)
         for cond=1:length(Conds)
             for diff=1:length(Diff)
                    cd(strcat(cd,Lock{lock},'\')) 
                    load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                    if diff==1
                        linestyle='-';
                    else
                        linestyle='--';
                    end
                    if cond==1
                        colour='k';
                    elseif cond==2
                        colour='b';   
                    elseif cond==3
                        colour=[0.2 0.8 1 ];   
                    end
                    
                    Line(cond)=plot(EEG.times, mean(EEG.data(Electr_oi,:,:),3),'Linestyle',linestyle,'Color',colour);

             end
         end
                    axis([x1 y1])
                    plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                    y2=zeros(size(x1));
                    plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                    %legend(Line(1:3),'cont','stop','revs','Location','northwest')
     end
     print('-dpng','-r150',strcat(cd,(Lock{lock})))

 end

ppt = ppt.addTwoImageSlide(strcat('Average Participant ',num2str(Partic(partic)),': ') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\',(Lock{2}),'.png'));
         
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% Grand Averages Plot

 Electr_oi=5;
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 figure
 hold on
  y1=[-2 5]; 

 for lock=1:length(Lock)
      figure
       hold on
     if lock==1
        x1=[-100 1000];
     else
        x1=[-1000 100]
     end
     for accuracy=2:length(Accuracy)
         for cond=1:length(Conds)
             for diff=1:length(Diff)
                  EEG_conc=[];
                 for partic=1:length(Partic)
                    cd(strcat(cd,Lock{lock},'\')) 
                    load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                    EEG_conc=cat(1,EEG_conc, mean(EEG.data(Electr_oi,:,:),3));
                 end
                 data=mean(EEG_conc);
                    if diff==1
                        linestyle='-';
                    else
                        linestyle='--';
                    end
                    if cond==1
                        colour='k';
                    elseif cond==2
                        colour='b';   
                    elseif cond==3
                        colour=[0.2 0.8 1 ];   
                    end
                    
                    Line(cond)=plot(EEG.times,data,'Linestyle',linestyle,'Color',colour)
                    
                    axis([x1 y1])
                    
             end
         end
         axis([x1 y1])
        plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
        y2=zeros(size(x1));
        plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
        legend(Line(1:3),'cont','stop','revs','Location','northwest')
    
     end
     print('-dpng','-r150',strcat(cd,(Lock{lock})))
 end
 
ppt = ppt.addTwoImageSlide(strcat('Grand Average: ') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\',(Lock{2}),'.png'));
                        
 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% Individual Averages with Topo
 
% CURRENT SOURCE DENSITY: if laplacian==1, CSD on
laplacian=1
if laplacian==1
    cd('C:\Users\ackg426\Desktop\channel_stuff');
    load Montage
    [G,H]=GetGH(Montage);
end


%load behavioural to get rt
for partic=15:length(Partic)
cd(strcat(cd,'\Beh\')) 
data=readtable(strcat(num2str(Partic(partic)),'.txt'));
data=table2array(data(2:end,:));
data_mat=[];
for i=1:960
    data_mat(i,:)=str2num(data{i});
end
data=data_mat;
%delete errors
data(data(:,3)==0,:)=[];
%conds
rt.cont.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==1 & data(:,6)==max(data(:,6)),8));
rt.cont.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==1 & data(:,6)==min(data(:,6)),8));
rt.stop.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==2 & data(:,6)==max(data(:,6)),8));
rt.stop.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==2 & data(:,6)==min(data(:,6)),8));
rt.revs.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==3 & data(:,6)==max(data(:,6)),8));
rt.revs.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==3 & data(:,6)==min(data(:,6)),8));
end




ppt = PPT2007;
if laplacian==0
    y1=[-2 7]; 
else
    y1=[-10 50]; 
end
 Electr_oi=[1 5 14];%[1,4,5,6,13,15,14];
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
for partic=1:length(Partic)
     for lock=1:length(Lock)
         topo_conc=[];
          figure
           hold on
         if lock==1
            x1=[-100 1500];
         else
            x1=[-1000 100];
         end
         for accuracy=2:length(Accuracy)
             for cond=1:length(Conds)
                 for diff=1:length(Diff)
                     for electr=1:length(Electr_oi)
                        hold on
                        subplot(3,1,electr)
                        cd(strcat(cd,Lock{lock},'\')) 
                        load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                        if laplacian>0
                            EEG.data=CSD(EEG.data,G,H);
                        end
                        if diff==1
                            linestyle='-';
                        else
                            linestyle='--';
                        end
                        if cond==1
                            colour='k';
                        elseif cond==2
                            colour='b';   
                        elseif cond==3
                            colour=[0.2 0.8 1 ];   
                        end
                        hold on
                        Line(cond)=plot(EEG.times, mean(EEG.data(Electr_oi(electr),:,:),3),'Linestyle',linestyle,'Color',colour);
                        title(strcat('Electrode ',num2str(Electr_oi(electr))))
                        axis([x1 y1])
                        plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                        y2=zeros(size(x1));
                        plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                        topo_conc=cat(3,topo_conc,EEG.data);
                        %put in rt
                        if lock==1
                            plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff}).(strcat('partic',num2str(Partic(partic))))*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                        end
                     end

                 end
             end

                       % legend(Line(1:3),'cont','stop','revs','Location','northwest')
         end
         print('-dpng','-r150',strcat(cd,(Lock{lock})))
        
         %topo
         
         if lock==1
             time_interval=[100:100:1000];
         else
             time_interval=[-800:100:100];
         end
         figure
         for t=1:length(time_interval)-1
             subplot(3,3,t)
             t1=find(EEG.times==time_interval(t));
             if lock==2 & time_interval(t+1)==100
                 t2=find(EEG.times==99);
             else
                t2=find(EEG.times==time_interval(t+1));
             end
             %avg over time and epochs
             data=mean(topo_conc(:,t1:t2,:),2);
             data=mean(data,3);
             if laplacian==0
                 maplimits=[-3 3];
             else
                 maplimits=[-10 10];
             end
             topoplot(data,EEG.chanlocs,'maplimits',maplimits);
             title(strcat(num2str(time_interval(t)),' - ',num2str(time_interval(t+1))))
             if t==length(time_interval)-1
                cbar
            end
         end
        print('-dpng','-r150',strcat(cd,(Lock{lock})))
        
        if laplacian==0
            ppt = ppt.addTwoImageSlide(strcat('P ',num2str(Partic(partic)),' - ', (Lock{lock})) , strcat(cd,(Lock{lock}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\Topo',(Lock{lock}),'.png'));
        else
            ppt = ppt.addTwoImageSlide(strcat('CSD - P ',num2str(Partic(partic)),' - ', (Lock{lock})) , strcat(cd,(Lock{lock}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\Topo',(Lock{lock}),'.png'));
        end
         
     end
       
end        
close all
       


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% Grand Averages with Topo
 
laplacian=0;
electr_per_partic=1;

if laplacian==1
    cd('C:\Users\ackg426\Desktop\channel_stuff');
    load Montage
    [G,H]=GetGH(Montage);
end

%load behavioural to get rt
rt.cont.easy=[];
rt.cont.hard=[];
rt.stop.easy=[];
rt.stop.hard=[];
rt.revs.easy=[];
rt.revs.hard=[];
for partic=1:length(Partic)
    cd(strcat(cd,'\Beh\')) 
    data=readtable(strcat(num2str(Partic(partic)),'.txt'));
    data=table2array(data(2:end,:));
    data_mat=[];
    for i=1:960
        data_mat(i,:)=str2num(data{i});
    end
    data=data_mat;
    %delete errors
    data(data(:,3)==0,:)=[];
    %conds
    rt.cont.easy=[rt.cont.easy, mean(data(data(:,2)==1 & data(:,6)==max(data(:,6)),8))];
    rt.cont.hard=[rt.cont.hard, mean(data(data(:,2)==1 & data(:,6)==min(data(:,6)),8))];
    rt.stop.easy=[rt.stop.easy, mean(data(data(:,2)==2 & data(:,6)==max(data(:,6)),8))];
    rt.stop.hard=[rt.stop.hard, mean(data(data(:,2)==2 & data(:,6)==min(data(:,6)),8))];
    rt.revs.easy=[rt.revs.easy, mean(data(data(:,2)==3 & data(:,6)==max(data(:,6)),8))];
    rt.revs.hard=[rt.revs.hard, mean(data(data(:,2)==3 & data(:,6)==min(data(:,6)),8))];
end
rt.cont.easy=mean(rt.cont.easy);
rt.cont.hard=mean(rt.cont.hard);
rt.stop.easy=mean(rt.stop.easy);
rt.stop.hard=mean(rt.stop.hard);
rt.revs.easy=mean(rt.revs.easy);
rt.revs.hard=mean(rt.revs.hard);



ppt = PPT2007;
if laplacian==0
    y1=[-2 6]; 
else
    y1=[-5 20];
end
 Electr_oi=[1 5 14];%[1,4,5,6,13,15,14];
if electr_per_partic==1;
    Partic=[1:7,10:14,16:20];
    if laplacian==0;
        Electr_per_partic=[5 14 14 5 1 5 5 5 5 14 5 5 5 14 5 5 5];
    else
        Electr_per_partic=[5 5 14 5 5 5 5 5 5 14 14 5 1 14 5 5 14];
    end
end
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 for lock=1:length(Lock)
     topo_conc=[];
      figure
       hold on
     if lock==1
        x1=[-100 1500];
     else
        x1=[-1000 100];
     end
     for accuracy=2%:length(Accuracy)
         for cond=1:length(Conds)
             for diff=1:length(Diff)
                 EEG_conc=[];
                     for partic=1:length(Partic)
                        cd(strcat(cd,Lock{lock},'\')) 
                        load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                        EEG_conc=cat(3,EEG_conc, mean(EEG.data(:,:,:),3));
                     end
                      if laplacian>0
                            EEG_conc=CSD(EEG_conc,G,H);
                      end
                      if electr_per_partic==0
                         for electr=1:length(Electr_oi)

                            hold on
                            subplot(3,1,electr)
                            if diff==1
                                linestyle='-';
                            else
                                linestyle='--';
                            end
                            if cond==1
                                colour='k';
                            elseif cond==2
                                colour='b';   
                            elseif cond==3
                                colour=[0.2 0.8 1 ];   
                            end
                            hold on
                            Line(cond)=plot(EEG.times, mean(EEG_conc(Electr_oi(electr),:,:),3),'Linestyle',linestyle,'Color',colour);
                            title(strcat('Electrode ',num2str(Electr_oi(electr))))
                            axis([x1 y1])
                            plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                            y2=zeros(size(x1));
                            plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                            topo_conc=cat(3,topo_conc,EEG_conc);
                            %put in rt
                            if lock==1
                                plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff})*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                            end
                         end
                      else
                        hold on                       
                        cd(strcat(cd,Lock{lock},'\')) 
                        load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                        if diff==1
                            linestyle='-';
                        else
                            linestyle='--';
                        end
                        if cond==1
                            colour='k';
                        elseif cond==2
                            colour='b';   
                        elseif cond==3
                            colour=[0.2 0.8 1 ];   
                        end
                        hold on
                        Line(cond)=plot(EEG.times, mean(EEG_conc(Electr_per_partic(partic),:,:),3),'Linestyle',linestyle,'Color',colour);
                        %title(strcat('Electrode ',num2str(Electr_oi(electr))))
                        axis([x1 y1])
                        plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                        y2=zeros(size(x1));
                        plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                        topo_conc=cat(3,topo_conc,EEG_conc);
                        %put in rt
                        if lock==1
                            plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff})*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                        end
            
                          
                      end
                          

             end
         end

                   % legend(Line(1:3),'cont','stop','revs','Location','northwest')
     end
     print('-dpng','-r150',strcat(cd,(Lock{lock})))

     %topo

     if lock==1
         time_interval=[100:100:1000];
     else
         time_interval=[-800:100:100];
     end
     figure
     for t=1:length(time_interval)-1
         subplot(3,3,t)
         t1=find(EEG.times==time_interval(t));
         if lock==2 & time_interval(t+1)==100
             t2=find(EEG.times==99);
         else
            t2=find(EEG.times==time_interval(t+1));
         end
         %avg over time and epochs
         data=mean(topo_conc(:,t1:t2,:),2);
         data=mean(data,3);
         if laplacian==0
             maplimits=[-2 2];
         else
             maplimits=[-10 10];
         end
         topoplot(data,EEG.chanlocs,'maplimits',maplimits);
         title(strcat(num2str(time_interval(t)),' - ',num2str(time_interval(t+1))))
         if t==length(time_interval)-1
            cbar
        end
     end
    print('-dpng','-r150',strcat(cd,(Lock{lock})))
    if laplacian==0
        ppt = ppt.addTwoImageSlide(strcat('Grand - ', (Lock{lock})) , strcat(cd,(Lock{lock}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\Topo',(Lock{lock}),'.png'));
    else
        ppt = ppt.addTwoImageSlide(strcat('CSD-Grand - ', (Lock{lock})) , strcat(cd,(Lock{lock}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\Topo',(Lock{lock}),'.png'));
    end

 end
 close all      

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% M1 Grand Averages 


laplacian=1;
if laplacian>0
    cd('C:\Users\ackg426\Desktop\channel_stuff');
    load Montage
    if laplacian==1
        [G,H]=GetGH(Montage);
    else
        [G,H]=GetGH(Montage,3);
    end
end

%load behavioural to get rt
rt.cont.easy=[];
rt.cont.hard=[];
rt.stop.easy=[];
rt.stop.hard=[];
rt.revs.easy=[];
rt.revs.hard=[];
for partic=1:length(Partic)
cd(strcat('C:\Users\ackg426\Desktop\Data\EEG2\Beh\')) 
data=readtable(strcat(num2str(Partic(partic)),'.txt'));
data=table2array(data(2:end,:));
data_mat=[];
for i=1:960
    data_mat(i,:)=str2num(data{i});
end
data=data_mat;
%delete errors
data(data(:,3)==0,:)=[];
%conds
rt.cont.easy=[rt.cont.easy, mean(data(data(:,2)==1 & data(:,6)==max(data(:,6)),8))];
rt.cont.hard=[rt.cont.hard, mean(data(data(:,2)==1 & data(:,6)==min(data(:,6)),8))];
rt.stop.easy=[rt.stop.easy, mean(data(data(:,2)==2 & data(:,6)==max(data(:,6)),8))];
rt.stop.hard=[rt.stop.hard, mean(data(data(:,2)==2 & data(:,6)==min(data(:,6)),8))];
rt.revs.easy=[rt.revs.easy, mean(data(data(:,2)==3 & data(:,6)==max(data(:,6)),8))];
rt.revs.hard=[rt.revs.hard, mean(data(data(:,2)==3 & data(:,6)==min(data(:,6)),8))];
end
rt.cont.easy=mean(rt.cont.easy);
rt.cont.hard=mean(rt.cont.hard);
rt.stop.easy=mean(rt.stop.easy);
rt.stop.hard=mean(rt.stop.hard);
rt.revs.easy=mean(rt.revs.easy);
rt.revs.hard=mean(rt.revs.hard);



ppt = PPT2007;
Electr_contra=[17,18,30,16,7,31,29];
Electr_ipsi=[11,10,23,12,3,22,24];
if laplacian==0
    y1=[-2 4]; 
elseif laplacian==1
    y1=[-15 20];
else
    y1=[-30 60]
end
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 Hem={'Contra' 'Ipsi'};
 for lock=1:length(Lock)
       hold on
     if lock==1
        x1=[-100 1500];
     else
        x1=[-1000 100];
     end
     for accuracy=2%:length(Accuracy)
         for hem=1:length(Hem)
             if hem==1
                 Electr_oi=Electr_contra;
             else
                 Electr_oi=Electr_ipsi;
             end
             figure
             for cond=1:length(Conds)
                 for diff=1:length(Diff)
                         EEG_conc=[];
                         for partic=1:length(Partic)
                            cd(strcat('Z:\Stop-RDM-EEG\eeg-data\',Lock{lock},'\')) 
                            load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                            EEG_conc=cat(3,EEG_conc, mean(EEG.data(:,:,:),3));
                         end
                          if laplacian>0
                                EEG_conc=CSD(EEG_conc,G,H);
                          end
                     for electr=1:length(Electr_oi)
                        hold on
                        subplot(4,2,electr)
                        if diff==1
                            linestyle='-';
                        else
                            linestyle='--';
                        end
                        if cond==1
                            colour='k';
                        elseif cond==2
                            colour='b';   
                        elseif cond==3
                            colour=[0.2 0.8 1 ];   
                        end
                        hold on
                        Line(cond)=plot(EEG.times, mean(EEG_conc(Electr_oi(electr),:,:),3),'Linestyle',linestyle,'Color',colour);
                        title(strcat('Electrode ',num2str(EEG.chanlocs(Electr_oi(electr)).labels(2:end))))
                        axis([x1 y1])
                        plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                        y2=zeros(size(x1));
                        plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                        %put in rt
                        if lock==1
                            plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff})*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                        end
                     end
                     
                 end

             end
             print('-dpng','-r150',strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Hem{hem})))
         end

                   % legend(Line(1:3),'cont','stop','revs','Location','northwest')
     end

   
    if laplacian==0
        ppt = ppt.addTwoImageSlide(strcat('Grand Contra - Ipsi - ', (Lock{lock})) , strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Hem{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Hem{2}),'.png'));
    else
        ppt = ppt.addTwoImageSlide(strcat('CSD-Grand Contra - Ipsi - ', (Lock{lock})) , strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Hem{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Hem{2}),'.png'));
    end

 end
 close all      
 
 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% LRP Grand Averages 


laplacian=1;%if laplacian==2, CSD with spline 3
if laplacian>0
    cd(strcat(cd,'channel_stuff'));
    load Montage
    if laplacian==1
        [G,H]=GetGH(Montage);
    else
        [G,H]=GetGH(Montage,3);
    end
end

%load behavioural to get rt
rt.cont.easy=[];
rt.cont.hard=[];
rt.stop.easy=[];
rt.stop.hard=[];
rt.revs.easy=[];
rt.revs.hard=[];
for partic=1:length(Partic)
cd(strcat(cd,'\Beh\')) 
data=readtable(strcat(num2str(Partic(partic)),'.txt'));
data=table2array(data(2:end,:));
data_mat=[];
for i=1:960
    data_mat(i,:)=str2num(data{i});
end
data=data_mat;
%delete errors
data(data(:,3)==0,:)=[];
%conds
rt.cont.easy=[rt.cont.easy, mean(data(data(:,2)==1 & data(:,6)==max(data(:,6)),8))];
rt.cont.hard=[rt.cont.hard, mean(data(data(:,2)==1 & data(:,6)==min(data(:,6)),8))];
rt.stop.easy=[rt.stop.easy, mean(data(data(:,2)==2 & data(:,6)==max(data(:,6)),8))];
rt.stop.hard=[rt.stop.hard, mean(data(data(:,2)==2 & data(:,6)==min(data(:,6)),8))];
rt.revs.easy=[rt.revs.easy, mean(data(data(:,2)==3 & data(:,6)==max(data(:,6)),8))];
rt.revs.hard=[rt.revs.hard, mean(data(data(:,2)==3 & data(:,6)==min(data(:,6)),8))];
end
rt.cont.easy=mean(rt.cont.easy);
rt.cont.hard=mean(rt.cont.hard);
rt.stop.easy=mean(rt.stop.easy);
rt.stop.hard=mean(rt.stop.hard);
rt.revs.easy=mean(rt.revs.easy);
rt.revs.hard=mean(rt.revs.hard);



ppt = PPT2007;
Electr_contra=[17,18,30,16,7,31,29];
Electr_ipsi=[11,10,23,12,3,22,24];
if laplacian==0
    y1=[-4 2]; 
elseif laplacian==1
    y1=[-20 15];
else
    y1=[-60 30]
end
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 for lock=1:length(Lock)
       hold on
     if lock==1
        x1=[-100 1500];
     else
        x1=[-1000 100];
     end
     for accuracy=2:length(Accuracy)
             figure
             for cond=1:length(Conds)
                 for diff=1:length(Diff)
                         EEG_conc=[];
                         for partic=1:length(Partic)
                            cd(strcat(cd,Lock{lock},'\')) 
                            load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                            EEG_conc=cat(3,EEG_conc, mean(EEG.data(:,:,:),3));
                         end
                          if laplacian>0
                                EEG_conc=CSD(EEG_conc,G,H);
                          end
                     for electr=1:length(Electr_contra)
                        hold on
                        subplot(4,2,electr)
                                  
                        if diff==1
                            linestyle='-';
                        else
                            linestyle='--';
                        end
                        if cond==1
                            colour='k';
                        elseif cond==2
                            colour='b';   
                        elseif cond==3
                            colour=[0.2 0.8 1 ];   
                        end
                        hold on
                        Line(cond)=plot(EEG.times, (mean(EEG_conc(Electr_contra(electr),:,:),3)-mean(EEG_conc(Electr_ipsi(electr),:,:),3)),'Linestyle',linestyle,'Color',colour);
                        title(strcat('Electrodes ',num2str(EEG.chanlocs(Electr_contra(electr)).labels(2:end)),'-',num2str(EEG.chanlocs(Electr_ipsi(electr)).labels(2:end))))
                        axis([x1 y1])
                        plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                        y2=zeros(size(x1));
                        plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                        %put in rt
                        if lock==1
                            plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff})*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                        end
                     end
                     
                 end

             end
            
         end

                   % legend(Line(1:3),'cont','stop','revs','Location','northwest')
  print('-dpng','-r150',strcat(cd,(Lock{lock})))

 end
     if laplacian==0
        ppt = ppt.addTwoImageSlide(strcat('Grand LRP  ') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Lock{2}),'.png'));
    else
        ppt = ppt.addTwoImageSlide(strcat('CSD-Grand LRP  ') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Lock{2}),'.png'));
    end
 close all      
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% LRP Individuals


laplacian=1;
if laplacian>0
    load Montage
    if laplacian==1
        [G,H]=GetGH(Montage);
    else
        [G,H]=GetGH(Montage,3);
    end
end

%load behavioural to get rt
for partic=19:length(Partic)
cd(strcat(cd,'\Beh\')) 
data=readtable(strcat(num2str(Partic(partic)),'.txt'));
data=table2array(data(2:end,:));
data_mat=[];
for i=1:960
    data_mat(i,:)=str2num(data{i});
end
data=data_mat;
%delete errors
data(data(:,3)==0,:)=[];
%conds
rt.cont.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==1 & data(:,6)==max(data(:,6)),8));
rt.cont.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==1 & data(:,6)==min(data(:,6)),8));
rt.stop.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==2 & data(:,6)==max(data(:,6)),8));
rt.stop.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==2 & data(:,6)==min(data(:,6)),8));
rt.revs.easy.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==3 & data(:,6)==max(data(:,6)),8));
rt.revs.hard.(strcat('partic',num2str(Partic(partic))))= mean(data(data(:,2)==3 & data(:,6)==min(data(:,6)),8));
end

ppt = PPT2007;
Electr_contra=[17,18,30,16,7,31,29];
Electr_ipsi=[11,10,23,12,3,22,24];
if laplacian==0
    y1=[-5 3]; 
elseif laplacian==1
    y1=[-40 30];
else
    y1=[-60 30]
end
 Accuracy={'err_' ''};
 Conds={'cont' 'stop' 'revs'};
 Diff={'easy' 'hard'};
 Lock={'S' 'R'};
 Hem={'Contra' 'Ipsi'};
 
 for partic=19:length(Partic)
     for lock=1:length(Lock)
         figure
         hold on
         if lock==1
            x1=[-100 1500];
         else
            x1=[-1000 100];
         end
         for accuracy=2:length(Accuracy)
                 for cond=1:length(Conds)
                     for diff=1:length(Diff)
                         cd(strcat(cd,Lock{lock},'\')) 
                         load(char(strcat(num2str(Partic(partic)),'_',Accuracy(accuracy),Conds(cond),'_',Diff(diff))))
                          if laplacian>0
                                EEG.data=CSD(EEG.data,G,H);
                          end
                         for electr=1:length(Electr_contra)
                            hold on
                            subplot(4,2,electr)
                            if diff==1
                                linestyle='-';
                            else
                                linestyle='--';
                            end
                            if cond==1
                                colour='k';
                            elseif cond==2
                                colour='b';   
                            elseif cond==3
                                colour=[0.2 0.8 1 ];   
                            end
                            hold on
                            Line(cond)=plot(EEG.times, (mean(EEG.data(Electr_contra(electr),:,:),3)-mean(EEG.data(Electr_ipsi(electr),:,:),3)),'Linestyle',linestyle,'Color',colour);
                            title(strcat('Electrodes ',num2str(EEG.chanlocs(Electr_contra(electr)).labels(2:end)),'-',num2str(EEG.chanlocs(Electr_ipsi(electr)).labels(2:end))))
                            axis([x1 y1])
                            plot(zeros(size(y1)) ,y1,'Color',[0.6 0.6 0.6], 'Linestyle',':')                        
                            y2=zeros(size(x1));
                            plot(x1,y2, 'Color',[0.6 0.6 0.6], 'Linestyle',':')
                            %put in rt
                            if lock==1
                                plot(zeros(size(y1))+rt.(Conds{cond}).(Diff{diff}).(strcat('partic',num2str(Partic(partic))))*1000 ,y1,'Color',colour, 'Linestyle',linestyle)        
                            end
                         end
                     end
                 end          
             end
             % legend(Line(1:3),'cont','stop','revs','Location','northwest')
        
     print('-dpng','-r150',strcat(cd,(Lock{lock})))
    end
     if laplacian==0
        ppt = ppt.addTwoImageSlide(strcat('Partic',num2str(Partic(partic)), ' - LRP ') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Lock{2}),'.png'));
    else
        ppt = ppt.addTwoImageSlide(strcat('Partic',num2str(Partic(partic)), ' - CSD - LRP') , strcat(cd,(Lock{1}),'.png'), strcat('Z:\Stop-RDM-EEG\eeg-data\ERP',(Lock{2}),'.png'));
    end
 end
 close all      
 
 
