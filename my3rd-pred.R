setwd("~/datasets/m_titanic")

train <- read.csv ("~/datasets/titanic/train.csv")

test <- read.csv("~/datasets/titanic/test.csv")

#new column Fare2 from Fare column

train$Fare2 <- "30+"
train$Fare2[train$Fare < 30 & train$Fare >= 20] <- "20-30"
train$Fare2[train$Fare < 20 & train$Fare >= 10] <- "10-20"
train$Fare2[train$Fare<10] <- "<10"

aggregate(Survived ~ Sex, data=train, FUN=sum)

aggregate(Survived ~ Sex, data=train, FUN=length)

aggregate(Survived ~ Sex, data=train, FUN=function(x) {sum(x)/length(x)})



aggregate(Survived ~ Fare2+Pclass+Sex, data=train, FUN=sum)

aggregate(Survived ~ Fare2+Pclass+Sex, data=train, FUN=length)

aggregate(Survived ~ Fare2+Pclass+Sex, data=train, FUN=function(x) {sum(x)/length(x)*100})



test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1
test$Survived[test$Sex == 'female' & test$Fare >= 20 & test$Pclass ==3] <- 0

prediction3 <- data.frame(test$PassengerId,test$Survived)

names(prediction3) <- c("PassengerId","Survived")

write.csv (prediction3, file = "3rdprediction.csv", row.names=FALSE)


