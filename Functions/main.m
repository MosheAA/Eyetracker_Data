%%
Tfinal = createtable(); % Crea una tabla vacía

for ID = 1:3
[file_ID,file_tsv,file_video] = create_file_name(ID);
load('..\MATLAB\Eyetracker_Data-main\Data\ROI.mat')
load('..\MATLAB\Eyetracker_Data-main\Data\Vid_frame1.mat')
% load('C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\ROI.mat')
% load('C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\Vid_frame1.mat')
[T2] = analize_video(file_ID,file_tsv,file_video,vidFrame,roi,0,ID);
Tfinal = [Tfinal;T2];
writetable(Tfinal,'Results.csv','Delimiter',';');
end 

%%
% %%
% file_ID     = "C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\6_all_gaze.csv"; 
% file_tsv    = "C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\prueba etiquetas ensayos_29 de mayo de 2023_10.41.tsv"; 
% file_video  = 'C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\6.avi';
% load('C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\ROI.mat')
% load('C:\Users\naba_\OneDrive\Documentos\grupos de investigacion\mensajes eye tracker\matlab\3\Eyetracker_Data-main\Data\Vid_frame1.mat')
% vidObj = VideoReader(file_video);
% vidObj.CurrentTime = 63;    % Moment in which cross was detected
% vidFrame = readFrame(vidObj);
% sample = rgb2gray(vidFrame);
% imshow(sample)
