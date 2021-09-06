%% Husam Almanakly | ECE210A HW6

clear 
close all 
clc

%% Number 1 

num = [2/5 1/4 1/7];
den = [1/3 0 -1/8 3/2];

r = roots(num);
p = roots(den);

figure(1)
zplane(num, den)
title("Pole Zero Plot")

[h,n] = impz(num, den, 50);
figure(2)
hold on
title('Impulse Response of H(z)')
xlabel('Time t (s)');
ylabel('Impulse Response h(t)');
xlim([-1 51])
stem(n,h)

figure(3)
subplot(2,1,1);
hold on
title('x[n] before')
xlabel("n")
ylabel("x[n]")
x = (-4/5).^n;
stem(n,x)

subplot(2,1,2);
title('x[n] after filtering through H(z)')
xlabel("n")
ylabel("x[n]")
y1 = filter(num, den, x);
subplot(2,1,2);
hold on
xlim([-1 52])
stem(n, y1)

figure(4)
y2 = conv(x, h);
cutLen = y2(1:50);
stem(cutLen)
title('Convolution of x and h')
xlabel("n")
ylabel("y = x[n]*h[n]")
xlim([-1 52])

%% Number 2

k = 0.01;
zeros = [-1; 1];
poles = [0.9*exp(j*pi/2); 0.9*exp(-j*pi/2); 0.95*exp(j*(5*pi)/12); 0.95*exp(-j*(5*pi)/12); 0.95*exp(j*(7*pi)/12); 0.95*exp(-j*(7*pi)/12)];

figure(5)
title('Pole Zero Plot')
zplane(zeros, poles)

[b a] = zp2tf(zeros, poles, k);

[H, w] = freqz(b,a,1024);

figure(6)
subplot(2,1,1);

gain = abs(H);
gaindB = 20*log10(gain);
plot(w, gaindB)
hold on
xlim([0 pi])
title("Magnitude Response")
xlabel("Frequency (radians)")
ylabel("|H| Gain")
xticks([0 pi/4 pi/2 3*pi/4 pi]);
xticklabels({'0', '\pi/4', '\pi/2', '3\pi/4', '\pi'});

%Hph = rad2deg(unwrap(angle(H)));
phase = rad2deg(unwrap(angle(H)));
subplot(2,1,2);
plot(w, phase)
xlim([0 pi])
xticks([0 pi/4 pi/2 3*pi/4 pi]);
xticklabels({'0', '\pi/4', '\pi/2', '3\pi/4', '\pi'});
title("Phase Response")
xlabel("Frequency (radians)")
ylabel("Phase \theta")










