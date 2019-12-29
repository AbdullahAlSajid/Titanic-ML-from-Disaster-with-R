setwd("~/datasets/m_titanic")
train <- read.csv("~/datasets/m_titanic/train.csv")
test <- read.csv("~/datasets/m_titanic/test.csv")

library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)
mytree1 <- rpart(Survived ~ Sex, data = train, method = "class")
fancyRpartPlot(mytree1)

mytree2 <- rpart(Survived ~ Pclass+Age, data = train, method = "class")
fancyRpartPlot(mytree2)


mytree3 <- rpart(Survived ~ Pclass+Sex+Age+SibSp+Parch+Fare+Embarked, data = train, method = "class")
fancyRpartPlot(mytree3)


prediction4th <- predict(mytree3, test, type = "class")
prediction4 <- data.frame(PassengerId = test$PassengerId, Survived = prediction4th)

write.csv (prediction4, file = "4thprediction.csv", row.names=FALSE)
