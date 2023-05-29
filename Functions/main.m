
file_ID     = "..\MATLAB\Eyetracker_Data-main\Data\User 0_all_gaze.csv"; 
file_tsv    = "..\MATLAB\Eyetracker_Data-main\Data\prueba etiquetas f - Copy_February 20, 2023_13.50.tsv.xlsx"; 
file_video  = '..\MATLAB\Eyetracker_Data-main\Data\video_export_02-20-23-15.47.39.avi';
load('..\MATLAB\Eyetracker_Data-main\Data\ROI.mat')
load('..\MATLAB\Eyetracker_Data-main\Data\Vid_frame.mat')
[T2] = analize_video(file_ID,file_tsv,file_video,vidFrame,roi,0);