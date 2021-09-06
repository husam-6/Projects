function [zeroCrossings, localExtrema] = main(x,y)

xzero = x(signSwitch(y)); 

yzero = xzero;
yzero = 0; 


dydx = diff(y)./diff(x);

%had to add this line to get rid of indeterminants and allow signSwitch to
%work correctly

dydx(isnan(dydx)) = 1; 
signSwitch(dydx);

xminmax = x(signSwitch(dydx));  

yminmax = y(signSwitch(dydx)); 

figure(6);
hold on;
plot(x,y)
plot(xzero, yzero,'r*')
plot(xminmax, yminmax, 'ko')

zeroCrossings = xzero; 
localExtrema = yminmax; 

end 

function i = signSwitch(v)

%copy vector after index 2 into next 
%copy vector until index end-1 into first 
%compare when the two are simultaneously different signs

next = v(2:end); 
first = v(1:end-1); 



i = (first<0 & next>0) | (first>0 & next<0); 
i = find(i) + 1;

end








