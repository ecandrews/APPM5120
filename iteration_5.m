%{

Define activities for fifth iteration.

%}

clc;

% Define a cell array of activities. Each activity has a duration, a 
% list of zero or more activities that it must occur before, and a list of
% zero or more activities that it cannot overlap with.
% Example: {6, {7, 5, 2}, {3}} <-- This activity has a duration of 6 hours,
% must be scheduled before activities 7, 5, and 2 are scheduled, and can't
% overlap with activity 3.

activities = {{1, [2], []}, 
             {3, [3], []}, 
             {5, [7], []}, 
             {2, [], []}, 
             {6, [8], []},
             {1.5, [1], []},
             {4, [], []},
             {5, [], []},
             {2.5, [], []},
             {3, [9], []},
             {6, [12], []},
             {4, [13], []},
             {7, [], []},
             {3, [], []},
             {2, [], []},
             {7, [19], []},
             {6, [4], []},
             {6, [5], []},
             {4, [6], []},
             {7, [], []}};

% Save .mat file for easy usage later
save('iteration_5.mat');