%% Project IRIS - EOG Classification Baseline
% Participant 1, Session 0

clear;
clc;
close all;

%% 1. Load dataset

folder = "C:\Users\siona\Downloads\Eye Movement Analysis for Activity Recognition Using EOG\eog_office";

S = load(fullfile(folder, "participant1_0.mat"));
data = S.data;

fs = 128;  % Confirm against dataset documentation

%% 2. Extract signals and labels

eog1 = double(data(:,3));
eog2 = double(data(:,4));

labels = double(data(:,5));

N = size(data,1);

t = (0:N-1)' / fs;

fprintf('Samples: %d\n', N);
fprintf('Duration at 128 Hz: %.2f minutes\n', N/fs/60);
fprintf('Unique labels:\n');
disp(unique(labels));

%% 2.5 EOG Signal Preprocessing

% Preserve original signals for comparison
rawEOG1 = eog1;
rawEOG2 = eog2;

% Verify fs = 128 Hz against dataset documentation.

% Design a 4th-order Butterworth low-pass filter
cutoffFreq = 20;  % Hz
[b, a] = butter(4, cutoffFreq/(fs/2), 'low');

% Apply zero-phase filtering
eog1 = filtfilt(b, a, eog1);
eog2 = filtfilt(b, a, eog2);

% Compare raw and filtered EOG
figure;

subplot(2,1,1);
plot(t, rawEOG1);
hold on;
plot(t, eog1);
title('EOG Channel 1: Raw vs Filtered');
legend('Raw', 'Filtered');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

subplot(2,1,2);
plot(t, rawEOG2);
hold on;
plot(t, eog2);
title('EOG Channel 2: Raw vs Filtered');
legend('Raw', 'Filtered');
xlabel('Time (s)');
ylabel('Amplitude');
grid on;

%% Compare 5 seconds of raw and filtered EOG

startTime = 180;
endTime = 185;

idx = t >= startTime & t <= endTime;

figure;

plot(t(idx), rawEOG1(idx), 'b');
hold on;
plot(t(idx), eog1(idx), 'r', 'LineWidth', 1.5);

legend('Raw', 'Filtered');
xlabel('Time (s)');
ylabel('Amplitude');
title('EOG Channel 1: Raw vs Filtered (5 seconds)');
grid on;

%% 3. Plot EOG channels and labels

figure;

subplot(3,1,1);
plot(t, eog1);
title('EOG Channel 1');
ylabel('Raw amplitude');
grid on;

subplot(3,1,2);
plot(t, eog2);
title('EOG Channel 2');
ylabel('Raw amplitude');
grid on;

subplot(3,1,3);
stairs(t, labels);
title('Dataset Labels');
xlabel('Time (s)');
ylabel('Label');
grid on;

%% 4. Inspect label transitions

transitionIdx = find(diff(labels) ~= 0) + 1;

startIdx = [1; transitionIdx];
endIdx = [transitionIdx - 1; N];

segmentLabels = labels(startIdx);

segmentSamples = endIdx - startIdx + 1;

segmentTable = table( ...
    startIdx, ...
    endIdx, ...
    segmentLabels, ...
    segmentSamples, ...
    'VariableNames', ...
    {'StartIndex','EndIndex','Label','NumSamples'} ...
);

disp(segmentTable);

%% 5. Window segmentation

windowSize = fs;   % 1-second windows at nominal 128 Hz

X = [];
Y = [];
groupID = [];

for s = 1:length(startIdx)

    firstSample = startIdx(s);
    lastSample = endIdx(s);

    currentLabel = segmentLabels(s);

    for k = firstSample:windowSize:(lastSample-windowSize+1)

        idx = k:(k+windowSize-1);

        window1 = eog1(idx);
        window2 = eog2(idx);

        % Feature extraction for both channels
        features1 = extractEOGFeatures(window1);
        features2 = extractEOGFeatures(window2);

        X = [X; features1, features2];
        Y = [Y; currentLabel];

        % Keep track of the original labeled segment
        groupID = [groupID; s];

    end
end

fprintf('Number of windows: %d\n', size(X,1));
fprintf('Features per window: %d\n', size(X,2));

function features = extractEOGFeatures(signal)

    signal = double(signal(:));

    features = [
        mean(signal), ...
        std(signal), ...
        min(signal), ...
        max(signal), ...
        max(signal)-min(signal), ...
        sqrt(mean(signal.^2)), ...
        mean(abs(diff(signal))), ...
        signal(end)-signal(1)
    ];

end

%% 6. Inspect feature matrix

disp('First five feature vectors:');
disp(X(1:5,:));

disp('First five labels:');
disp(Y(1:5));

fprintf('Total windows: %d\n', length(Y));

% Check for invalid feature values
fprintf('Non-finite feature values: %d\n', ...
    sum(~isfinite(X(:))));

% Check class distribution (no toolbox required)
uniqueLabels = unique(Y);

fprintf('\n--- Class Distribution ---\n');
fprintf('Label\tCount\tPercentage\n');

for i = 1:length(uniqueLabels)

    label = uniqueLabels(i);

    count = sum(Y == label);

    percentage = count / length(Y) * 100;

    fprintf('%d\t%d\t%.2f%%\n', ...
        label, count, percentage);

end

%% 7. Train exploratory Random Forest

rng(42);

% Random window split - debugging only
cv = cvpartition(Y, 'HoldOut', 0.2);

X_train = X(training(cv), :);
Y_train = Y(training(cv));

X_test = X(test(cv), :);
Y_test = Y(test(cv));

% Train ensemble
model = TreeBagger(100, X_train, categorical(Y_train), ...
    'Method', 'classification');

% Predict
predictedLabels = predict(model, X_test);

Y_pred = str2double(predictedLabels);

% Accuracy
accuracy = mean(Y_pred == Y_test);

fprintf('Exploratory accuracy: %.2f%%\n', accuracy*100);

% Confusion matrix
figure;
confusionchart(categorical(Y_test), categorical(Y_pred));

title('Exploratory EOG Activity-Label Classification');