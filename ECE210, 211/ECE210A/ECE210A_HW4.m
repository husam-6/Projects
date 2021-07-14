%% Husam Almanakly || ECE210-A HW4

clc 
clear
close all 

%% Gram Schmidt Tests

c = rand(4,4) + i*rand(4,4);    %c is a random complex matrix, 4 column vectors
z = rand(4,2) + i*rand(4,2);    %z is a random complex matrix, 2 column vectors

y = gramSchmidt(c);
yOrthoNorm = isOrthonormal(y)   %output of orthoNormal test

b = gramSchmidt(z);
bOrthoNorm = isOrthonormal(b)   %output of orthoNormal test

h = [2; 1; 3; 4];              %test vector to project onto y and b
proj1 = orthoProj(h,y);
proj2 = orthoProj(h,b);

error1 = norm(proj1 - h)    %Euclidean Distance between both projections
error2 = norm(proj2 - h)


%% Main Application

x = linspace(0,2*pi, 1000);
sample = sin(x);

mu = 0: pi/2 : 2*pi;
mu2 = ndgrid(mu);
sig = 1;

gauss = (1/sqrt(2*pi*sig.^2)) * (exp(-(x - mu2).^2/sig.^2)); 

figure(1);
hold on; 
title('sin(x) and 5 Gaussians vs variable x');
xlabel('x');
ylabel('sin(x) and Gaussian Output');

plot(x,sample)
plot(x,gauss)

legend('sin(x)', '\mu = 0', '\mu = pi/2', '\mu = pi', '\mu = 3pi/2', '\mu = 2pi');

gauss = transpose(gauss);
sample = transpose(sample); 

orthoNormalSet = gramSchmidt(gauss);
estimate = orthoProj(sample, orthoNormalSet); 

figure(2); 
hold on; 
subplot(2,1,1); 
plot(x, sample, x, estimate);
title('sin(x) and estimated projection of sin(x)');
xlabel('x');
ylabel('sin(x) and projected sin(x)');
legend('sin(x)','Projected Sin(x)');

subplot(2,1,2);
plot(x, orthoNormalSet); 
title('Orthonormal Basis Functions vs x');
xlabel('x'); 
ylabel('value of Basis Functions'); 
legend('Function 1', 'Function 2', 'Function 3', 'Function 4', 'Function 5'); 


%% Functions


%returns a vector v thats an orthogonal projection along the given
%orthonormal set
function v = orthoProj(x, ons)

n = size(ons); 

v = 0; 
for j = 1:n(2)
    v = v + conj(dot(ons(:,j),x))*ons(:,j);
end 

end

%function loops through entire matrix and checks if each column vector is
%orthonormal to each other
function condition = isOrthonormal(input)

n = size(input); 


for i = 1:(n(2)-1)
    for j = i+1:n(2); 
        k = conj(dot(input(:,i), input(:,j))); 
        ith = norm(input(:,j)); 
        jth = norm(input(:,i)); 
        if (k > 1000*eps) || (ith - 1 > 1000*eps) || (jth - 1 > 1000*eps)
            condition = 0; 
            return; 
        else
        end
    end
end
condition = 1;
end

%function that implements Gram Schmidt algorithm to obtain a set of
%orthonormal vectors
function output = gramSchmidt(input)

n = size(input); 

for i = 1:n(2)
    if (i == 1)
        output(:,i) = input(:,i)./norm(input(:,i));
    else
        w = 0;
        for j = 1:i-1
            x = conj(dot(input(:,i), output(:,j)))./norm(output(:,j)).^2*(output(:,j));
            w = x + w;
        end
        output(:,i) = input(:,i) - w;
        output(:,i) = output(:,i)./norm(output(:,i));
    end
end

end

