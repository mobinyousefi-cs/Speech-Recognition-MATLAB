% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : recognize_live.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Records a short utterance from the microphone and performs
%   template-based recognition using cross-correlation.
% ========================================================================

function recognize_live(cfg, referenceSet)
    if isempty(referenceSet)
        warning('Reference set is empty. Live recognition cannot run.');
        return;
    end

    fs = cfg.targetFs;
    recDuration = cfg.liveRecordDuration;

    fprintf('\n===============================================\n');
    fprintf('Live Demo: Template-based Speech Recognition\n');
    fprintf('===============================================\n');
    fprintf('The system will record for %.2f seconds at %d Hz.\n', ...
            recDuration, fs);
    fprintf('%s\n', cfg.livePromptText);

    % Prepare recorder (mono, 16-bit)
    recObj = audiorecorder(fs, 16, 1);

    % Wait a bit and then record
    pause(0.5);
    recordblocking(recObj, recDuration);
    fprintf('Recording finished.\n');

    % Get audio and preprocess
    x = getaudiodata(recObj);
    [xProc, fsProc] = preprocess_audio(x, fs, cfg);

    liveSample = struct();
    liveSample.signal   = xProc;
    liveSample.fs       = fsProc;
    liveSample.label    = 'unknown';
    liveSample.filePath = 'live_recording';

    % Predict label
    [predLabel, scoresByLabel] = predict_label(liveSample, referenceSet);
    fprintf('Predicted label: %s\n', predLabel);

    % Show scores
    [scoresSorted, idxSorted] = sort([scoresByLabel.score], 'descend');
    fprintf('Scores by label (sorted):\n');
    for k = 1:numel(scoresSorted)
        fprintf('  %s: %.3f\n', ...
            scoresByLabel(idxSorted(k)).label, scoresSorted(k));
    end

    % Optional visualization
    try
        plot_signal(xProc, fsProc, sprintf('Live Sample (Predicted: %s)', predLabel));
    catch
        % plotting is optional
    end
end
