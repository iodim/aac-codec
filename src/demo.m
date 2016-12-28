clc; clear; close all;

addpath('./Level 1/');
addpath('./Level 2/');
addpath('./Level 3/');

% demoAAC1('LicorDeCalandraca.wav', 'LicorDeCalandraca_L1.wav')
% demoAAC2('LicorDeCalandraca.wav', 'LicorDeCalandraca_L2.wav')
demoAAC3('LicorDeCalandraca.wav', 'LicorDeCalandraca_L3.wav')

%[y, fs] = audioread('LicorDeCalandraca_2.wav');
%player = audioplayer(y, fs);
% player.play();

