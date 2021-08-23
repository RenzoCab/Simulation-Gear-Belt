% Author: Renzo Caballero
% KAUST: King Abdullah University of Science and Technology
% email: renzo.caballerorosas@kaust.edu.sa caballerorenzo@hotmail.com
% Website: renzocaballero.org, https://github.com/RenzoCab
% August 2021; Last revision: 23/08/2021

close all;
clear all;
clc;

pulley       = 'triangle';
model_3D     = 'circle';
num_iter     = 10;
substitution = false;

close_loop(pulley, model_3D, num_iter, substitution);
