clc; clear; close all;

demoAAC1('LicorDeCalandraca.wav', 'LicorDeCalandraca_2.wav')
[y, fs] = audioread('LicorDeCalandraca_2.wav');
player = audioplayer(y, fs);
% player.play();
