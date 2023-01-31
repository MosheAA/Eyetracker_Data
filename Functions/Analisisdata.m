
file_ID = "..\MATLAB\Eyetracker_Data-main\Data\1_all_gaze.csv"; 
vidObj = VideoReader('..\MATLAB\Eyetracker_Data-main\Data\video_export_01-25-23-15.35.44.avi');

Fs_g = 61;                                      % Sampling frequency Gaze 
Fs_v = vidObj.FrameRate;                        % Sampling frequency Video 

allgaze = import_data_gaze(file_ID);                  % Import gaze data
time_v = 0:1/Fs_g:length(allgaze)/Fs_g - (1/Fs_g);    % Time vector
time_2 = 0:1/Fs_v:vidObj.NumFrames/Fs_v - (1/Fs_v);   % Time vector
figure
plot(allgaze(:,1),allgaze(:,2))
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
    plot(ax, test(1:i,3)*1920,test(1:i,4)*1080);
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