#############################################################################
#
# 2025-02-11; Greg Rempala, Hye-Won Kang and Boseung Choi
# Functions for the SIR model parameter estimation using logistic regrssion 
# 
#############################################################################

library(ggplot2)
library(reshape2)
library(VGAM)
library(dplyr)
library(ramcmc)
library(MASS)
library(GGally)
library(gridExtra)
library(ggpubr)
library(dplyr)

interp1d <- function(obst,xmat){ # obst = observed time point, xmat = ode solution
  k <- length(obst)
  jj <- 1
  S_ti <- matrix(0, nrow = k, ncol = ncol(xmat))
  S_ti[,1] <- obst
  for (i in 1:k) {
    for (j in jj:nrow(xmat)) {
      if (S_ti[i, 1] <= xmat[j, 1]) {
        S_ti[i, 2:ncol(xmat)] <- xmat[j, 2:ncol(xmat)]
        jj <- j
        break
      }
    }
  }
  return(S_ti)
}

# ODE for SIR model 
ode.SIR <-function(para, t=time.point,dt=time.step){
  b = para[1];   g = para[2]; ic = c(1,para[3], 0) ; N_eff = para[4];
  m = mu/3 *N_eff / N; l = lambda * N_eff / N;
  p <- length(ic)
  n <- round(t/dt) +1;  
  xmat <- matrix(rep(0,n),nrow = n, ncol=3) 
  x <- c(ic)
  xmat[1,] <- x
  for (i in 2:n) {
    x1 <- xmat[i-1,1]; x2 <-xmat[i-1,2]; x3 <-xmat[i-1,3] 
    xmat[i,1] <- xmat[i-1,1] + (- b * x1 * x2 + l - m * x1)  * dt 
    xmat[i,2] <- xmat[i-1,2] + (b * x1 * x2  - g * x2 - m *x2 )  * dt
    xmat[i,3] <- xmat[i-1,3] + (g * x2 - m * x3) * dt
  }
  return(ts(xmat,start = 0, deltat = dt))
}


# ODE for SIR model. only save Susceptible
ode.S <-function(para, t=time.point,dt=time.step){
  b = para[1];   g = para[2]; ic = c(1,para[3], 0) ; N_eff = para[4]
  m = mu/3 * N_eff/N ; l = lambda* N_eff/N;
  p <- length(ic)
  n <- round(t/dt) +1;
  xmat <- matrix(rep(0,n),nrow = n, ncol=3)
  x <- c(ic)
  xmat[1,] <- x
  for (i in 2:n) {
    x1 <- xmat[i-1,1]; x2 <-xmat[i-1,2]; x3 <-xmat[i-1,3] 
    xmat[i,1] <- xmat[i-1,1] + (- b * x1 * x2 + l - m * x1)  * dt 
    xmat[i,2] <- xmat[i-1,2] + (b * x1 * x2  - g * x2 - m *x2 )  * dt
    xmat[i,3] <- xmat[i-1,3] + (g * x2 - m * x3) * dt
  }
  return(ts(log(xmat[,1]),start = 0, deltat = dt))
}


# log likelihood
l.lik <- function(para){
  res <- ode.S(para = para); 
  res = cbind(time, res)
  res_obs = interp1d(model_data$day, res)
  fit <-glm(y ~ I + offset(res_obs[,2]), family = binomial, data = model_data)
  return(as.numeric(logLik(fit)))
}

## MCMC using RAM method including effective population estimation 
RAM.logistic <-function(nrepeat=100,init,prior.a, prior.b){
  parm.m = init[-length(init)]; N_eff=init[length(init)] 
  parm.star = parm.m 
  length.p = length(parm.m); 
  
  parameter=matrix(0,nrow=nrepeat,ncol=(length.p+1))
  count = 0
  S = diag(length.p);
  for(rep.i in 1:nrepeat){
    u = mvrnorm(1,rep(0,length.p),diag(rep(1,length.p)*0.01))
    s.parm.star = c(log(parm.m[-length.p]),qlogis(parm.m[length.p])) + S%*%u
    parm.star[-length.p] = exp(s.parm.star[-length.p])
    parm.star[length.p] = plogis(s.parm.star[length.p])    
    
    l.lik.m    = l.lik(para=c(parm.m,N_eff))
    l.lik.star = l.lik(para=c(parm.star,N_eff))
    
    alpha =exp( l.lik.star - l.lik.m
                  + sum(log(parm.star))  + log(1-parm.star[length.p])#jacobian
                  - sum(log(parm.m))     - log(1-parm.m[length.p])#jacobian 
                  + dgamma(parm.star[1], prior.a[1], rate = prior.b[1], log = T) 
                  - dgamma(parm.m[1]   , prior.a[1], rate = prior.b[1], log = T)
                  + dgamma(parm.star[2], prior.a[2], rate = prior.b[2], log = T)
                  - dgamma(parm.m[2]   , prior.a[2], rate = prior.b[2], log = T)
                  + dbeta(parm.star[3], prior.a[3], prior.b[3], log = T)
                  - dbeta(parm.m[3]   , prior.a[3], prior.b[3], log = T)
      )

    alpha=min(alpha,1)
    if(!is.nan(alpha) && runif(1)<alpha){
      parm.m=parm.star; count = count + 1;
    } 
    S=adapt_S(S,u,alpha,rep.i,gamma = min(1,length.p*rep.i^(-2/3)))
    
    ## effective population size
    res <-ode.SIR(para = c(parm.m, N_eff)); res = cbind(time, res)
    int_s = int_mu_s(res[,2], mu/3 * N_eff/N)
    tau = 1 - res[which(res[,1]==T.max),2] + lambda* N_eff/N * T.max - int_s
    tau_tilde  = tau / (1+ + lambda* N_eff/N * T.max - int_s)
    N_eff = rnbinom(1, K, tau_tilde) + K

    parameter[rep.i,] = c(parm.m, N_eff)            
    
    if(rep.i%%100 ==0 ) {
      cat("0") 
    }
  }
  cat("\n", "Acc ratio: ",count/nrepeat, "\n")
  return(parameter)
}


################################ Functions for integral of mu * s(t)
int_mu_s <-function(mu, res){
  sum(mu * res * time.step)
}




