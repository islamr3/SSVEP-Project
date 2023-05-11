%%% The data are available in the reference:
%%% Y. Wang, X. Chen, X. Gao, and S. Gao, “A benchmark dataset for ssvepbased brain-computer interfaces,” IEEE Trans. Neural Syst. Rehabil.Eng.,
%%% vol. 25, no. 10, pp. 1746–1752, Oct 2017
%%%
%% Clear workspace
clear all
close all
% help main

%% Parameter for analysis
dlen_s              = 0.5;                                             % Data length for target identification [s]
delay_s           = 0.14;                                         % Visual latency being considered in the analysis [s]
nFBs                = 1;                                              % The number of sub-bands in filter bank analysis.
%  If you set nFBs = 1, standard CCA-based method will be run.
nHarms            = 5;                                             % The number of harmonics in the canonical correlation analysis (CCA)
isEnsemble      = 1;                                              % 1 -> The ensemble TRCA-based method, 0 -> The TRCA-based method
alpha_ci           = 0.05;                                        % 100*(1-alpha_ci) % confidence intervals

%% Fixed parameter
fs              = 250;                                             % Sampling rate [Hz]
slen_s          = 0.5;                                              % Duration for gaze shifting [s]
listFreqs       = [8:1:15 8.2:1:15.2 8.4:1:15.4 8.6:1:15.6 8.8:1:15.8];
% List of stimulus frequencies
nTargs         = length(listFreqs);                        % The number of stimuli
labels           = [1:1:nTargs];                              % Label of data

%%
dlen_smpl = round(dlen_s*fs);                           % Data length [samples]
delay_smpl = round(delay_s*fs);                       % Visual latency [samples]
ci = 100*(1-alpha_ci);                                        % Confidence interval

load('Sample.mat'); %%% one subject data
t_length=1;
wlen=0.2:0.1:t_length;
Nsub=size(sample,5);

%% SSVEP recognition
method={'CORRCA','WCORRCA'};
n_meth=length(method);
n_correct=zeros(length(wlen),n_meth,Nsub);

NumCC=9;

for iwlen=1:length(wlen)
    dlen_s= wlen(iwlen);
    dlen_smpl = round(dlen_s*fs);                           % Data length [samples]
    fprintf('Proessing Window length = %2.2f\n',dlen_s);
    
    for isub=1:Nsub
        data=sample(:,:,:,:,isub);
        eeg=permute(data,[3 1 2 4]);
        [~, nChans, ~, nBlocks] = size(eeg);
        eeg = eeg(:, :, delay_smpl+1:delay_smpl+dlen_smpl, :);
        
       %% The CorrCA 
        fprintf('SubNum=%d Results of the CorrCA method.\n',isub);
        accs=[];
        for loocv_i = 1:1:nBlocks % Leave-one-out cross validation (LOOCV)

            % Training stage -----------------------------------
            traindata = eeg;
            traindata(:, :, :, loocv_i) = [];
            model_CorrCA = train_CorrCA(traindata, fs, 1);
            
            % Test stage ---------------------------------------
            testdata = squeeze(eeg(:, :, :, loocv_i));
            [estimated]=test_CORRCA(testdata,model_CorrCA);
                     
            % Evaluation ----------------------------------------
            isCorrect = (estimated==labels);
            accs(loocv_i) = mean(isCorrect)*100;

        end % loocv_i
        

        n_correct(iwlen,1,isub)=mean(accs);
        fprintf('Mean accuracy of CORRCA = %2.2f \n', mean(accs));       
        

        %% The WCorrCA
        fprintf('SubNum=%d Results of the WCorrCA method.\n',isub);
        accs=[];
        for loocv_i = 1:1:nBlocks % Leave-one-out cross validation (LOOCV)
            tic;
            % Training stage -----------------------------------
            traindata = eeg;
            traindata(:, :, :, loocv_i) = [];
            model_CorrCASFFF = train_WCorrCA(traindata, fs, nFBs);
            
            % Test stage ---------------------------------------
            testdata = squeeze(eeg(:, :, :, loocv_i));
            [estimated]=test_WCORRCA(testdata,model_CorrCASFFF,NumCC);
              % Evaluation ----------------------------------------
            isCorrect = (estimated==labels);
            accs(loocv_i) = mean(isCorrect)*100;

        end % loocv_i
        
        n_correct(iwlen,2,isub)=mean(accs);
        fprintf('Mean accuracy of WCORRCA = %2.2f \n\n', mean(accs));      
    end
end
