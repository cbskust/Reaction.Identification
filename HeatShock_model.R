###############################################
# Reaction network identification 
# Heat shock response model 
###############################################

# Load necessary libraries
library(ggplot2)
library(reshape2)
library(nnet)
library(VGAM)
library(readxl)

#loading data 
Case1 = read.csv("HeatShock_model_Multinomial_Case1.csv")

# response variable for the logistic regression model 
y = Case1$Reaction.Type


# Frequency table of reaction; Table S7
cat("\nUnique Rows Matrix:\nFrequencies of Unique Rows:\n")
#table(row_strings);
table(y)

# modeling data for the logistic regression model 
model_data  = data.frame(
                         y = y,
                         P1 = Case1$P1,
                         P2 = Case1$P2,
                         R1 = Case1$R1
)

# correcting for log(0) 
model_data$P1=ifelse(model_data$P1==0,0.00000001, model_data$P1)
model_data$P2=ifelse(model_data$P2==0,0.00000001, model_data$P2)
model_data$R1=ifelse(model_data$R1==0,0.00000001, model_data$R1)

# The multi-category logistic regression model for HSR model; For Table S6 
fit <-vglm(y ~ log(P1) + log(P2) + log(R1) , family = multinomial(refLevel = 10), data = model_data)
summary(fit)




