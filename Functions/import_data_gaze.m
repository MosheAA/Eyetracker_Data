
function [allgaze1] = import_data_gaze(file_id)
%% Set up the Import Options and import the data
var_names = ["TIME_2022_11_2210_40_35_981_","FPOGX","FPOGY","CX","CY","CS"];
opts = detectImportOptions(file_id);
opts = setvartype(opts,var_names,'double');
opts.SelectedVariableNames = var_names;
%opts.Delimiter = {'.'};
% Import the data
allgaze1 = readtable(file_id,opts);

%% Convert to output type
allgaze1 = table2array(allgaze1);

%% Convert invalid data into nan
allgaze1(allgaze1(:,2)<=0 | allgaze1(:,2)>1,:) = nan;
allgaze1(allgaze1(:,3)<=0 | allgaze1(:,3)>1,:) = nan;
