% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : evaluate_model.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Evaluates the recognition system on a test set and prints results.
% ========================================================================

function results = evaluate_model(cfg, referenceSet, testSet)
    nTest = numel(testSet);
    if nTest == 0
        warning('Test set is empty, nothing to evaluate.');
        results = struct('accuracy', NaN, ...
                         'trueLabels', {{}}, ...
                         'predLabels', {{}});
        return;
    end

    trueLabels = cell(nTest, 1);
    predLabels = cell(nTest, 1);

    correct = 0;

    for i = 1:nTest
        testSample = testSet(i);
        [predLabel, scoresByLabel] = predict_label(testSample, referenceSet);
        predLabels{i} = predLabel;
        trueLabels{i} = testSample.label;

        if strcmp(predLabel, testSample.label)
            correct = correct + 1;
        end

        if cfg.verbose
            fprintf('[%3d/%3d] True: %-15s Pred: %-15s | ', ...
                    i, nTest, testSample.label, predLabel);
            % Print best two scores
            [scoresSorted, idxSorted] = sort([scoresByLabel.score], 'descend');
            topK = min(2, numel(scoresSorted));
            for k = 1:topK
                fprintf('%s=%.3f ', ...
                        scoresByLabel(idxSorted(k)).label, scoresSorted(k));
            end
            fprintf('\n');
        end
    end

    accuracy = correct / nTest;

    results = struct();
    results.accuracy   = accuracy;
    results.trueLabels = trueLabels;
    results.predLabels = predLabels;

    % Optional confusion chart (if available)
    if cfg.showConfusionChart
        try
            figure('Name', 'Confusion Chart');
            confusionchart(categorical(trueLabels), categorical(predLabels));
            title(sprintf('Speech Recognition - Accuracy: %.2f %%', accuracy * 100));
        catch
            % confusionchart may not be available in some MATLAB editions
            warning('Could not display confusion chart (toolbox not available).');
        end
    end
end
