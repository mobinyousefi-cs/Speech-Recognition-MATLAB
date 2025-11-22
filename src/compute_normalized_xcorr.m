% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : compute_normalized_xcorr.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Computes the maximum absolute value of normalized cross-correlation
%   between test and reference signals.
% ========================================================================

function score = compute_normalized_xcorr(testSig, refSig)
    testSig = testSig(:);
    refSig  = refSig(:);

    % Normalized cross-correlation
    c = xcorr(testSig, refSig, 'coeff');

    % Use the maximum absolute correlation as similarity score
    score = max(abs(c));
end
