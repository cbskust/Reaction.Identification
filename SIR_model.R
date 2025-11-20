###############################################
# Reaction network identification 
# SIR model 
###############################################

library(ggplot2)
library(reshape2)
library(nnet)
library(VGAM)

#loading data 
Case1 = read.csv("SIR_model_Multinomial.csv")

# response variable for the logistic regression model 
y = Case1$Reaction.Type

# Frequency table of reaction; Table S13
cat("\nUnique Rows Matrix:\nFrequencies of Unique Rows:\n")
table(y)

# modeling data for the logistic regression model 
model_data  = data.frame(row_strings = row_strings,
                         y = y,
                         S = Case1$S,
                         I = Case1$I,
                         R = Case1$R
)

# correcting for log(0) 
model_data$S=ifelse(model_data$S==0,0.00000001, model_data$S)
model_data$I=ifelse(model_data$I==0,0.00000001, model_data$I)
model_data$R=ifelse(model_data$R==0,0.00000001, model_data$R)

# The multi-category logistic regression model for TK model; For Table S12 
fit <-vglm(y ~ log(S) + log(I) + log(R), family = multinomial(refLevel = 6), data = model_data)
summary(fit)
