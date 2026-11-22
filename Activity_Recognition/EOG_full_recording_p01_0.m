
%% Project IRIS - EOG Dataset Analysis
% University of Stuttgart EOG Dataset
% Participant 1, Session 0
% Plot the full recording

clear;
clc;
close all;

%% 1. Load the recording

load("C:\Users\siona\Downloads\Eye Movement Analysis for Activity Recognition Using EOG\eog_office\participant1_0.mat");

%% 2. Define sampling frequency and time axis

fs = 128;                 % Sampling frequency (Hz)
N = size(data, 1);        % Number of samples
num_channels = size(data, 2);

t = (0:N-1) / fs;         % Time in seconds
t_min = t / 60;           % Time in minutes

%% 3. Display recording information

fprintf('Number of samples: %d\n', N);
fprintf('Number of columns: %d\n', num_channels);
fprintf('Sampling frequency: %d Hz\n', fs);
fprintf('Duration: %.2f seconds\n', N/fs);
fprintf('Duration: %.2f minutes\n', N/fs/60);

%% 4. Plot the full recording

figure('Name', 'Full EOG Recording', ...
       'NumberTitle', 'off', ...
       'Position', [100 100 1400 900]);

for i = 1:num_channels

    subplot(num_channels, 1, i);

    plot(t_min, data(:,i), ...
         'LineWidth', 0.8);

    title(['Column ', num2str(i)]);
    ylabel('Amplitude');
    grid on;

    xlim([0 t_min(end)]);

end

xlabel('Time (minutes)');

sgtitle('Participant 1 - Full EOG Recording');

%% 5. Plot the first 20 seconds

idx = t < 20;

figure('Name', 'EOG - First 20 Seconds', ...
       'NumberTitle', 'off', ...
       'Position', [100 100 1400 900]);

for i = 1:num_channels

    subplot(num_channels, 1, i);

    plot(t(idx), data(idx,i), ...
         'LineWidth', 1);

    title(['Column ', num2str(i)]);
    ylabel('Amplitude');
    grid on;

    xlim([0 20]);

end

xlabel('Time (seconds)');

sgtitle('Participant 1 - First 20 Seconds');

%% 6. Check signal quality

fprintf('\n--- Signal Quality ---\n');

for i = 1:num_channels

    signal = data(:,i);

    fprintf('\nColumn %d:\n', i);
    fprintf('Minimum: %.4f\n', min(signal));
    fprintf('Maximum: %.4f\n', max(signal));
    fprintf('Mean: %.4f\n', mean(signal));
    fprintf('Standard deviation: %.4f\n', std(signal));
    fprintf('Missing values: %d\n', sum(isnan(signal)));
    fprintf('Repeated adjacent values: %d\n', ...
            sum(diff(signal) == 0));

end
