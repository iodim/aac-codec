clc; clear; close all;

addpath('./Level 1/');
addpath('./Level 2/');
addpath('./Level 3/');

demoAAC1('LicorDeCalandraca.wav', 'LicorDeCalandraca_L1.wav');

disp(' ');
demoAAC2('LicorDeCalandraca.wav', 'LicorDeCalandraca_L2.wav');

disp(' ');
demoAAC3('LicorDeCalandraca.wav', 'LicorDeCalandraca_L3.wav', 'L3.mat');
