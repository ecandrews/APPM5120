%{

Mixed-Integer Programming implementation using Branch-and-Bound to solve.

%}

clc;
format long;

% Load in the defined activities, durations, and precedence relationships
load('activity_defns.mat');

% At the end of the day, the "schedule" that we want out is a list of start
% times for each of the activities. In order for the MIP solver to know
% about these variables, we need to pass them in. But, our objective
% function to minimize is only makespan (C). So we pass in zeroes for all
% start times originally, and the solver will have the info it needs to
% perform the optimization.
% TODO: populate this in a loop or something so it can scale better?
f = [activity_start_times(1, 1)... % Activity 1 start coefficient
    activity_start_times(2,1)... % Activity 2 start coefficient
    activity_start_times(3,1)... % Activity 3 start coefficient
    activity_start_times(4,1)... % Activity 4 start coefficient
    activity_start_times(5,1)... % Activity 5 start coefficient
    1]; % makespan coefficient
intcon = size(f);

% Define inequality constraints. intlinprog expects constraints in the form
% of "<=".
% Constraints:
%    C >= start_time + duration for all activities
%         (becomes start_time - C <= -duration)
%    start_j >= start_i + duration_i for precedence relationship where
%    activity_i must occur before activity_j
%         (becomes -start_j + start_i <= -duration_i
% TODO: I'm just going to hardcode the precedence constraints for now just
% to get it written down, and later I'll actually use the
% precedence_constraints matrix
A_inequal = [1, 0, 0, 0, 0, -1; % start_time1 - C
             0, 1, 0, 0, 0, -1; % start_time2 - C
             0, 0, 1, 0, 0, -1; % start_time3 - C
             0, 0, 0, 1, 0, -1; % start_time4 - C
             0, 0, 0, 0, 1, -1; % start_time5 - C
             1, -1, 0, 0, 0, 0; % -start_time2 + start_time1
             0, 1, 0, -1, 0, 0; % -start_time4 + start_time2
             0, 0, 1, -1, 0, 0; % -start_time4 + start_time3
             -1, 0, 0, 0, 1, 0]; % -start_time1 + start_time5
b_inequal = [-1 * activity_durations(1,1); % -duration1
             -1 * activity_durations(2,1); % -duration2
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(4,1); % -duration4
             -1 * activity_durations(5,1); % -duration5
             -1 * activity_durations(1,1); % -duration1
             -1 * activity_durations(2,1); % -duration2
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(5,1)]; % -duration5

% Define lower and upper bounds for solution vector. All start times and
% the makespan must be greater than or equal to zero, so lowerbound is
% initialized to all zeroes. No upperbound.
lb = zeros(6, 1);
ub = [Inf; Inf; Inf; Inf; Inf; Inf];

% Call solver function
options = optimoptions('intlinprog','Display','iter','PlotFcn','optimplotmilp');
[soln_vec, obj_val, exitflag, output] = intlinprog(f, intcon, A_inequal, b_inequal, [], [], lb, ub);

% Display results in some sort of graphical format to use in report?
% Shouldn't the plotfcn do that for me?