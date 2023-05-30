function [locs] = detect_fix_cross(sample, vidObj)

start_trial_cross = zeros(1,vidObj.NumFrames);

% Fixation cross
sample1 = imresize(sample,1/2);
sample2 = sample1(161:252,405:533,:); 
imshow(sample2)
boxPoints = detectSURFFeatures(sample2);
[boxFeatures, ~] = extractFeatures(sample2, boxPoints);

for frame = 1:5:vidObj.NumFrames 
% Current Frame:
vidObj.CurrentTime = frame/ vidObj.FrameRate;
vidFrame = imresize(readFrame(vidObj),1/2);
C = rgb2gray(vidFrame(161:252,405:533,:));
scenePoints = detectSURFFeatures(C);
% Matching Current Frame w/ sample : 
[sceneFeatures, scenePoints] = extractFeatures(C, scenePoints);
boxPairs = matchFeatures(boxFeatures, sceneFeatures);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);

if any(matchedScenePoints.Count)
    start_trial_cross(frame) = 1; 
end
fprintf(strcat("frame: ",num2str(frame),"/",num2str(vidObj.NumFrames),"\n"))
end 
[~,locs] = findpeaks(start_trial_cross,"MinPeakDistance",40);

end