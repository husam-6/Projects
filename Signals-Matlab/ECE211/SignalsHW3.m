%% Husam Almanakly || Signals HW3 

clear all 
close all 
clc

%% Number 1

t = linspace(-5,5,100000); 

%each function made using heaviside
x = exp(-2.*t).*heaviside(t);
h = 3*heaviside(t+2)- 3*heaviside(t-1);
y = conv(x,h,'same')*0.0001; 

figure(1);
hold on; 

legend('show');

%plotting each function vs time on the same figure
title('Convolution of x(t) and h(t)');
xlabel('time t');
ylabel('h,x,y');
plot(t,x,'DisplayName', 'x(t)');
plot(t,h,'DisplayName', 'h(t)');
plot(t,y,'DisplayName', 'y(t)=x(t)*h(t)');


%% Number 2
 
x = struct();
x.data = [2, 1, 0, -1, 3];
x.start = -2; 
x.length = length(x.data);

h = struct();
h.data = [2 1 3];
h.start = 1; 
h.length = length(h.data);

x.support = stemPlot(x,1)
title('x[n]'); 
xlabel('n');
ylabel('x[n]');

h.support = stemPlot(h, 2)
title('h[n]')
xlabel('n');
ylabel('h[n]');

y = struct();
[y.data,y.start] = convolution(x, h); 
y.length = length(y.data);

y.support = stemPlot(y, 3)
title('y[n] = x[n]*h[n]');
xlabel('n');
ylabel('y[n]');


%function takes in a structure and an index x which decides the position on
%the subplot. Creates a stemplot of the given structure with appropriate
%indices
function i = stemPlot(func,x) 

i = func.start:1:(func.start + (length(func.data)-1));

figure(2);
hold on;
subplot(2,2,x)
stem(i,func.data)
 
xlim([func.start-1 (func.start + (length(func.data)-1))+1]);
ylim([-2 max(func.data)+1]);

end


%function takes in two structures and convolves them, returning the
%convolved function and the start index of the resulting set
function [d,start] = convolution(v1,v2)

d = struct();
d = conv(v1.data,v2.data);

start = v1.start + v2.start; 

end

