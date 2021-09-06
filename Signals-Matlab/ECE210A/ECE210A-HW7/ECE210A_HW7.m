%% Husam Almanakly | ECE210 HW7

clear 
clc 
close all 

%% Number 1

t = linspace(0,2,2001); %2001 to include boundary points (2000 points from 1 - 2001)

signal = 0; 
for f = 1e3:1e3:50e3
   
    signal = signal + sin(2*pi*f*t);

end


makePlots(butterworth, "Butterworth Filter", signal)
makePlots(chebychev1, "Chebychev I Filter", signal)
makePlots(chebychev2 , "Chebychev II Filter", signal)
makePlots(elliptic, "Elliptic Filter", signal)

function fig = makePlots(filterObj, filterName, signal)

[H, f] = freqz(filterObj, 1024, 100e3);

Hdb = 20*log10(abs(H));
phi = rad2deg(unwrap(angle(H)));

figure
subplot(2,1,1)
title("Butterworth Filter")
plot(f, Hdb)
xlabel("Frequency (Hz)")
ylabel("Magnitude Response (dB)")
title("Magnitude Response of " + filterName)

subplot(2,1,2)
plot(f, phi)
xlabel("Frequency (Hz)")
ylabel("Phase (deg)")
title("Phase Response of " + filterName)

out = filter(filterObj, signal);

N= 2^10;
fourier = fft(out,N);
scaled = fftshift(abs(fourier))/N;

figure
plot(f, scaled)
xlabel("Frequency (Hz)")
ylabel("Magnitude")
title("Fourier Transform of Signal filtered by " + filterName)

end


