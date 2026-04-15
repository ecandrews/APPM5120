%{

Setup and create the activities that will be scheduled using the
branch-and-bound algorithm.

%}

clc;

% Define a cell array of activities. Each activity has a duration and a 
% list of zero or more activities that it must occur before.
% Example: {6, {7, 5, 2}} <-- This activity has a duration of 6 hours, and
% must be scheduled before activities 7, 5, and 2 are scheduled.
activities = {{1, [2]}, 
             {3, [4]}, 
             {5, [4]}, 
             {2, []}, 
             {6, [1]}};
num_acts = numel(activities);

% Pull out all activity durations
activity_durations = cellfun(@(c) c{1}, activities);

% Define precedence constraints (P⊆{(i, j) | i,j∈T, i must occur before j})
% Matrix is mxn
% For index_mn:
%    - 0: Activity m has no constraint with Activity n
%    - 1: Activity m must complete before Activity n starts
precedence_constraints = zeros(num_acts, num_acts);
for i = 1:length(activities)
    act = activities{i};
    if ~isempty(act{2})
        precedence_constraints(i,act{2}) = 1;
    end
end

% TODO: this is so gross, there has got to be a more matlab-y way to do
% this
% TODO: add description of what this garbage is doing, also better var
% names
intermediate_unordered_pairs = precedence_constraints;
intermediate_unordered_pairs(1:size(intermediate_unordered_pairs,1) + 1:end) = 1;
for i = 1:length(activities)
    for j = 1:length(activities)
        if intermediate_unordered_pairs(i,j) == 1
            intermediate_unordered_pairs(j,i) = 1;
        end
    end
end
unordered_pairs = ~intermediate_unordered_pairs - diag(diag(~intermediate_unordered_pairs));
for i = 1:length(activities)
    for j = 1:length(activities)
        if unordered_pairs(i,j) == 1
            unordered_pairs(j,i) = 0;
        end
    end
end

% Save activity definitions and info to mat file
save('activity_defns.mat');