%{

Mixed-Integer Programming implementation using Branch-and-Bound to solve.

%}

clc;
format long;

% Load in the defined activities and constraints
% Wait, actually I don't think I need to do this if I'm defining it below
load('activity_defns.mat');

% Define coefficients of objective function vector and integer variable
% indices
f = [1; 2; 3];
intcon = 3;

% Define inequality constraints (<=)
Ain = [1, 1, 1];
bin = 6;

% Define equality constraints
Aeq = [1, 0, 0];
beq = 2;

% Define lower and upper bounds. Lower bounds are 0 for all variables and
% upper bounds are x1, x2 >= 0 and x3 is a binary variable.
lb = zeros(3, 1);
ub = [Inf; Inf; 1];

% Call solver function
options = optimoptions('intlinprog','Display','iter','PlotFcn','optimplotmilp');
[soln_vec, obj_val, exitflag, output] = intlinprog(f, intcon, Ain, bin, Aeq, beq, lb, ub);

% Display results in some sort of graphical format to use in report?
% Shouldn't the plotfcn do that for me?