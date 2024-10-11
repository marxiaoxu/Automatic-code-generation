% IIR_STARTUP.M file for IIR_Filter model

% Read in data from file testdata.txt as input to the model
fid = fopen('testdata.txt','rt');
testdata = cell2mat(textscan(fid, '%f\n','headerlines',3));
fclose(fid);
clear fid;

% Parameter values for gain b0 and gain a1
a1 = 0.9;
b0 = 0.1;

% Create time vector for input values
t = linspace(0,1,1001)';

clear ans;
% [EOF]: iir_startup.m
