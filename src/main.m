% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : main.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Entry point for template-based speech recognition using cross-correlation.
%   Loads dataset, evaluates the system, and optionally runs a live demo.
% ========================================================================

function main()
    fprintf('===============================================\n');
    fprintf('  Speech Recognition using Cross-Correlation\n');
    fprintf('===============================================\n\n');

    % Load configuration
    cfg = config_speech_recognition();

    % Load dataset (reference and test sets)
    fprintf('[1/3] Loading dataset from: %s\n', cfg.dataRoot);
    [referenceSet, testSet] = load_dataset(cfg);
    fprintf('    Loaded %d reference samples, %d test samples.\n\n', ...
            numel(referenceSet), numel(testSet));

    if isempty(referenceSet)
        error('Reference set is empty. Please put .wav files under data/reference/<label>/');
    end

    if isempty(testSet)
        warning('Test set is empty. Accuracy will not be computed.');
    end

    % Evaluate system
    fprintf('[2/3] Evaluating system on test set...\n');
    if ~isempty(testSet)
        results = evaluate_model(cfg, referenceSet, testSet);

        fprintf('\n===============================================\n');
        fprintf('Evaluation Results:\n');
        fprintf('  Overall accuracy: %.2f %%\n', results.accuracy * 100);
        fprintf('  Number of test samples: %d\n', numel(testSet));
        fprintf('===============================================\n\n');
    end

    % Optional live demo
    if cfg.enableLiveDemo
        fprintf('[3/3] Starting live recognition demo...\n');
        recognize_live(cfg, referenceSet);
    else
        fprintf('[3/3] Live demo is disabled in config.\n');
    end

    fprintf('Done.\n');
end
