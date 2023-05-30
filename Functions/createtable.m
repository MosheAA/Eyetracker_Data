function [t3] = createtable()

stim = ["FL_26",	"FL_16",	"FL_15",	"FL_23",	"FL_25",	"FL_12",	"FL_13",	"FL_20",	"FL_19",...
        "FL_18",	"FL_27",	"FL_22",	"FL_21",	"FL_24",	"FL_11",	"FL_10",	"FL_14",	"FL_17"]; 
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
% 
sz = [0 length(varNames)];
t3 = table('Size',sz,'VariableTypes',varTypes,'VariableNames',varNames);
end 