% Husam Almanakly  | Homework 2 ECE210-A
%

clear
close all 
clc

%% Number 1

v1 = linspace(0,2*pi, 100);
v2 = linspace(0,2*pi, 1000);


cos1 = cos(v1./2);
cos2 = cos(v2./2);

ddx1 = diff(cos1)./diff(v1);  %Should be -1/2sin(x/2)! 
ddx2 = diff(cos2)./diff(v2);

check1 = -1/2*sin(v1./2); 
check2 = -1/2*sin(v2./2);

difference1 = check1(1:end-1) - ddx1; 
difference2 = check2(1:end-1) - ddx2;

maxDiff1 = max(difference1) %v2 (the vector of length 1000) produces 
maxDiff2 = max(difference2) %better results with a significanlty smaller max difference

integral1 = cumsum(cos1 * (2*pi)/100);  %Should be 2*sin(x/2)
integral2 = cumsum(cos2 * (2*pi)/1000);

check3 = 2*sin(v1./2);
check4 = 2*sin(v2./2);

difference3 = check3 - integral1; 
difference4 = check4 - integral2; 

maxDiff3 = max(difference3)     %v2 again provides the better results 
maxDiff4 = max(difference4)

hold on;
figure(1); 
title('Integral Approximation of cos(x/2)')
plot(v2, integral2)



%% Number 2 

start = 1:100; 
start = fliplr(start);


A = reshape(start,10,10)

A = flipud(A)

A(4,:) = fliplr(A(4,:)) 

ColSum = sum(A,1)
RowProd = prod(A,2)

diagonal = diag(A)

A(7,:) = []



%% Number 3

%For Loop Without Preallocation first

tic
for i = 1:300
   for j = 1:300
       B(i,j) = 1/(2*pi) * 10/((i-150)^2 + (j-150)^2 + 10^2)^(3/2);
   end
end
toc


%For Loop With Preallocation

B = zeros(300,300);
tic
for i = 1:300
   for j = 1:300
       B(i,j) = 1/(2*pi) * 10/((i-150)^2 + (j-150)^2 + 10^2)^(3/2);
   end
end
toc


%Vector Operations
tic
    a = 1:300;
    b = a; 
    
    [i,j] = meshgrid(a,b);
    
    D = 1/(2*pi) * 10./((i-150).^2 + (j-150).^2 + 10^2).^(3/2);
    
toc

