In this study, we propose likelihood-based methods grounded in multinomial logistic regression to infer both stoichiometries and network connectivity structure from full time-series trajectories of stochastic chemical reaction networks. When complete molecular count trajectories are observed for all species, stoichiometric coefficients are identifiable, provided each reaction occurs at least once during the observation window. However, identifying catalytic species remains difficult, as their molecular counts remain unchanged before and after each reaction event. 

We demonstrate that the logistic regression framework can recover the full network structure, including stoichiometric relationships. We further apply Bayesian logistic regression to estimate model parameters in real-world epidemic settings, using the COVID-19 outbreak in the Greater Seoul area of South Korea as a case study. Our analysis focuses on a Susceptible–Infected–Recovered (SIR) network model that incorporates demographic effects. To address the challenge of partial observability, particularly the availability of data only for the infectious subset of the population, we develop a method that integrates Bayesian logistic regression with differential equation models. This approach enables robust inference of key SIR parameters from observed COVID-19 case trajectories. Overall, our findings demonstrate that simple, likelihood-based techniques such as logistic regression can recover meaningful mechanistic insights from both synthetic and empirical time-series data.

In this repository, we provide the necessary toolkit for a statistical inference method based on a multinomial logistic regression model for reaction network identification and a Bayesian approach for modified COVID-19 case data, as presented in the paper on [http://dx.doi.org/10.1098/rsfs.2019.0048](https://arxiv.org/abs/2507.19979).

We provide R codes and example data.

Example2.R : This file provides examples using R codes to estimate synthetic epidemic data with Sellke construction to utilize MCMC for SDS likelhood.

Example3.R : This file provides examples using R codes to estimate synthetic epidemic data with Sellke construction to utilize maximum likelihood and MCMC for Doob Gillespie method.

WSU.csv: example data of H1N1 pandemic data from WSU. The original data only has daily counts of new infection. We modifed it to use SDS method.

Description for mainly used functions in the SDSMCMC package

Sellke(): This function generate synthetic epidemic data using Sellke construciotn in Algorithm 3.1.

SellkeToTrajectory(): This function converts epidemic data wih infection and removed time to SIR trajectory data with S(t), I(t), and R(t) at discrete time t

SirMle(): This function calculates MLE using SIR empidemic data.

GillespieMCMC(): This function generates posterior samples of beta, gamma, and rho using MCMC based on Examce likelihood in subsection 4.1.

GaussianMCMC(): This function generates posterior samples of beta, gamma, and rho using MCMC based on Gaussian likelihood in subsection A.2.

SdsMCMC(): This function conducts MCMC simuation using SDS likelihood in subsection 4.2 and Algorithm 5.1 and generate posterior samples of parameters from their posterior distribution.

result(): This function produce a summary statistics table of posterior samples and fugures for MCMC diagnostics.

Description for example files Example1.R: This file provides examples using R codes to estimate WSU H1N1 daeta using MCMC for SDS likelhood. This example used "WSU.csv" data file.


