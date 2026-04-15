clc;
format long;

% Don't change this, this is the A from the primal problem
A = [-1 3 1 0; 3 2 0 1];

% Setup e and other values
e = [1; 1; 1; 1;];
%mu = 2.5; % replace this
%mu = 1.25;
%mu = 0.625;
mu = 0.3125;
rho = 0.5;

% Replace these each iteration with the new values
%s = [7; 7; 1; 3];
%x = [1; 1; 4; 10];
%y = [-1; -3];
%s = [0.25204; 1.30247; 0.67303; 0.64169];
%x = [1.32116; 1.17109; 3.80788; 8.69463];
%y = [-0.67303; -0.64169];
%s = [0.59479; 0.34176; 0.34870; 0.64783];
%x = [3.16286; 1.82352; 3.69227; 1.86478];
%y = [-0.34870; -0.64783];
s = [0.24324; 0.21908; 0.37916; 0.54080];
x = [2.92019; 2.48334; 1.46985; 1.27285];
y = [-0.37916; -0.54080];

% Calculate matrices
S = diag(s)
X = diag(x)
D = round(inv(S)*X, 5)
v = round(mu * e - X * S * e, 5)

% Calculate deltas
delta_y = round(-inv(A*D*A.') * A * inv(S) * v, 5)
delta_s = round(-A.' * delta_y, 5)
delta_x = round(inv(S) * v - (D * delta_s), 5)

% Calculate new values
new_x = round(x + delta_x, 5)
new_s = round(s + delta_s, 5)
new_y = round(y + delta_y, 5)

% Calculate new mu
new_mu = mu * rho