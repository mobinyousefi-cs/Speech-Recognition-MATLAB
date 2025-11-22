% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : predict_label.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Predicts the label of a test sample using a set of reference samples.
%   Each reference sample has fields: signal, label.
%   The label score is the maximum cross-correlation over its templates.
% ========================================================================

function [predLabel, scoresByLabel] = predict_label(testSample, referenceSet)
    if isempty(referenceSet)
        error('Reference set is empty.');
    end

    labels = {referenceSet.label};
    uniqueLabels = unique(labels);
    nLabels = numel(uniqueLabels);

    scores = zeros(nLabels, 1);

    % Compute similarity with each reference sample
    for i = 1:numel(referenceSet)
        refSignal = referenceSet(i).signal;
        s = compute_normalized_xcorr(testSample.signal, refSignal);

        labelIdx = find(strcmp(uniqueLabels, referenceSet(i).label));
        % We take the maximum score over templates per label
        scores(labelIdx) = max(scores(labelIdx), s);
    end

    % Winner-takes-all
    [~, bestIdx] = max(scores);
    predLabel = uniqueLabels{bestIdx};

    % Pack scores into a struct array for debugging / analysis
    scoresByLabel = struct('label', uniqueLabels, 'score', num2cell(scores));
end
