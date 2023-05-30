function [T2] = analize_video(file_ID,file_tsv,file_video,vidFrame,roi,plt)
%% Load gaze data
[allgaze,date] = import_data_gaze(file_ID);                             % Import gaze data
Fs_g = 60;                                                                        % Sampling frequency Gaze 
time_v = 0:1/Fs_g:length(allgaze)/Fs_g - (1/Fs_g);        % Time vector
valid = ~isnan(allgaze(:,1));
test_interp= interpn(allgaze(valid,1),allgaze(valid,2),time_v,'linear'); 
test_interp1= interpn(allgaze(valid,1),allgaze(valid,3),time_v,'linear'); 
locs_clicks = find(allgaze(:,6)==3); 
%% Load TSV
stim = load_tsv(file_tsv,date);
%% Load video
vidObj = VideoReader(file_video);
Fs_v = vidObj.FrameRate;                                                % Sampling frequency Video 
time_2 = 0:1/Fs_v:vidObj.NumFrames/Fs_v - (1/Fs_v);   % Time vector
%%         2. Detect trial start time 
% Fixation cross
sample = rgb2gray(vidFrame);
[start_trial_cross] = detect_fix_cross(sample, vidObj);
% Check if correct fixation crosses were detected
if plt
    for i = 1:length(start_trial_cross)
        vidObj.CurrentTime = start_trial_cross(i)/vidObj.FrameRate;
        vidFrame = readFrame(vidObj);
        nexttile 
        imshow(vidFrame)
    end
end 
%%         3. Segment data according to ongoing experiment phase 
% Cross -> 1500ms -> Stim 1 -> 12500ms -> Stim 2 -> 14000ms -> Test ->
% click -> click -> end
Stim_1 = start_trial_cross + (Fs_v*1.5);              % 1.5 s 
Stim_2 = start_trial_cross + (Fs_v*(1.5+12.5));       % 1.5 + 12.5 s 
Stim_test = start_trial_cross + (Fs_v*(1.5+12.5+14)); % 1.5 + 12.5 + 14 s 
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
end 