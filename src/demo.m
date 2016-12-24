clc; clear; close all;

addpath('./Level 1/')
addpath('./Level 2/')

demoAAC1('LicorDeCalandraca.wav', 'LicorDeCalandraca_2.wav')
demoAAC2('LicorDeCalandraca.wav', 'LicorDeCalandraca_2.wav')

%[y, fs] = audioread('LicorDeCalandraca_2.wav');
%player = audioplayer(y, fs);
% player.play();

