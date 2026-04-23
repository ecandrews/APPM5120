%{

Define activities for third iteration.

%}

clc;

% Define a cell array of activities. Each activity has a duration, a 
% list of zero or more activities that it must occur before, and a list of
% zero or more activities that it cannot overlap with.
% Example: {6, {7, 5, 2}, {3}} <-- This activity has a duration of 6 hours,
% must be scheduled before activities 7, 5, and 2 are scheduled, and can't
% overlap with activity 3.

% TODO: make this into 30 activities
activities = {{4, [], [2,3,4,5,6]}, 
             {4.1, [], [1,3,4,5,6]}, 
             {3.9, [], [1,2,4,5,6]}, 
             {3.8, [], [1,2,3,5,6]}, 
             {3.7, [], [1,2,3,4,6]},
             {4.2, [], [1,2,3,4,5]},
             {4.9, [], []},
             {4.9, [7], []},
             {1.4, [8], []},
             {3.3, [9], []},
             {5.3, [10], []},
             {2, [13], []},
             {4.9, [14], []},
             {1, [15], []},
             {2.9, [16], []},
             {2.8, [17], []},
             {1.1, [18], []},
             {4.7, [19], []},
             {4.1, [20], []},
             {1.3, [], []},
             {4.5, [3], [22,8]},
             {2.4, [5], [21,10]},
             {1.3, [2], [24,12]},
             {0.7, [6], [23]},
             {1.5, [], [26]},
             {2.8, [], [25]},
             {2.3, [], [28,26]},
             {1.7, [], [27]},
             {1, [], []},
             {0.6, [], [28,29]}};

% Save .mat file for easy usage later
save('iteration_3.mat');