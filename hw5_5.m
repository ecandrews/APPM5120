clc;
format long;

% Stays the same every iteration
Q = [3 1 1; 2 5 1; 2 4 6];
alpha = 0.25;
c = [4; -1; 10];

%%% ITERATION 1 %%%

% Set up for iteration
x0 = [0; 0; 0];
D0 = [1 0 0; 0 1 0; 0 0 1];
gradient0 = Q * x0 - c;

% Perform iteration
x1 = x0 - alpha * D0 * gradient0;
gradient1 = Q * x1 - c;
fx1 = 1/2 * x1.' * Q * x1 - c.' * x1;

% Calculate p and q
p0 = x1 - x0;
q0 = gradient1 - gradient0;
t0 = q0.' * D0 * q0;
v0 = round((p0/(p0.' * q0) - (D0*q0)/t0), 5);
D1 = round((D0 + (p0*p0.')/(p0.'*q0) - (D0*(q0*q0.')*D0)/(q0.'*D0*q0) + (t0*(v0*v0.'))),5);
D1inv = round(inv(D1), 5);

%%% ITERATION 2 %%%

% Perform iteration
x2 = round(x1 - alpha * D1 * gradient1, 5);
gradient2 = round(Q * x2 - c, 5);
fx2 = round((1/2 * x2.' * Q * x2 - c.' * x2), 5);

% Calculate p and q
p1 = round(x2 - x1, 5);
q1 = round(gradient2 - gradient1, 5);
t1 = round(q1.' * D1 * q1, 5);
v1 = round((p1/(p1.' * q1) - (D1*q1)/t1), 5);
D2 = round((D1 + (p1*p1.')/(p1.'*q1) - (D1*(q1*q1.')*D1)/(q1.'*D1*q1) + (t1*(v1*v1.'))),5);
D2inv = round(inv(D2), 5);

%%% ITERATION 3 %%%

% Perform iteration
x3 = round(x2 - alpha * D2 * gradient2, 5)
gradient3 = round(Q * x3 - c, 5)
fx3 = round((1/2 * x3.' * Q * x3 - c.' * x3), 5)

% Calculate p and q
p2 = round(x3 - x2, 5)
q2 = round(gradient3 - gradient2, 5)
t2 = round(q2.' * D2 * q2, 5)
v2 = round((p2/(p2.' * q2) - (D2*q2)/t2), 5)
D3 = round((D2 + (p2*p2.')/(p2.'*q2) - (D2*(q2*q2.')*D2)/(q2.'*D2*q2) + (t2*(v2*v2.'))),5)
D3inv = round(inv(D3), 5)