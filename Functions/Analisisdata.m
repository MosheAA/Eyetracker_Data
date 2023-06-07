%% Load gaze data
file_ID = "..\MATLAB\Eyetracker_Data-main\Data\User 0_all_gaze.csv"; 
allgaze = import_data_gaze(file_ID);                             % Import gaze data
Fs_g = 60;                                                                        % Sampling frequency Gaze 
time_v = 0:1/Fs_g:length(allgaze)/Fs_g - (1/Fs_g);        % Time vector
valid = ~isnan(allgaze(:,1));
test_interp= interpn(allgaze(valid,1),allgaze(valid,2),time_v,'linear'); 
test_interp1= interpn(allgaze(valid,1),allgaze(valid,3),time_v,'linear'); 
locs_clicks = find(allgaze(:,6)==3); 

plot(test_interp,test_interp1)
hold on
plot(allgaze(valid,2),allgaze(valid,3))
%% Load TSV
file_tsv = "..\MATLAB\Eyetracker_Data-main\Data\prueba etiquetas f - Copy_February 20, 2023_13.50.tsv.xlsx"; 
stim = load_tsv(file_tsv);
%% Load video
vidObj = VideoReader('..\MATLAB\Eyetracker_Data-main\Data\video_export_02-20-23-15.47.39.avi');
Fs_v = vidObj.FrameRate;                                                % Sampling frequency Video 
time_2 = 0:1/Fs_v:vidObj.NumFrames/Fs_v - (1/Fs_v);   % Time vector

%%         2. Detect trial start time 
% Fixation cross
IDX = [58.5, 63, 75, 90];
161:252,405:533
1:261,200:750
250:400,200:750
273:320,710:760
samplefinal = [];
for i = IDX
vidObj.CurrentTime = i;    % Moment in which cross was detected
vidFrame = readFrame(vidObj);
sample = rgb2gray(vidFrame);
imshow(sample)
sample1 = imresize(sample,1/2);
imshow(sample1)
%sample_cell = {sample_f1,sample_f2,sample_f3,sample_f4};
sample_f4 = sample1(1:350,200:800,:); 
imshow(sample_f4)
boxPoints = detectSURFFeatures(sample_f4,'MetricThreshold',1);
samplefinal = cat(3,samplefinal,sample2);
pause
end 
imshow(sample)
[start_trial_cross] = detect_fix_cross(sample, vidObj);
% Check if correct fixation crosses were detected
for i = 1:length(start_trial_cross)
    vidObj.CurrentTime = start_trial_cross(i)/vidObj.FrameRate;
    vidFrame = readFrame(vidObj);
    nexttile 
    imshow(vidFrame)
end
%%         3. Segment data according to ongoing experiment phase 
% Cross -> 1500ms -> Stim 1 -> 12500ms -> Stim 2 -> 14000ms -> Test ->
% click -> click -> end
Stim_1 = start_trial_cross + (Fs_v*1.5);              % 1.5 s 
Stim_2 = start_trial_cross + (Fs_v*(1.5+12.5));       % 1.5 + 12.5 s 
Stim_test = start_trial_cross + (Fs_v*(1.5+12.5+14)); % 1.5 + 12.5 + 14 s 

figure;plot(allgaze(:,1),allgaze(:,end))
hold on
scatter(start_trial_cross/Fs_v,1,50,"green","filled","^")
scatter(Stim_1/Fs_v,1,50,"black","filled","^")
scatter(Stim_2/Fs_v,1,50,"black","filled","^")
scatter(Stim_test/Fs_v,1,50,"red","filled","^")

%%         4. Select ROI
figure;
frames_to_select = [Stim_1(1)+10, Stim_2(1)+1, Stim_test(1)+10];
roi = cell(1,6);
k = 1;
for i = 1:length(frames_to_select)
    vidObj.CurrentTime = time_2(frames_to_select(i));
    vidFrame = readFrame(vidObj);
    ax = gca();
    imshow(vidFrame)
if i == 1
    rect = drawrectangle(gca);
    roi{k} = rect.Position;
    k = k+1;
elseif i == 2
    rect = drawrectangle(gca);
    roi{k} = rect.Position;
    k = k+1;
     rect = drawrectangle(gca);
    roi{k} = rect.Position;
    k = k+1;
    rect = drawrectangle(gca);
    roi{k} = rect.Position;    
    k = k+1;
elseif i == 3
     rect = drawrectangle(gca);
    roi{k} = rect.Position;
    k = k+1;
     rect = drawrectangle(gca);
    roi{k} = rect.Position;
end 
end 
close all
%% 4. Generate ROI-based summary results
in = []; 
xq = test_interp*1920;
yq = test_interp1*1080;
for r = 1:length(roi)
    xv = [roi{1,r}(1,1) roi{1,r}(1,1)+roi{1,r}(1,3)];
    yv = [roi{1,r}(1,2) roi{1,r}(1,2)+roi{1,r}(1,4)];
    in(:,r) = inpolygon(xq,yq,xv,yv);
end 
stim_1_gaze =[]; stim_2_gaze =[]; stim_Test_gaze = [];
for i = 1:length(Stim_1)
    % Stimulus set 1
    ini = (Stim_1(i)./Fs_v)*Fs_g;
    fin = (Stim_2(i)./Fs_v)*Fs_g;
    idx = find(in(ini:fin,1));
    stim_1_gaze(i,1) = numel(idx)*(1/Fs_g);
    % Stimulus set 2
    ini = (Stim_2(i)./Fs_v)*Fs_g;
    fin = (Stim_test(i)./Fs_v)*Fs_g;
    idx1 = find(in(ini:fin,2));
    idx2 = find(in(ini:fin,3));
    idx3 = find(in(ini:fin,4));

    stim_2_gaze(i,1) = numel(idx1)*(1/Fs_g);
    stim_2_gaze(i,2) = numel(idx2)*(1/Fs_g);
    stim_2_gaze(i,3) = numel(idx3)*(1/Fs_g);
    % Stimulus set 3 - Test
    ini = (Stim_test(i)./Fs_v)*Fs_g;
    clic_idx = find(locs_clicks>ini,1,"first");
    fin = locs_clicks(clic_idx); %% When click!
    idx1 = find(in(ini:fin,5));
    idx2 = find(in(ini:fin,6));
    stim_Test_gaze(i,1) = numel(idx1)*(1/Fs_g);
    stim_Test_gaze(i,2) = numel(idx2)*(1/Fs_g);
end
%%
roi_s = ["ROI_1","ROI_2","ROI_3","ROI_4","ROI_5","ROI_6"];
varTypes = cell(0); varNames = cell(0);
% Create variable names
k = 1;
for s = 1:length(stim)
    for r = 1:length(roi_s)
        varNames{k} = char(strcat(stim(s),"_",roi_s(r)));
        varTypes{k} = 'double';
        k = k+1;
    end 
end 
% Concatenate sessions
summary = []; 
for i = 1:length(stim)
summary = cat(2,summary,stim_1_gaze(i,:),stim_2_gaze(i,:),stim_Test_gaze(i,:));
end 
% 
sz = [1 length(varNames)];
T2 = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
T2{1,:} = summary; 

%% Visualize data 
figure;
test               = downsample(in,6);
test1              = downsample([xq;yq]',6);

vidObj.CurrentTime = 47;
i                  = find(time_2>=vidObj.CurrentTime,1,"first");

while i < i+417
    vidFrame = readFrame(vidObj);
    ax = gca();
    imshow(vidFrame)
    hold(ax, 'on');
    text(1000,440,num2str(i))
    text(1000,480,num2str(test(i)))
    plot(ax, test1(i-10:i,1),test1(i-10:i,2),"LineWidth",0.9);
    hold(ax, 'off');
    pause(1/vidObj.FrameRate);
    i = i+1;
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
vidObj.CurrentTime = time_2(frames_to_select(i));
vidFrame = readFrame(vidObj);
ax = gca();
imshow(vidFrame)
hold on
h = drawrectangle('Position',[roi{1,r}(1,1),roi{1,r}(1,2),roi{1,r}(1,3),roi{1,r}(1,4)],'StripeColor','r');

scatter(xq(1,logical(in(:,1))'),yq(1,logical(in(:,1))'))

idx = find(in(Stim_2(i):Stim_3(i),1));
stim_2_gaze(i) = numel(idx)*(1/Fs_v);
 
scatter(xq(1,logical(in(:,1))'),yq(1,logical(in(:,1))'))
