%%
for i = 1:30
file_ID     = "..\MATLAB\Eyetracker_Data-main\Data\6_all_gaze.csv"; 
file_tsv    = "..\MATLAB\Eyetracker_Data-main\Data\prueba etiquetas ensayos_29 de mayo de 2023_10.41.tsv"; 
file_video  = '..\MATLAB\Eyetracker_Data-main\Data\6.avi';
load('..\MATLAB\Eyetracker_Data-main\Data\ROI.mat')
load('..\MATLAB\Eyetracker_Data-main\Data\Vid_frame.mat')
[T2] = analize_video(file_ID,file_tsv,file_video,vidFrame,roi,0);
[Tfinal] = createtable();

Tfinal = [Tfinal;T2];
%%
vidObj = VideoReader(file_video);
vidObj.CurrentTime = 63;    % Moment in which cross was detected
vidFrame = readFrame(vidObj);
sample = rgb2gray(vidFrame);
imshow(sample)