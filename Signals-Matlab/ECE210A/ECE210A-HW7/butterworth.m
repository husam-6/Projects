function Hd = butterworth
%BUTTERWORTH Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.8 and Signal Processing Toolbox 8.4.
% Generated on: 07-Apr-2021 19:11:27

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in kHz.
Fs = 100;  % Sampling Frequency

Fstop1 = 25;          % First Stopband Frequency
Fpass1 = 30;          % First Passband Frequency
Fpass2 = 40;          % Second Passband Frequency
Fstop2 = 45;          % Second Stopband Frequency
Astop1 = 50;          % First Stopband Attenuation (dB)
Apass  = 5;           % Passband Ripple (dB)
Astop2 = 50;          % Second Stopband Attenuation (dB)
match  = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% Get the transfer function values.
[b, a] = tf(Hd);

% Convert to a singleton filter.
Hd = dfilt.df2(b, a);



% [EOF]
