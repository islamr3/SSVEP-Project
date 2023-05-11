clc;
clear all;
close all;

load s2

EEG=data(24:31,1201:6000,:,:);
%% Initialize parameters
Fs=1200;                                  % sampling rate
t_length=4;                              % data length (4 s)
%TW=.25:.25:1;
%TW=  0.1:  0.1:1;
%TW= 0.16:0.16:1;
%TW=.5:.5:2;
%TW=.125:.125:1;
TW=.25:.25:2;
TW_p=round(TW*Fs);
n_run=20;                                % number of used runs
% sti_f=[9.75 8.75 7.75 5.75];   
%sti_f=[8,9,11,12,13,15,17,20]
% stimulus frequencies 10, 9, 8, 6 Hz
sti_f=frequency;
 %sti_f=[8 9 11 12 13 15 17 20];
%8, 9.2, 10.9, 12,13.3, 15, 17.1, 20
%sti_f=[8 9.2 10.9 12 13.3 15 17.1 20];
n_sti=length(sti_f);                     % number of stimulus frequencies
n_correct=zeros(2,length(TW));
N=3;    % number of harmonics
ref1=refsig(sti_f(1),Fs,t_length*Fs,N);
ref2=refsig(sti_f(2),Fs,t_length*Fs,N);
ref3=refsig(sti_f(3),Fs,t_length*Fs,N);
ref4=refsig(sti_f(4),Fs,t_length*Fs,N);


ref5=refsig(sti_f(5),Fs,t_length*Fs,N);
ref6=refsig(sti_f(6),Fs,t_length*Fs,N);
ref7=refsig(sti_f(7),Fs,t_length*Fs,N);
ref8=refsig(sti_f(8),Fs,t_length*Fs,N);
%% Load SSVEP data
%load s4
%EEG=data(24:31,1201:6000,:,:);
Tv=[];
for i=1:8
    rabi=EEG(:,:,:,i);
    Tv=eeg_filt(rabi,Fs,[6 100]);
    SSVEPdata(:,:,:,i)=Tv;
%     [fre1,vX]=calFreT(SSVEPdata(7,1:4800,i,1),Fs); 
%      plot(vX,fre1,'r');xlim([-5 40]);
end
% Recognition
for run=1:20
    for tw_length=1:8     % time window length:  1s:1s:4s
        fprintf('CCA Processing... TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
        for j=1:8
            [wx1,wy1,r1]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SSVEPdata(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));            
            [v,idx]=max([r1,r2,r3,r4,r5,r6,r7,r8]);
            %[v,idx]=max([max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)]);
            if idx==j
                n_correct(1,tw_length)=n_correct(1,tw_length)+1
            end
        end
    end
end
SB1=[];
for i=1:8
    P=SSVEPdata(:,:,:,i);
    Tv=eeg_filt(P,Fs,[7 88]);
    SB1(:,:,:,i)=Tv;
end
SB2=[];
for i=1:8
    P=SSVEPdata(:,:,:,i);
    Tv=eeg_filt(P,Fs,[14 88]);
    SB2(:,:,:,i)=Tv;
end
SB3=[];
for i=1:8
    P=SSVEPdata(:,:,:,i);
    Tv=eeg_filt(P,Fs,[22 88]);
    SB3(:,:,:,i)=Tv;
end
SB4=[];
for i=1:8
    P=SSVEPdata(:,:,:,i);
    Tv=eeg_filt(P,Fs,[30 88]);
    SB4(:,:,:,i)=Tv;
end

SB5=[];
for i=1:8
    P=SSVEPdata(:,:,:,i);
    Tv=eeg_filt(P,Fs,[38 88]);
    SB5(:,:,:,i)=Tv;
end
for run=1:20
    for tw_length=1:8       % time window length:  1s:1s:4s
        fprintf('CCA Processing... TW %fs, No.crossvalidation %d \n',TW(tw_length),run);
        %%%%Part 1
        for j=1:8
            [wx1,wy1,r1]=cca(SB1(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SB1(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SB1(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SB1(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SB1(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SB1(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SB1(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SB1(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));  
            p=[max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)];
            p1(j,:)=p;
        end
        %%%%%%Part 2
        for j=1:8
            [wx1,wy1,r1]=cca(SB2(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SB2(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SB2(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SB2(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SB2(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SB2(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SB2(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SB2(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));  
            p=[max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)];
            p2(j,:)=p;
        end  
       %%%%%%Part 3
        for j=1:8
            [wx1,wy1,r1]=cca(SB3(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SB3(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SB3(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SB3(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SB3(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SB3(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SB3(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SB3(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));  
            p=[max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)];
            p3(j,:)=p;
        end   
        %%%%%%%Part 4     
        for j=1:8
            [wx1,wy1,r1]=cca(SB4(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SB4(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SB4(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SB4(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SB4(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SB4(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SB4(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SB4(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));  
            p=[max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)];
            p4(j,:)=p;
        end                
       %%%%%%Part 5
        for j=1:8
            [wx1,wy1,r1]=cca(SB5(:,1:TW_p(tw_length),run,j),ref1(:,1:TW_p(tw_length)));
            [wx2,wy2,r2]=cca(SB5(:,1:TW_p(tw_length),run,j),ref2(:,1:TW_p(tw_length)));
            [wx3,wy3,r3]=cca(SB5(:,1:TW_p(tw_length),run,j),ref3(:,1:TW_p(tw_length)));
            [wx4,wy4,r4]=cca(SB5(:,1:TW_p(tw_length),run,j),ref4(:,1:TW_p(tw_length)));
            
            
            [wx5,wy5,r5]=cca(SB5(:,1:TW_p(tw_length),run,j),ref5(:,1:TW_p(tw_length)));
            [wx6,wy6,r6]=cca(SB5(:,1:TW_p(tw_length),run,j),ref6(:,1:TW_p(tw_length)));
            [wx7,wy7,r7]=cca(SB5(:,1:TW_p(tw_length),run,j),ref7(:,1:TW_p(tw_length)));
            [wx8,wy8,r8]=cca(SB5(:,1:TW_p(tw_length),run,j),ref8(:,1:TW_p(tw_length)));  
            p=[max(r1),max(r2),max(r3),max(r4),max(r5),max(r6),max(r7),max(r8)];
            p5(j,:)=p;
        end   

        for i=1:8
            ra1=p1(i,:);
            ra2=p2(i,:);
            ra3=p3(i,:);
            ra4=p4(i,:);
            ra5=p5(i,:);
            rrr=0;
            for li=1:8
              np1=ra1(li);
              np2=ra2(li);
              np3=ra3(li);
              np4=ra4(li);
              np5=ra5(li); 
              a=1.25;b=0.25;
%%              rrr(li)=sign(np1)*power(np1,2)+sign(np2)*power(np2,2)+sign(np3)*power(np3,2)+sign(np4)*power(np4,2)+sign(np5)*power(np5,2);
               rrr(li)=(1^(-a)+b)*power(np1,2)+(2^(-a)+b)*power(np2,2)+(3^(-a)+b)*power(np3,2)+(4^(-a)+b)*power(np4,2)+(5^(-a)+b)*power(np5,2);              
            end
            [v,idx]=max(rrr);
            if idx==i
                n_correct(2,tw_length)=n_correct(2,tw_length)+1 
                %n_dccan(1,i,tw_length)=n_dccan(1,i,tw_length)+1;
            end

       end
        
    end
end
accuracy=100*n_correct/n_sti/n_run;
col={'b-*','r-o'};
for mth=1:2
    plot(TW,accuracy(mth,:),col{mth},'LineWidth',1);
    hold on;
end
xlabel('Time window length (s)');
ylabel('Accuracy (%)');
grid;
xlim([0.2 2.1]);
ylim([0 100]);
%set(gca,'xtick',.2:1.1,'xticklabel',.2:1.1);
%title('\bf Rabi vs Nakanishi for SSVEP Recognition');
h=legend({'CCA','Proposed'});
set(h,'Location','SouthEast');