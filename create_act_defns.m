%{

Setup and create activities and constraints to be used in both the
mixed-integer programming brach-and-bound implementation, and the iterative
conflict repair implementation. Faster to create and import a .mat file
than to hard code this into both scripts separately.

Activity 1:
    Duration - 1 hour
    Must occur before Activity 2
Activity 2:
    Duration - 3 hours
    Must occur before Activity 4
Activity 3:
    Duration - 5 hours
    Must occur before Activity 4
Activity 4: 
    Duration - 2 hours
    No precedence constraint
Activity 5:
    Duration - 6 hours
    Must occur before Activity 1

%}

clc;

% Define activity durations in units of hours
activity_durations = [1; 3; 5; 2; 6];

% Define precedence constraints (P⊆{(i, j) | i,j∈T, i must occur before j})
% Matrix is mxn
% For index_mn:
%    - 0: Activity m has no constraint with Activity n
%    - 1: Activity m must complete before Activity n starts
precedence_constraints = [0, 1, 0, 0, 0;
                          0, 0, 0, 1, 0;
                          0, 0, 0, 1, 0;
                          0, 0, 0, 0, 0;
                          1, 0, 0, 0, 0];

% Define initial start times for activities
activity_start_times = [0; 0; 0; 0; 0];

save('activity_defns.mat');