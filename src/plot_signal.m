% ========================================================================
% Project   : Speech Recognition using MATLAB
% File      : plot_signal.m
% Author    : Mobin Yousefi (GitHub: https://github.com/mobinyousefi-cs)
% Created   : 2025-11-22
% Description:
%   Utility function to visualize waveform and magnitude spectrum.
% ========================================================================

function plot_signal(x, fs, titleStr)
    if nargin < 3
        titleStr = '';
    end

    x = x(:);
    N = numel(x);
    t = (0:N-1) / fs;

    figure('Name', ['Signal Plot - ' titleStr]);

    subplot(2,1,1);
    plot(t, x);
    xlabel('Time [s]');
    ylabel('Amplitude');
    grid on;
    title(['Waveform ' titleStr]);

    X = abs(fft(x));
    f = (0:N-1) * fs / N;

    subplot(2,1,2);
    plot(f(1:floor(N/2)), X(1:floor(N/2)));
    xlabel('Frequency [Hz]');
    ylabel('|X(f)|');
    grid on;
    title(['Magnitude Spectrum ' titleStr]);
end
