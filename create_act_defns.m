%{

Setup and create the activities that will be scheduled using the
branch-and-bound algorithm.

%}

clc;

% Load in the activity file for the given iteration
load('iteration_3.mat');
num_acts = numel(activities)

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

% Get the unordered pairs of activities that cannot overlap with each other
unordered_pairs = zeros(num_acts, num_acts);
for i = 1:length(activities)
    act = activities{i};
    for j = 1:length(act{3})
        unordered_pairs(i,act{3}) = 1;
    end
end

% Get the number of unordered pairs that will be used as the binary
% decision variables, and number of precedence constraints
num_decision_vars = sum(unordered_pairs(:) == 1)
num_precedence_constraints = sum(precedence_constraints(:) == 1)

% Save activity definitions and info to mat file
save('activity_defns.mat');