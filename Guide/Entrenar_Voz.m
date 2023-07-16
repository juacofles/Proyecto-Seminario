clear;clc;

load Voz1.mat
load Voz2.mat
load Voz3.mat
load Voz4.mat

INPUT=[MFs1 MFs2 MFs3 MFs4];
OUTPUT=[Cat1 Cat2 Cat3 Cat4];
% Jugar con las neuronas
RedVoz=patternnet(80);

RedVoz=train(RedVoz,INPUT,OUTPUT);

save RedAudio.mat RedVoz