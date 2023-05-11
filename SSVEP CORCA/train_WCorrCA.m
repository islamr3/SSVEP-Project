function model = train_WCorrCA(eeg, fs, nFBs)
%% Input:
%   eeg         : Input eeg data
%                               (The number of targets, The number of channels, Data length [sample] , The number of trials)
%   fs          : Sampling frequency
%   nFBs        :The number of sub-bands
%% Output:
%   model       : Learning model for tesing phase of the ensemble TRCA-based method
%       - traindata         : Training data decomposed into sub-band components by the filter bank analysis
%                             (The number of targets, The number of sub-bands, The number of channels, Data length [sample])
%       - W                 : Weight coefficients for electrodes which can be used as a spatial filter.
%       - nFBs              :The number of sub-bands
%       - fs                : Sampling frequency
%       - nTargs        : The number of targets
if nargin < 2, error('stats:train_trca:LackOfInput', 'Not enough input arguments.'); end
if ~exist('nFBs', 'var') || isempty(nFBs), nFBs = 3; end

[nTargs, nChans, nSmpls, ~] = size(eeg);
trains = zeros(nTargs, nFBs, nChans, nSmpls);
for targ_i = 1:1:nTargs
    eeg_tmp = squeeze(eeg(targ_i, :, :, :));
    for fb_i = 1:1:nFBs
        train_tmp = filterbank(eeg_tmp, fs, fb_i);
        trains(targ_i,fb_i,:,:) = squeeze(mean(train_tmp, 3));
    end % fb_i
end % targ_i
model = struct('trains', trains, 'nFBs', nFBs, 'fs', fs, 'nTargs', nTargs);
