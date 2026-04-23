%{

Define activities for fourth iteration.

%}

clc;

% Define a cell array of activities. Each activity has a duration, a 
% list of zero or more activities that it must occur before, and a list of
% zero or more activities that it cannot overlap with.
% Example: {6, {7, 5, 2}, {3}} <-- This activity has a duration of 6 hours,
% must be scheduled before activities 7, 5, and 2 are scheduled, and can't
% overlap with activity 3.

activities = {{1, [], []}, 
             {3, [], []}, 
             {5, [], []}, 
             {2, [], []}, 
             {6, [], []},
             {1.5, [], []},
             {4, [], []},
             {5, [], []},
             {2.5, [], []},
             {3, [], []}};

% Save .mat file for easy usage later
save('iteration_4.mat');