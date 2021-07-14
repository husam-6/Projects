%% Husam Almanakly | Signals HW7

 
%% Part II
clc
close all 
clear

%Generate Data matrix A, return the L source vectors in source
PdB = [0 -2 -4];
[A source] = randL(100, 200, 10, PdB, -15);

%Singular Value Decomposition of A 
[U,S,V] = svd(A);
S = diag(S);

%Plotting the SVD of A against n 
n = 1:1:100;
figure
stem(n,S) 
title("Singular Value Decomposition of Data Matrix A")
xlabel("time n")
ylabel("Singular Value")

%Generate correlation matrix R and R^-1
R = 1/200*A*transpose(A);
R_1 = inv(R);

[eigvec, eigval0] = eig(R);
[eigval idx] = sort(diag(eigval0), 'descend');
eigvec = eigvec(:, idx);

%Create UL (first three vectors from U matrix returned by SVD
UL = U(:,1:3);
PS = UL*transpose(UL);
I = eye(100);

%Calculate projection onto noise subspace
PN = I - PS;

%Calculate the Smusic and Smvdr values at the original L source vectors
for i=1:3
   s = source(:,i);
   Smusic(i) = 1/(transpose(s)*PN*s); 
   Smvdr(i) = 1/(transpose(s)*R_1*s);
end

%Calculate the Smusic and Smdvr values for 20 randomly generated source 
%vectors from our dictionary
for i=1:20
    test = zeros(100,1);
    indices = randperm(100, 10);
    test(indices) = 1/(sqrt(10));
    
    Smusic2(i) = 1/(transpose(test)*PN*test); 
    Smvdr2(i) = 1/(transpose(test)*R_1*test);
    
end

%Display the orignal 'correct' Smusic and Smdvr values 
%Then display the median and maximum of the 20 generated test source
%vectors
Smusic
Smusic_test_max = max(Smusic2)
Smusic_test_med = median(Smusic2)

Smvdr
Smvdr_test_max = max(Smvdr2)
Smvdr_test_med = median(Smvdr2)


%% Part I

function [A source] = randL(M, N, K, PdB, NoisedB) 

L = length(PdB);

%make a matrix Lsource whose columns are the L source vectors (using the
%above methods with randperm) 
source = zeros(M,L);
B = zeros(L,N);

%convert to power (given in dB)
P = 10.^(PdB/10);

for i = 1:1:L
    dimM = zeros(1,M);
    indices = randperm(M, K);
    dimM(indices) = 1/(sqrt(K));
    source(:,i) = dimM;
    
    %Coefficient matrix, variance P, 1xN
    b = sqrt(P(i))*randn(1,N);
    B(i,:) = b;
end

%convert to power (given in dB)
Noise = 10.^(NoisedB/10);

%Noise matrix, variance given (Noise), MxN
v = sqrt(Noise)*randn(M,N);

%Data matrix
A = source*B + v;
 
end
