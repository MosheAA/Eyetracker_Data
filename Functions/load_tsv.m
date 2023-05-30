function [stimulus] = load_tsv(file_ID,ID)
[~,~,a]=xlsread(file_ID);

pos = find(cell2mat(a(4:end,18))==ID);
stimulus = strsplit(a{pos+4,342},'|');