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
% TODO: populate this in a loop or something so it can scale better
f = [activity_start_times(1, 1)... % Activity 1 start coefficient
    activity_start_times(2,1)... % Activity 2 start coefficient
    activity_start_times(3,1)... % Activity 3 start coefficient
    activity_start_times(4,1)... % Activity 4 start coefficient
    activity_start_times(5,1)... % Activity 5 start coefficient
    1 ... % makespan coefficient
    0 ... % y_1_3 decision var
    0 ... % y_1_4 decision var
    0 ... % y_2_3 decision var
    0 ... % y_2_5 decision var
    0 ... % y_3_5 decision var
    0]; % y_5_4 decision var

% Delineate indices of integer variables
intcon = [7 8 9 10 11 12];

% Define inequality constraints. intlinprog expects constraints in the form
% of "<=".
% Constraints:
%    C >= start_time + duration for all activities
%         (becomes start_time - C <= -duration)
%    start_j >= start_i + duration_i for precedence relationship where
%    activity_i must occur before activity_j
%         (becomes -start_j + start_i <= -duration_i
%    start_j >= start_i + duration_i - M(1 - y_ij) for pairs of activities
%    with no precedence relationship
%         (becomes -start_j + start_i + M*y_ij <= -duration_i + M)
%    start_i >= start_j + duration_j - M(y_ij) for pairs of activities with
%    no precedence relationship
%         (becomes -start_i + start_j - M*y_ij <= -duration_j)
%    
% TODO: I'm just going to hardcode everything for now just
% to get it written down, and later I'll actually use the
% precedence_constraints matrix
A_inequal = [1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0; % start_time1 - C
             0, 1, 0, 0, 0, -1, 0, 0, 0, 0, 0, 0; % start_time2 - C
             0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0; % start_time3 - C
             0, 0, 0, 1, 0, -1, 0, 0, 0, 0, 0, 0; % start_time4 - C
             0, 0, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0; % start_time5 - C
             1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0; % -start_time2 + start_time1
             0, 1, 0, -1, 0, 0, 0, 0, 0, 0, 0, 0; % -start_time4 + start_time2
             0, 0, 1, -1, 0, 0, 0, 0, 0, 0, 0, 0; % -start_time4 + start_time3
             -1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0; % -start_time1 + start_time5
             1, 0, -1, 0, 0, 0, M, 0, 0, 0, 0, 0; % -start_3 + start_1 + M*y_1_3
             -1, 0, 1, 0, 0, 0, -M, 0, 0, 0, 0, 0; % -start_1 + start_3 - M*y_1_3
             1, 0, 0, -1, 0, 0, 0, M, 0, 0, 0, 0; % -start_4 + start_1 + M*y_1_4
             -1, 0, 0, 1, 0, 0, 0, -M, 0, 0, 0, 0; % -start_1 + start_4 - M*y_1_4
             0, 1, -1, 0, 0, 0, 0, 0, M, 0, 0, 0; % -start_3 + start_2 + M*y_2_3
             0, -1, 1, 0, 0, 0, 0, 0, -M, 0, 0, 0; % -start_2 + start_3 - M*y_2_3
             0, 1, 0, 0, -1, 0, 0, 0, 0, M, 0, 0; % -start_5 + start_2 + M*y_2_5
             0, -1, 0, 0, 1, 0, 0, 0, 0, -M, 0, 0; % -start_2 + start_5 - M*y_2_5
             0, 0, 1, 0, -1, 0, 0, 0, 0, 0, M, 0; % -start_5 + start_3 + M*y_3_5
             0, 0, -1, 0, 1, 0, 0, 0, 0, 0, -M, 0; % -start_3 + start_5 - M*y_3_5
             0, 0, 0, -1, 1, 0, 0, 0, 0, 0, 0, M; % -start_4 + start_5 + M*y_5_4
             0, 0, 0, 1, -1, 0, 0, 0, 0, 0, 0, -M]; % -start_5 + start_4 - M*y_5_4

b_inequal = [-1 * activity_durations(1,1); % -duration1
             -1 * activity_durations(2,1); % -duration2
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(4,1); % -duration4
             -1 * activity_durations(5,1); % -duration5
             -1 * activity_durations(1,1); % -duration1
             -1 * activity_durations(2,1); % -duration2
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(5,1); % -duration5
             -1 * activity_durations(1,1) + M; % -duration1 + M
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(1,1) + M; % -duration1 + M
             -1 * activity_durations(4,1); % -duration4
             -1 * activity_durations(2,1) + M; % -duration2 + M
             -1 * activity_durations(3,1); % -duration3
             -1 * activity_durations(2,1) + M; % -duration2 + M
             -1 * activity_durations(5,1); % -duration5
             -1 * activity_durations(3,1) + M; % -duration3 + M
             -1 * activity_durations(5,1); % -duration5
             -1 * activity_durations(5,1) + M; % -duration5 + M
             -1 * activity_durations(4,1)]; % -duration4

% Define lower and upper bounds for solution vector. All start times and
% the makespan must be greater than or equal to zero, so lowerbound is
% initialized to all zeroes. No upperbound.
% TODO: update lb with correct number of variables, and ub
lb = zeros(size(f,2), 1);
ub = inf(size(f,2), 1);
ub(7:12) = 1;

% Call solver function
options = optimoptions('intlinprog','Display','iter','PlotFcn','optimplotmilp');
[soln_vec, obj_val, exitflag, output] = intlinprog(f, intcon, A_inequal, b_inequal, [], [], lb, ub);

% Display schedule results in graphical form
