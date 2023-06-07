function [locs_cell] = detect_fix_cross(sample_cell,vidObj)

% Fixation cross
boxFeatures_f = cell(1,4);
for i = 1:4
    m_thold = 1000;
boxPoints = detectSURFFeatures(sample_cell{i},'MetricThreshold',m_thold);
[boxFeatures, ~] = extractFeatures(sample_cell{i}, boxPoints);
boxFeatures_f{i} = boxFeatures;
end 
idx = [161,252,405,533;...
         1,261,200,750;...
       250,400,200,750;...
         1,350,200,800];
detection = zeros(1,vidObj.NumFrames);
m_thold = 1000;
frame = 500; 
trials = 1;
i = 1; 
while trials<=18
vidObj.CurrentTime = frame/vidObj.FrameRate;
vidFrame = imresize(readFrame(vidObj),1/2);
C = rgb2gray(vidFrame(idx(i,1):idx(i,2),idx(i,3):idx(i,4),:));
%figure;imshow(C)
if i == 4
m_thold = 100;
end 
scenePoints = detectSURFFeatures(C,'MetricThreshold',m_thold);
[sceneFeatures, scenePoints] = extractFeatures(C, scenePoints);
boxPairs = matchFeatures(boxFeatures_f{i}, sceneFeatures);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
if i == 4
    x_Cond = any(matchedScenePoints.Location(:,1)>250 & matchedScenePoints.Location(:,1)<310);
    y_Cond = any(matchedScenePoints.Location(:,2)>150 & matchedScenePoints.Location(:,2)<160);
    y_Cond1 = any( matchedScenePoints.Location(:,1)>510 & matchedScenePoints.Location(:,2)>280);
    if ~(x_Cond && y_Cond && y_Cond1)
        frame = frame+1;
        continue
    end 
end 
frame = frame+1;
%fprintf(strcat("frame: ",num2str(frame),"/",num2str(vidObj.NumFrames),"\n"))
if any(matchedScenePoints.Count)
    detection(frame) = i; 
    if i == 4
        fprintf(strcat("Stim: ",num2str(i),"/",num2str(4),"\n"))
        fprintf(strcat("Trial: ",num2str(trials),"/",num2str(18),"\n"))
        trials = trials+1;
        i = 1; 
        continue
    end
    fprintf(strcat("Stim: ",num2str(i),"/",num2str(4),"\n"))
    if i == 1
        frame = frame+10;
    elseif i == 2
        frame = frame+100;
    else
        frame = frame+130;
    end 
    i = i+1;    
end
end
fprintf(strcat("All stimulus detected succesfully\n"))
locs_cell = cell(1,4);
for i = 1:4
locs = find(detection==i);
locs_cell{i} = locs;
end 
end