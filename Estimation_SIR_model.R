################################################################
# Parameter estimation using logistic regression 
# logistic regression model fitting using Seoul COVID-19 data 
# 2025-10-17 ~ 2021-01-24
#
################################################################

source("SIR_logitic_function.R")

model_data = read.csv(file = "COVID-19.csv")

################## Initial parameter 


T.max = 100; 
time.point = ceiling(T.max); # Time period 
time.step = time.point/(200)
time=seq(from=0, to=time.point, by=time.step); 



N=9940738; I0 = model_data$I[1];
K = sum(subset(model_data, y==1, select=y)); # toal number of infection  
beta = 0.3; gamma= 1/4; rho= 0.002; #al = 1/5.5;
mu = 0.013; lambda = 0.013; N_eff = 30000;

para.init = c(beta, gamma, rho, N_eff); # Including effi. population into the iteration


#######################################################################################
### Running MCMC 

nrepeat=4000
  result = RAM.logistic(nrepeat=nrepeat,init=para.init,
                        prior.a=c(0.001, gamma*1e+4, 1),
                        prior.b=c(0.001,     1*1e+4, 1))

colnames(result)=c("beta", "gamma", "rho", "N_eff")
print(summary(result[(nrepeat/2+1):nrepeat,]))
