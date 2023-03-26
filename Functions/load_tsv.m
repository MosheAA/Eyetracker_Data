function [stimulus] = load_tsv(file_ID)

opts = detectImportOptions(file_ID,'Range',"MH21:MH22");
T = readtable(file_ID,opts);
stimulus = strsplit(T{1,1}{1},'|');