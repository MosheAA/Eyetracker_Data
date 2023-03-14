
file_ID = "..\MATLAB\VideoMoral\result\User 0_all_gaze.csv"; 
vidObj = VideoReader('..\MATLAB\VideoMoral\result\video_export_02-20-23-15.47.39.avi');

%% TO DO: 1. List stimulus function TSV
%         2. Detect start of series of stimulus
%         3. Segment data according to ongoing experiment phase 
%         4. Select ROI
%         4. Generate ROI-stimulus summary results
Fs_g = 61;                                      % Sampling frequency Gaze 
Fs_v = vidObj.FrameRate;                        % Sampling frequency Video 

allgaze = import_data_gaze(file_ID);                  % Import gaze data
time_v = 0:1/Fs_g:length(allgaze)/Fs_g - (1/Fs_g);    % Time vector
time_2 = 0:1/Fs_v:vidObj.NumFrames/Fs_v - (1/Fs_v);   % Time vector
figure
plot(allgaze(:,2),allgaze(:,3))
plot(allgaze(:,3),allgaze(:,4))
%% Visualize data 
test               = downsample(allgaze,6);
vidObj.CurrentTime = 0;
i                  = find(time_2>=vidObj.CurrentTime,1,"first");

while i < 100
    vidFrame = readFrame(vidObj);
    ax = gca();
    imshow(vidFrame)
    hold(ax, 'on');
    plot(ax, test(1:i,2)*1920,test(1:i,3)*1080);
    hold(ax, 'off');
    pause(1/vidObj.FrameRate);
    i = i+1;
end






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
