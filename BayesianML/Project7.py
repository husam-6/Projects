#Project 7 | Sampling with PyStan
#Layth Yassin, Husam Almanakly, and Ali Ghuman

import numpy as np
from scipy.stats import poisson, gamma
import matplotlib.pyplot as plt
import matplotlib as mpl
import pymc3 as pm
import arviz as az


#Set up subplot for histograms
figure, ax = plt.subplots(5, 1, figsize=[12,16])

#Initialize Variables
a = 2
b = 1
N = 50
n = 25

lamb1 = np.random.gamma(a,1/b)
lamb2 = np.random.gamma(a,1/b)*4
x1 = np.random.poisson(lamb1,n)
x2 = np.random.poisson(lamb2,(N-n))
x = np.concatenate((x1,x2))

lambdas = [lamb1] * n + [lamb2] * (N-n)

#Plot Data Points
ax[0].stem(range(N), x, use_line_collection=True, label='Data')
ax[0].plot(range(N),lambdas,'r--', label='Mean')
ax[0].legend()
#plt.scatter(x2, xaxis)

#Use PyMC3 API to sample the Change Point Model
mod = pm.Model()
with mod:
    #Initialize all the priors using Equation set 4 From the Gibbs Sampling paper
    n_prime = pm.DiscreteUniform('n',0, N)
    lambda1 = pm.Gamma('λ_1',a,b)
    lambda2 = pm.Gamma('λ_2',a,b)

    index = np.arange(0,N)
    lambda_prime = pm.math.switch(n_prime > index, lambda1, lambda2)

    x = pm.Poisson('x1',lambda_prime, observed=x)

with mod:
    # draw 5200 posterior samples
    trace = pm.sample(5200, return_inferencedata=False)

#Plot Results
with mod:
    display(az.summary(trace, round_to=2))

#extract samples 
ns = trace['n', 200:]
lam1 = trace['λ_1', 200:]
lam2 = trace['λ_2', 200:]

tmp = max(np.mean(x2),np.mean(x1))
c = np.round(sum(trace['λ_1'])/len(trace['λ_1']),2)
c2 = np.round(sum(trace['λ_2'])/len(trace['λ_2']),2)
c3 = np.round(sum(trace['n'])/len(trace['n']),2)

#Plot each histogram and dashed line of means
#n 
ax[1].set_title('n')
ax[1].hist(ns, bins=50, edgecolor='black', color='lightgrey', label = f'n Samples')
ax[1].axvline(c3, color='black', linestyle='dashed', linewidth=2, label = f'n = {c3}')
ax[1].legend()

#Lambda1
ax[2].set_title('$\lambda$_1')
ax[2].hist(lam1, bins=50,edgecolor='black', color = 'forestgreen',range=(0,2+tmp), label = f'$\lambda$_1 Samples')
ax[2].axvline(c, color='pink', linestyle='dashed', linewidth=2, label = f'$\lambda$_1 = {c}')
ax[2].legend()

#Lambda2
ax[3].set_title('$\lambda$_2')
ax[3].hist(lam2, bins=50, edgecolor='black', color='maroon', range=(0,2+tmp), label = f'$\lambda$_2 Samples')
ax[3].axvline(c2, color='pink', linestyle='dashed', linewidth=2, label = f'$\lambda$_2 = {c2}')
ax[3].legend()

#Lambda plotted against samples
xaxis = np.linspace(0,len(lam1),len(lam1))
ax[4].set_title('$\lambda$ vs Samples')
ax[4].plot(xaxis,lam1, label = '$\lambda$_1')
ax[4].plot(xaxis,lam2, label = '$\lambda$_2')
ax[4].legend()
plt.tight_layout()

print(f'True Values: \nn = {n}')
print(f'λ_1 = {np.mean(x1)} \nλ_2 = {np.mean(x2)}')




