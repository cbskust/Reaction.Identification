###############################################
# Reaction network identification 
# TK model 
###############################################



# Load necessary libraries
library(ggplot2)
library(reshape2)
library(nnet)
library(VGAM)
library(readxl)

#loading data 
Case1 = read.csv("TK_model_Multinomial_Case1.csv")

# response variable for the logistic regression model 
y = Case1$Reaction.Type

# Frequency table of reaction; Table S1
cat("\nUnique Rows Matrix:\nFrequencies of Unique Rows:\n")
table(y)

# modeling data for the logistic regression model 
model_data  = data.frame(y = y,
                         A = Case1$A,
                         B = Case1$B
)


# The multi-category logistic regression model for TK model; For Table S2 
fit <-vglm(y ~ A + B , family = multinomial(refLevel = 6), data = model_data)
summary(fit)

