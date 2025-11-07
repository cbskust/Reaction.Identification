In this study, we propose likelihood-based methods grounded in multinomial logistic regression to infer both stoichiometries and network connectivity structure from full time-series trajectories of stochastic chemical reaction networks. When complete molecular count trajectories are observed for all species, stoichiometric coefficients are identifiable, provided each reaction occurs at least once during the observation window. However, identifying catalytic species remains difficult, as their molecular counts remain unchanged before and after each reaction event. 

We demonstrate that the logistic regression framework can recover the full network structure, including stoichiometric relationships. We further apply Bayesian logistic regression to estimate model parameters in real-world epidemic settings, using the COVID-19 outbreak in the Greater Seoul area of South Korea as a case study. Our analysis focuses on a Susceptible–Infected–Recovered (SIR) network model that incorporates demographic effects. To address the challenge of partial observability, particularly the availability of data only for the infectious subset of the population, we develop a method that integrates Bayesian logistic regression with differential equation models. This approach enables robust inference of key SIR parameters from observed COVID-19 case trajectories. Overall, our findings demonstrate that simple, likelihood-based techniques such as logistic regression can recover meaningful mechanistic insights from both synthetic and empirical time-series data.

In this repository, we provide the necessary toolkit for a statistical inference method based on a multinomial logistic regression model for reaction network identification and a Bayesian approach for modified COVID-19 case data, as presented in the paper on [http://dx.doi.org/10.1098/rsfs.2019.0048](https://arxiv.org/abs/2507.19979).

We provide R codes and example data.

TK_model.R : This file provides examples using R code to fit a multinomial regression model for the Togashi-Kaneko model and for Table 1 and Table S2 in the manuscript. 

HeatShock_model.R: This file provides examples using R code to fit a multinomial regression model for the Heat Shock Response model and for Table 2 and Table S8 in the manuscript. 

SIR_model.R : This file provides examples using R code to fit a multinomial regression model for the SIR model with demography, and for Table 3 and Table S13 in the manuscript. 

TK_model_Mutinomical_Case1.csv: example data of the synthetic Togasshi-Kaneko model with symmetric reaction rate (Case 1), including numbers of species and reaction type.

HeatShock_model_Mutinomical_Case1.csv: example data of the synthetic Heat Shock Response model Case 1, including the number of species and reaction type.

SIR_model_Mutinomical.csv: example data of the synthetic SIR model, including numbers of three compartments: S, I, and R, and reaction type.

Estimation_SIR_model.R: This file provides examples using R code to estimate the SIR model based on Bayesian multinomial logistic regression. The RAM (robust adopted Metropolis) algorithm is used for the MCMC simulation.   

COVID-19.csv: example data of COVID-19 outbreak in Seoul, South Korea from Oct. 17, 2020, to Jan. 24, 2021. However, this dataset is a synthetic dataset inspired by the COVID-19 outbreak in Seoul, using the procedure described in Algorithm S1.

SIR_logistic_function.R: this R code includes some functions to estimate the SIR model based on the logistic regression model. 


