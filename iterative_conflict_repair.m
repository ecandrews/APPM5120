%{

Interative Conflict Repair implmentation.

%}

clc;
format long;

% Load in the defined activities and constraints
load('activity_defns.mat');

% The paper about ASPEN is one that kind of details this in more detail

% Generate random start times for all of the activities to get an initial
% "incorrect" schedule, or force a schedule that has one single overlap to
% start.

% Only going to use one type of conflict, an overlap.
% Find the conflict and pick (I guess one?) of the activities to move.
% Determine how much overlap is currently happening.
% Since this is the first overlap, we know that everything before it is ok.
% Move activity to a new spot, and move any dependent activities as well.
% Recheck for conflicts.
% Repeat until no conflicts found.

% (Caveat that I've finagled this setup in such a way that there is a
% possible way for all acts to be scheduled without overlap)