%% Husam Almanakly | ECE210A HW3 

clear 
clc
close all 

%% Number 1

A = ones(100,100);
B = A;
C = A;

first = 1:100;

[i,j] = meshgrid(first);

D = ((i-25).^2 + (j-75).^2).^(1/2); 
E = ((i-75).^2 + (j-25).^2).^(1/2); 
A(D<10 | E<10) = 0;

F = ((i-25).^2 + (j-25).^2).^(1/2); 
G = ((i-75).^2 + (j-75).^2).^(1/2); 
B(F<10 | G<10) = 0;

H = ((i-50).^2 + (j-50).^2).^(1/2); 
C(H>10) = 0;

C = ones(100,100) - C;
figure(1);
imshow(C)

figure(2); 
imshow(A)

I = ones(100,100);
I(A<1 | C<1) = 0; 
figure(3); 
imshow(I)

J = ones(100,100);
J(A<1 | B<1) = 0; 
figure(4); 
imshow(J)

K = ones(100,100);
K(J<1 | C<1) = 0; 
figure(5); 
imshow(K)

%% Number 2 -> Function findThreshold at end of File 

%Suggested Test

[value,index] = findThreshold(normpdf(linspace(0,5,100),0,1), 0.05)


%% Number 3 

x = linspace(-5.25,5.25, 9999);
y=sin(pi*x)./(pi*x);            % Sinc would not work on my machine
                                % I googled the function and found this is
                                % it's definition 

[zeros, extrema] = main(x,y);

extract = y(5000:5953);  
[firstVal, firstInd ]= findThreshold(extract,0.2) 


%% Function for number 2 (findThreshold)

% findThreshold function - other functions in main.m 
function [val,ind] = findThreshold(X,threshold)
    ind = find(X<threshold);
    ind = ind(1);
    val = X(ind);
end 
