% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : config_speech_recognition.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Central configuration for the speech recognition project.
% ========================================================================

function cfg = config_speech_recognition()
    % Base paths
    projectRoot     = fileparts(mfilename('fullpath'));  % this file's folder
    dataRoot        = fullfile(projectRoot, 'data');
    referenceRoot   = fullfile(dataRoot, 'reference');
    testRoot        = fullfile(dataRoot, 'test');

    cfg = struct();

    % Paths
    cfg.projectRoot   = projectRoot;
    cfg.dataRoot      = dataRoot;
    cfg.referenceRoot = referenceRoot;
    cfg.testRoot      = testRoot;

    % Signal processing parameters
    cfg.targetFs           = 16000;   % Target sampling rate [Hz]
    cfg.preEmphasis        = 0.97;    % Pre-emphasis factor (0 to disable)
    cfg.bandpass           = [300 3400]; % Speech band [Hz]
    cfg.minSignalDuration  = 0.30;    % Minimum duration after trimming [s]
    cfg.maxSignalDuration  = 1.50;    % Maximum duration after trimming [s]
    cfg.silenceThreshold   = 0.02;    % Relative threshold for silence removal

    % Evaluation / printing
    cfg.verbose            = true;    % Print predictions for each test sample
    cfg.showConfusionChart = true;    % Try to show confusion chart (if available)

    % Live demo
    cfg.enableLiveDemo     = true;
    cfg.liveRecordDuration = 1.0;     % seconds
    cfg.livePromptText     = 'Say your keyword now...';

    % Miscellaneous
    cfg.allowedExtensions  = {'.wav', '.WAV'};
end
