% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : preprocess_audio.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Basic speech preprocessing:
%     - Resampling to targetFs
%     - Pre-emphasis
%     - Band-pass filtering
%     - Amplitude normalization
%     - Silence trimming
%     - Duration normalization (padding/clipping)
% ========================================================================

function [y, fsOut] = preprocess_audio(x, fsIn, cfg)
    x = x(:); % ensure column

    % ------------------------------------------------------------
    % 1) Resample to targetFs
    % ------------------------------------------------------------
    targetFs = cfg.targetFs;
    if fsIn ~= targetFs
        [P, Q] = rat(targetFs / fsIn);
        x = resample(x, P, Q);
        fs = targetFs;
    else
        fs = fsIn;
    end

    % ------------------------------------------------------------
    % 2) Pre-emphasis
    % ------------------------------------------------------------
    if isfield(cfg, 'preEmphasis') && cfg.preEmphasis > 0
        x = filter([1 -cfg.preEmphasis], 1, x);
    end

    % ------------------------------------------------------------
    % 3) Band-pass filter (speech band)
    % ------------------------------------------------------------
    if isfield(cfg, 'bandpass') && numel(cfg.bandpass) == 2
        Wn = cfg.bandpass / (fs / 2);
        % 4th order Butterworth band-pass
        [b, a] = butter(4, Wn, 'bandpass');
        x = filtfilt(b, a, x);
    end

    % ------------------------------------------------------------
    % 4) Amplitude normalization
    % ------------------------------------------------------------
    maxVal = max(abs(x)) + eps;
    x = x ./ maxVal;

    % ------------------------------------------------------------
    % 5) Simple silence trimming (based on relative amplitude)
    % ------------------------------------------------------------
    if isfield(cfg, 'silenceThreshold')
        thr = cfg.silenceThreshold;
    else
        thr = 0.02;
    end

    absX = abs(x);
    mask = absX > thr * max(absX);

    if any(mask)
        idx = find(mask);
        x = x(idx(1):idx(end));
    end

    % ------------------------------------------------------------
    % 6) Duration normalization (pad or clip)
    % ------------------------------------------------------------
    minLen = round(cfg.minSignalDuration * fs);
    maxLen = round(cfg.maxSignalDuration * fs);

    L = numel(x);
    if L < minLen
        x = [x; zeros(minLen - L, 1)];
    elseif L > maxLen
        x = x(1:maxLen);
    end

    y     = x;
    fsOut = fs;
end
