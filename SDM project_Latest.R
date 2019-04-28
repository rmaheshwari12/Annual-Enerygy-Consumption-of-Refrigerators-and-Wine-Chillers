setwd("E:\\USF - BAIS\\SDM\\Final project data\\Refrigerators and Chillers\\Refrigerator and chillers\\Fina SDM Project Data")
s<-read.csv("Refrigerator_Alldata.csv")
library(dplyr)
library(corrplot)
library(car)
library(corrplot)

attach(s)
View(s)
dim(s)
names(s)
str(s)
#Data Cleaning
s <- select(s,-1)
View(s)

#Coulmn Re-naming
colnames(s)
names(s)[4] <- "AEC"
names(s)[6] <- "Defrost"
names(s)[7] <- "FreezerLoc"
names(s)[8] <- "TotalVol"
names(s)[9] <- "SizeCategory"
names(s)[10] <- "DoorIce"
names(s)[11] <- "RefVol"
names(s)[12] <- "FreezerVol"
View(s)
write.csv(s,"Refrigerator_Data1.csv")

#New Cleaned File Call
s<- read.csv("Refrigerator_Data1.csv")
s <- s[-c(1)]
attach(s)

#Exploratory Data Analysis
hist(AEC)
hist(sqrt(AEC))

#Subsetting Data as per Compact Refrigerator and Total Volume
a <- subset(s, Type == "Compact refrigerator" & TotalVol == 0)
hist(a$TotalVol)
s[- grep(0, s$TotalVol)]

hist(a$TotalVol)
hist(FreezerVol)
hist(RefVol)

#Checking Corelation
#m <- cor(cbind(d[, 3:10], d[, 13:16]))
#cor(s[,unlist((lapply(s, is.numeric)))])
install.packages("corrplot")
library(corrplot)
s_cor<- cor(cbind(s[,11:13],(s$SizeCategory)))
corrplot(s_cor,method = "number")



#OLS Model - Complete Pooling

m0<-lm(AEC ~ as.factor(Type) + as.factor(Defrost) + as.factor(FreezerLoc) + Ratio , data = s)
summary(m0)
plot(m0)
mean(m0$residuals)
hist(m0$residuals)
AIC(m0)
vif(m0)

#OLS Assumption testing
shapiro.test(m0$residuals) #Checking Normality, since p <0.05 Test Fails
bartlett.test(list(m0$residuals,m0$fitted.values),s) #Checking Homoskedasticity, since p < 0.05, Data is Heteroskedastic
vif(m0) #Checking Multicolinearity: Not found
plot(m0$residuals~m0$fitted.values) #Checking Linearity: not found

m1<-lm(AEC ~  as.factor(Brand) + as.factor(Type) + as.factor(Defrost)+ as.factor(FreezerLoc) + Ratio, data = s)
summary(m1)
plot(m1)
AIC(m1)

#OLS Assumption testing
shapiro.test(m1$residuals) #Checking Normality, since p <0.05 Test Fails
bartlett.test(list(m1$residuals,m1$fitted.values),s) #Checking Homoskedasticity, since p < 0.05, Data is Heteroskedastic
vif(m1) #Checking Multicolinearity: Very high Variance Inflation observed  for 'Brand','Type','FreezerLoc'
plot(m1$residuals~m1$fitted.values) #Checking Linearity: not found


#####################################################################
#FINAL MODELS
#####################################################################
install.packages("lme4")
install.packages("Matrix")
library(lme4)


ws<- read.csv("E:\\USF - BAIS\\SDM\\Final project data\\Refrigerators and Chillers\\Refrigerator and chillers\\Fina SDM Project Data\\Wine Chiller signature.csv")

#Simple OLS for wine chiller

Sm4<-lm(sqrt(AEC) ~ as.factor(Defrost) +RefVol+as.factor(Defrost)*RefVol, data = ws)
summary(Sm4) # R2: 32.62

# lmer(random effect of brands) for wine chillers
Sm5m <- lmer(sqrt(AEC) ~ as.factor(Brand)+ as.factor(Defrost)+as.factor(Defrost)*RefVol+
               RefVol+ (1|Brand), data = ws)
summary(Sm5m)

AIC(Sm4);AIC(Sm5m) #1077,896

#Refrigerator and Compact Refrigerator
r <- read.csv("E:\\USF - BAIS\\SDM\\Final project data\\Refrigerators and Chillers\\Refrigerator and chillers\\Fina SDM Project Data\\Refrigerator data_cleaned signature.csv")
r$FreezerLoc <- relevel(r$FreezerLoc,"No freezer")

# simple OLS
Sm2<-lm(AEC ~ as.factor(Type) + as.factor(Defrost) + as.factor(FreezerLoc)
        + Ratio , data = r)
summary(Sm2) # R2: 71.53
plot(Sm2)
shapiro.test(Sm2$residuals)
hist(Sm2$residuals)

# lmer without interaction
Sm3m <- lmer(AEC ~ as.factor(Brand)+as.factor(Type) + as.factor(Defrost)
             + as.factor(FreezerLoc)+ Ratio +(1|Brand), data = r)
summary(Sm3m)
plot(Sm3m)

# lmer with interaction
im2 <- lmer(AEC ~ as.factor(Brand)+as.factor(Type) + as.factor(Defrost)
            + as.factor(FreezerLoc)+ Ratio+ r$FreezerVol*as.factor(Defrost) +as.factor(DoorIce)
            +(1|Brand), data = r)
summary(im2)
plot(im2)
AIC(Sm2);AIC(Sm3m);AIC(im2) #14171,13127,12700

#Sampling and testing final model

sam1 <- r[sample(nrow(r),800, replace = TRUE),]

im2_1 <- lmer(AEC ~ as.factor(Brand)+as.factor(Type) + as.factor(Defrost)
            + as.factor(FreezerLoc)+ Ratio+ sam1$FreezerVol*as.factor(Defrost) +as.factor(DoorIce)
            +(1|Brand), data = sam1)
summary(im2_1)


#Final Model with Ratio alone

im3 <- lmer(AEC ~ as.factor(Brand)+as.factor(Type) + as.factor(Defrost)
            + as.factor(FreezerLoc)+ Ratio*as.factor(Defrost) +as.factor(DoorIce)
            +(1|Brand), data = r)

summary(im3)
  plot(im3)

#Sampling and checking

sam2 <- r[sample(nrow(r),700,replace = TRUE),]


im3_1 <- lmer(AEC ~ as.factor(Brand)+as.factor(Type) + as.factor(Defrost)
            + as.factor(FreezerLoc)+ Ratio*as.factor(Defrost) +as.factor(DoorIce)
            +(1|Brand), data = sam2)
summary(im3_1)
plot(im3_1)
