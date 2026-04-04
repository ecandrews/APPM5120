%{

Setup and create activities and constraints to be used in both the
mixed-integer programming brach-and-bound implementation, and the iterative
conflict repair implementation. Faster to create and import a .mat file
than to hard code this into both scripts separately.

%}

clc;

test_x=3;
test_y=4;
test_z="hello world!";

save('activity_defns.mat')