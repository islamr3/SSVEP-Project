function [results] = test_WCORRCA(eeg, model,NumCC)
% Input:
%   eeg             : Input eeg data
%                           (The number of targets, The number of channels, Data length [sample])
%   listFreq        : List for stimulus frequencies
%   fs                 : Sampling frequency
%   nHarms       : The number of harmonics
%   nFBs            : The number of filters in filterbank analysis
%   NumCC           : The number of correlation coefficients to be fused.
%                   (We can simple used all of them)
%
% Output:
%   results         : The target estimated by this method
a = [1:model.nFBs].^(-1.25)+0.25;
b=exp(-0.6*(1:NumCC))+0.0;  %%%% You can change this formula and its parameters.
for targ_i = 1:1:model.nTargs
    test_tmp = squeeze(eeg(targ_i, :, :));
    for fb_i = 1:1:model.nFBs
        testdata = filterbank(test_tmp, model.fs, fb_i);
%         testdata = test_tmp;
        for class_i = 1:1:model.nTargs
            traindata =  squeeze(model.trains(class_i, fb_i, :, :));
            [~,r_tmp] = CorrCA(testdata, traindata);
            r(fb_i, class_i) = b*r_tmp(1:NumCC);
        end % class_i
    end % fb_i
    rho = a*r;
    [~, tau] = max(rho);
    results(targ_i) = tau;
end % targ_i
end
