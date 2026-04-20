%{

Setup and create the activities that will be scheduled using the
branch-and-bound algorithm.

%}

clc;

% Load in the activity file for the given iteration
load('iteration_1.mat');
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

% TODO: keeping ALL activity pairs without a precedence constraint from
% overlapping means that there will never be any actual makespan to
% minimize because it will always be the same length, you big dummy. But I
% want to keep some of the "don't overlap" implementation because it was
% hard to implement. So maybe update some of the activities to be able to
% overlap 

% Get all (unordered) pairs of activities that do not have a precedence
% constraint with each other.
% First adjust the precedence constraints matrix to have 1s on the
% diagonals, because we don't need an unordered pair of an activity with
% itself.
%intermediate_unordered_pairs = precedence_constraints;
%intermediate_unordered_pairs(1:size(intermediate_unordered_pairs,1) + 1:end) = 1;
%for i = 1:length(activities)
%    for j = 1:length(activities)
%        % Then since a precedence exists between two activities regardless
%        % of order, any entry (i,j) should have a corresponding (j,i)
%        if intermediate_unordered_pairs(i,j) == 1
%            intermediate_unordered_pairs(j,i) = 1;
%        end
%    end
%end
% Swap the 0s and the 1s to get the "opposite" of the precedence
% constraints
%unordered_pairs = ~intermediate_unordered_pairs - diag(diag(~intermediate_unordered_pairs));
%for i = 1:length(activities)
%    for j = 1:length(activities)
%        % No need to have duplicate pairs since they are unordered, so any
%        % entry (i,j) can have its corresponding (j,i) entry zeroed out
%        if unordered_pairs(i,j) == 1
%            unordered_pairs(j,i) = 0;
%        end
%    end
%end

% Get the number of unordered pairs that will be used as the binary
% decision variables, and number of precedence constraints
num_decision_vars = sum(unordered_pairs(:) == 1)
num_precedence_constraints = sum(precedence_constraints(:) == 1)

% Save activity definitions and info to mat file
save('activity_defns.mat');