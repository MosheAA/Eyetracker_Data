function [allgaze1] = import_data_gaze(file_id)
%% Set up the Import Options and import the data
opts = detectImportOptions(file_id);
var_names = {opts.SelectedVariableNames{1, 4},...
                     opts.SelectedVariableNames{1, 6},...
                     opts.SelectedVariableNames{1, 7},...
                     opts.SelectedVariableNames{1, 15},...
                     opts.SelectedVariableNames{1, 16},...
                     opts.SelectedVariableNames{1, 17}};

opts = setvartype(opts,var_names,'double');
opts.SelectedVariableNames = var_names;
% Import the data
allgaze1 = readtable(file_id,opts);

%% Convert to output type
allgaze1 =allgaze1{:,1:6};

%% Convert invalid data into nan
allgaze1(allgaze1(:,2)<=0 | allgaze1(:,2)>1,:) = nan;
allgaze1(allgaze1(:,3)<=0 | allgaze1(:,3)>1,:) = nan;
