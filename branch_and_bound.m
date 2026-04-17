%{

Mixed-Integer Programming implementation using Branch-and-Bound to solve.

%}

clc;
format long;

% Load in the defined activities, durations, and precedence relationships
load('activity_defns.mat');

% Define big M value
M = 1e4;

% TODO: rewrite all of this to be generic instead of hard-coded, using the
% new stuff defined in the activity_defns.mat

% At the end of the day, the "schedule" that we want out is a list of start
% times for each of the activities. In order for the MIP solver to know
% about these variables, we need to pass them in. But, our objective
% function to minimize is only makespan (C). So we pass in zeroes for all
% start times originally, and the solver will have the info it needs to
% perform the optimization.
% Populate the objective function coefficients based on the number of
% activities and the number of unordered pairs.
f = [zeros(1, num_acts), 1, zeros(1, num_decision_vars)];

% Delineate indices of integer variables
decision_var_index = num_acts + 2;
intcon = decision_var_index:(decision_var_index + num_decision_vars - 1);

% Define inequality constraints. intlinprog expects constraints in the form
% of "<=".   
% Define A_inequal and b_inequal
num_A_b_rows = num_acts + num_precedence_constraints + 2*(num_decision_vars);
A_inequal = zeros(num_A_b_rows, length(f));
b_inequal = zeros(num_A_b_rows, 1);

% Add rows corresponding to constraint:
% C >= start_time + duration for all activities
% Convert to expected form:
% start_time - C <= -duration
decision_var_zeros = zeros(1, num_decision_vars);
row_index = 1;
for i=1:num_acts
    new_row = zeros(1, num_acts + 1);
    new_row(i) = 1;
    new_row(num_acts + 1) = -1;
    A_inequal(row_index,:) = [new_row, decision_var_zeros];
    b_inequal(row_index) = (-1) * activity_durations(i);
    row_index = row_index + 1;
end

% Add rows corresponding to constraint:
% start_j >= start_i + duration_i when activity_i must occur before activity_j
% Convert to expected form:
% -start_j + start_i <= -duration_i
decision_var_and_makespan_zeros = zeros(1, num_decision_vars + 1);
[row, col] = find(precedence_constraints);
for i=1:length(row)
    activity_i = row(i);
    activity_j = col(i);
    new_row = zeros(1, num_acts);
    new_row(activity_j) = -1;
    new_row(activity_i) = 1;
    A_inequal(row_index,:) = [new_row, decision_var_and_makespan_zeros];
    b_inequal(row_index) = (-1) * activity_durations(activity_i);
    row_index = row_index + 1;
end

% Add rows corresponding to constraints:
% start_j >= start_i + duration_i - M(1 - y_ij) for unordered pairs
% start_i >= start_j + duration_j - M(y_ij) for unordered pairs
% Convert to expected form:
% -start_j + start_i + M*y_ij <= -duration_i + M
% -start_i + start_j - M*y_ij <= -duration_j
[row, col] = find(unordered_pairs);
for i=1:length(row)
    activity_i = row(i);
    activity_j = col(i);
    % Constraint 1
    new_row1 = zeros(1, num_acts + 1);
    new_row1(activity_j) = -1;
    new_row1(activity_i) = 1;
    decision_vars1 = zeros(1, num_decision_vars);
    decision_vars1(i) = M;
    A_inequal(row_index,:) = [new_row1, decision_vars1];
    b_inequal(row_index) = ((-1)*activity_durations(activity_i)) + M;
    row_index = row_index + 1;
    % Constraint 2
    new_row2 = zeros(1, num_acts + 1);
    new_row2(activity_i) = -1;
    new_row2(activity_j) = 1;
    decision_vars2 = zeros(1, num_decision_vars);
    decision_vars2(i) = -M;
    A_inequal(row_index,:) = [new_row2, decision_vars2];
    b_inequal(row_index) = (-1)*activity_durations(activity_j);
    row_index = row_index + 1;
end

% Define lower and upper bounds for solution vector. All start times and
% the makespan must be greater than or equal to zero, so lowerbound is
% initialized to all zeroes. No upperbound.
lb = zeros(length(f), 1);
ub = inf(length(f), 1);
ub(intcon) = 1;

% Call solver function
options = optimoptions('intlinprog','Display','iter','PlotFcn','optimplotmilp');
[soln_vec, obj_val, exitflag, output] = intlinprog(f, intcon, A_inequal, b_inequal, [], [], lb, ub);
 
% Display schedule results in graphical form
act_start_times = soln_vec(1:num_acts);
act_finish_times = act_start_times + activity_durations;
activity_times = [act_start_times, act_finish_times];

figure;
hold on;
grid on;

% Loop through all activity start and end times and plot
for i = 1:length(act_start_times)
    plot(activity_times(i,:), [i, i], 'LineWidth', 6);
end
 
% Set limits
xlim([0, max(act_finish_times) + 1]);
ylim([0, n+1]);
 
% Set labels and plot title
yticks(1:n);
yticklabels({'Activity 1','Activity 2','Activity 3','Activity 4','Activity 5'});
xlabel('Time (hours)');
ylabel('Scheduled Activities');
title('Timeline');