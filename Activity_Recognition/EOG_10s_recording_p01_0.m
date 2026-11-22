
%% Examine individual EOG events

fs = 128;
t = (0:size(data,1)-1)/fs;

% Extract the two EOG channels
EOG1 = data(:,3);
EOG2 = data(:,4);

% Select a 10-second window
start_time = 60;
end_time = 70;

idx = t >= start_time & t < end_time;

figure;

subplot(2,1,1);
plot(t(idx), EOG1(idx), 'b', 'LineWidth', 1);
title('EOG Channel 3');
ylabel('Recorded amplitude');
grid on;
xlim([start_time end_time]);

subplot(2,1,2);
plot(t(idx), EOG2(idx), 'r', 'LineWidth', 1);
title('EOG Channel 4');
xlabel('Time (seconds)');
ylabel('Recorded amplitude');
grid on;
xlim([start_time end_time]);

sgtitle('Participant 1 - 10 Second EOG Segment');
