% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : load_dataset.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Loads reference and test sets from folder structure:
%     referenceRoot/label/*.wav
%     testRoot/label/*.wav
% ========================================================================

function [referenceSet, testSet] = load_dataset(cfg)
    referenceSet = load_split(cfg.referenceRoot, cfg);
    testSet      = load_split(cfg.testRoot, cfg);
end

% ------------------------------------------------------------------------
function samples = load_split(rootDir, cfg)
    samples = [];

    if ~isfolder(rootDir)
        warning('Directory not found: %s', rootDir);
        return;
    end

    dirInfo = dir(rootDir);
    dirInfo = dirInfo([dirInfo.isdir]);

    % Remove "." and ".."
    dirInfo = dirInfo(~ismember({dirInfo.name}, {'.', '..'}));

    idx = 0;
    for d = 1:numel(dirInfo)
        label = dirInfo(d).name;
        labelDir = fullfile(rootDir, label);

        fileInfo = dir(fullfile(labelDir, '*.wav')); % primary extension
        % Also support allowedExtensions from cfg
        if isempty(fileInfo)
            for ext = cfg.allowedExtensions
                fileInfo = [fileInfo; dir(fullfile(labelDir, ['*' ext{1}]))]; %#ok<AGROW>
            end
        end

        for f = 1:numel(fileInfo)
            idx = idx + 1;
            filePath = fullfile(labelDir, fileInfo(f).name);
            try
                [x, fs] = audioread(filePath);
            catch ME
                warning('Cannot read file %s: %s', filePath, ME.message);
                continue;
            end

            % Convert to mono if stereo
            if size(x, 2) > 1
                x = mean(x, 2);
            end

            % Preprocess
            [xProc, fsProc] = preprocess_audio(x, fs, cfg);

            samples(idx).signalRaw = x;          %#ok<AGROW>
            samples(idx).signal    = xProc;      %#ok<AGROW>
            samples(idx).fs        = fsProc;     %#ok<AGROW>
            samples(idx).label     = label;      %#ok<AGROW>
            samples(idx).filePath  = filePath;   %#ok<AGROW>
        end
    end
end
