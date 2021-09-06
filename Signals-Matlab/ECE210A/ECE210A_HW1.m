% Husam Almanakly | ECE210-A Homework 1 
% 

clear all 
clc
close all 

%% Number 1 

a = log10(34);
b = 6*exp(j*((3*pi)/4));
c = atan(sqrt(65)) + 24;
d = sqrt(3)/2 + 0.5j;


results1 = [a; b; c; d]
%% Number 2 

complex = b*d
re = real(complex);
im = imag(complex);
mag = abs(complex);
angle = angle(complex);

results2 = [re im mag angle]

%% Number 3

mult = results1*results2

elementMult = transpose(results1).*(results2);
results3 = repmat(elementMult, 4, 1)

%% Number 4

add = mult + (1/2)*results3
elm = mult.*results3
sub = mult - 2 
conj = results3' 
threes = results3 + 3*eye(4)

%% Number 5 

n = rad2deg(angle)

equalSpace = linspace(1, n, 1500)
varyingSpace = 1:0.4:n



