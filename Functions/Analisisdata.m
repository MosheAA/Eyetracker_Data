
file_ID = "C:\Users\ASUS\Documents\MATLAB\VideoMoral\1_all_gaze.csv"; 
Fs = 60; 
allgaze = import_data_gaze(file_ID);
time_v = 0:1/Fs:length(allgaze)/Fs - (1/Fs);
time_2 = 0:1/10:length(allgaze)/10 - (1/Fs);

plot(allgaze(:,1),allgaze(:,2))
test = downsample(allgaze,6);
vidObj = VideoReader('0001-scrn.mp4');
vidObj.CurrentTime = 1;
i = find(time_2>vidObj.CurrentTime,1,"first");
while hasFrame(vidObj)
    vidFrame = readFrame(vidObj);
    ax = gca();
    imshow(vidFrame)
    hold(ax, 'on');
    plot(ax, test(1:i,1)*1920,test(1:i,2)*1080);
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