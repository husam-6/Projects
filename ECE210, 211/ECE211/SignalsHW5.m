%% Husam Almanakly | Signals HW5
clc
clear
close all

%% Number 3
fp = [12e3, 15e3]; 
fs = [10e3, 16e3]; 
rp = 1.5;
rs = 30;
[n, wn] = ellipord(2*pi*fp, 2*pi*fs, rp, rs, 's')
[z, p, k] = ellip(n, rp, rs, wn,'s');
[b, a] = zp2tf(z, p, k);

figure;
zplane(b,a)
title("Pole Zero Plot of Bandpass Filter")

w = linspace(0,20000, 1000);
w = w.*2*pi;
h = freqs(b,a,w);

HdB = 20*log10(abs(h));
phase = rad2deg(unwrap(angle(h)));

figure;
subplot(2,1,1);
hold on
plot(w, HdB)
yline(-30, 'LineStyle', '--')
yline(0, 'LineStyle', '--')
yline(-1.5, 'LineStyle', '--')
title("Magnitude Response of Analog Filter")
xlabel("Frequency \omega (rad)")
ylabel("Magnitude (dB)")
ylim([-60 1])
xlim([0 126000])

subplot(2,1,2);
plot(w, phase)
title("Phase Response of Analog Filter")
xlabel("Frequency \omega (rad)")
ylabel("Phase (degrees)")
xlim([0 126000])

%% Number 4

%using same variables as question 3, fp, fs, rp, rs

fsamp = 40e3; 
[nd, wnd] = ellipord(fp/(fsamp/2), fs/(fsamp/2), rp, rs)
[zd, pd, kd] = ellip(nd, rp, rs, wnd);
[bd, ad] = zp2tf(zd, pd, kd);

figure
zplane(bd, ad)
title("Pole Zero Plot of Digital Elliptic Filter")

h2 = freqz(bd, ad, 1000);
HdBdig = 20*log10(abs(h2));
phaseDig = rad2deg(unwrap(angle(h2)));

figure;
subplot(2,1,1)
plot(w, HdBdig)
yline(-30, 'LineStyle', '--')
yline(0, 'LineStyle', '--')
yline(-1.5, 'LineStyle', '--')
title("Magnitude Response of Digital Filter")
xlabel("Frequency \omega (rad)")
ylabel("Magnitude (dB)")
ylim([-60 1])
xlim([0 126000])

subplot(2,1,2)
plot(w, phaseDig)
title("Phase Response of Digital Filter")
xlabel("Frequency \omega (rad)")
ylabel("Phase (degrees)")
xlim([0 126000])










