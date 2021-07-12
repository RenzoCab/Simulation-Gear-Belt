close all;
clear all;
clc;

pulley       = 'triangle';
model_3D     = 'circle';
num_iter     = 10;
substitution = false;

close_loop(pulley, model_3D, num_iter, substitution);
