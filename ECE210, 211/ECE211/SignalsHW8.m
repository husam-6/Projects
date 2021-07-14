%%Husam Almanakly | Signals Homework 8

clear
close all 
clc

%% Number 1

%Given variables
alpha = 0.544;
nu = 5;
N = 1e6;

%Students' Distribution
scale = 1/(nu/(nu-2));
students = scale*trnd(nu, 1, N);

%N(0,1) samples
gaussian = 1*randn(1, N);

%Cauchy Distribution
cauchy = alpha*tan(pi*randn(1,N));

%Fraction of time abs(Gaussian)>=4 (see function at the end of file)
gaussianFraction = exceeds(gaussian, "Gaussian")

%Fraction of time abs(cauchy)>=4 
cauchyFraction = exceeds(cauchy, "Cauchy")

%Fraction of time abs(students)>=4
studentsFraction = exceeds(students, "Students' T")


%% Number 2

%given parameters 
num = [2 0.2 -0.84];
den = [1 -0.95 0.9];
N = 1e5;
v = 1*randn(1,N);
m0 = 5;

%generating x via filter function
x = filter(num, den, v);

%given code to approximate impulse response h
Nlen= 1000;
h = impz(num, den, Nlen);
r = conv(h,flipud(h));
r = r(Nlen:Nlen+m0)


%% Number 3

%pole-zero plot for filter
figure
zplane(num,den)
title("Pole-Zero Plot of Given Filter")


%% Number 4

%correlation matrix R
M = 6
xm = x(1:M);
R = toeplitz(r);

% M value that works -> M=6 

%% Number 5

% Eigendecomposition of correlation matrix R
[eigvec, eigval0] = eig(R);
[eigval idx] = sort(diag(eigval0), 'descend');
eigvec = eigvec(:, idx);

%% Number 6

%given code using pwelch
[s_est, w] = pwelch(x, hamming(512), 256, 512);

%Generating H(w) using freqz
H_w = freqz(num, den, w);
Sx = abs(H_w).^2;

%normalizing PSD (theoretical and approximation) and converting to dB
Sx = Sx./(mean(Sx));
s_est = s_est./(mean(s_est));
Sx = 20*log10(Sx);
s_est = 20*log10(s_est);

figure
hold on;
plot(w./pi, Sx)
plot(w./pi,s_est)
legend('Theoretical Sx', 'Approximated Sx')
title('Power Spectral Density of Correlation Matrix')
xlabel('Frequency (w/\pi)')
ylabel('PSD (dB)')

%% Number 7

%Compute angle(poles) to compare to peak freq
poles = roots(den);
poleAngle = angle(poles)

[peak, index] = max(Sx);
peakFreq = w(index)

%Values are very close!

%% Number 8

%data matrix A
ind1 = m0+1:1:N;
ind2 = m0+1:-1:1;

%Indices for first column and first row
xm1 = x(ind1);
xm2 = x(ind2);
A = toeplitz(xm2,xm1);

%Singular Value Decomposition of A, storing S in a diagonal vector
[U, S, V] = svd(A, 'econ');
S = diag(S);



%% Number 9 

%Approximation using Ergodic Statement
R = 1/(N - m0)*A*transpose(A);
lambda = 1/(N - m0)*(S.^2);

%Matrix of inner products among eigenvectors and singular vectors
QU = abs(eigvec'*U)
err = QU-eye(m0+1,m0+1);
errmax = max(abs(err(:)))



%% Function for problem 1

function frac = exceeds(distribution, name);
    g = abs(distribution)>=4;
    count = distribution(g);
    frac = length(count)/length(distribution);
    figure
    plot(distribution)
    yline(-4, 'LineStyle', '--')
    yline(4, 'LineStyle', '--')
    title(name + " " + "Distribution")
    xlabel("N samples")
    ylabel("Distribution Values")
end 

