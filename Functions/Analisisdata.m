%% Load gaze data
file_ID = "..\MATLAB\Eyetracker_Data-main\Data\User 0_all_gaze.csv"; 
allgaze = import_data_gaze(file_ID);                             % Import gaze data
Fs_g = 61;                                                                        % Sampling frequency Gaze 
time_v = 0:1/Fs_g:length(allgaze)/Fs_g - (1/Fs_g);        % Time vector
%% Load TSV
file_tsv = "..\MATLAB\Eyetracker_Data-main\Data\prueba etiquetas f - Copy_February 20, 2023_13.50.tsv.xlsx"; 
stim = load_tsv(file_tsv);
%% Load video
vidObj = VideoReader('..\MATLAB\Eyetracker_Data-main\Data\video_export_02-20-23-15.47.39.avi');
Fs_v = vidObj.FrameRate;                                                % Sampling frequency Video 
time_2 = 0:1/Fs_v:vidObj.NumFrames/Fs_v - (1/Fs_v);   % Time vector

%%         2. Detect trial start time 
% Fixation cross
vidObj.CurrentTime = 47;
vidFrame = readFrame(vidObj);
sample = rgb2gray(vidFrame);
[start_trial_cross] = detect_fix_cross(sample, vidObj);
%%         3. Segment data according to ongoing experiment phase 


%         4. Select ROI
%         4. Generate ROI-stimulus summary results
%% Visualize data 
test               = downsample(allgaze,6);
vidObj.CurrentTime = 250;
i                  = find(time_2>=vidObj.CurrentTime,1,"first");

while i < 7000
    vidFrame = readFrame(vidObj);
    ax = gca();
    imshow(vidFrame)
    hold(ax, 'on');
    %plot(ax, test(1:i,2)*1920,test(1:i,3)*1080);
    if start_trial_cross(i) && cert(i)>2e4
        text(889,440,"cross")
        text(1000,440,num2str(cert(i)))
    end 
    hold(ax, 'off');
    pause(1/vidObj.FrameRate);

    i = i+1;
end
[pks,locs] = findpeaks(start_trial_cross,"MinPeakDistance",40);

for i = 1:length(start_trial_cross)
    vidObj.CurrentTime = start_trial_cross(i)/vidObj.FrameRate;
    vidFrame = readFrame(vidObj);
    nexttile 
    imshow(vidFrame)
end



%% Visualize data 







%%
figure;plot(time_v, allgaze(:,1))
hold on; plot(time_v, allgaze(:,2))
xlabel('Tiempo (s)')
ylabel('Coordenadas normalizadas')
legend({'x','y'})
%%
figure;plot(allgaze(:,1), allgaze(:,2))
hold on;
xlabel('x')
ylabel('y')
