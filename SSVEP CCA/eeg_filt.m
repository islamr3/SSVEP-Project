function EEG = eeg_filt(EEG,Fs,freqband)
% Ref: use function "load_filteredEEG" to filter EEG signals.
% The results will be saved to be reloaded for later analysis.
[B,A] = butter(5,freqband/Fs*2);  % freqband = [f1 f2]
for i=1:size(EEG,3)
     EEG(:,:,i) = filtfilt(B,A,EEG(:,:,i)')';
end
