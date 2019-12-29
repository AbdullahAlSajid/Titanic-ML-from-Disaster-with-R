#set working directory

setwd("~/datasets")

#load train dataset

train <- read.csv("~/datasets/m_titanic/train.csv")

#load test dataset

test <- read.csv("~/datasets/m_titanic/test.csv")

# viewing the "train" dataframe in raw format

train

#
test

# viewing the "train" dataframe in table format

View(train)

#
View(test)

# dataframe structure

str(train)

#
str(test)

#access survived col of train data

table(train$Survived)

#access survived col of train data with proportions

prop.table(table(train$Survived))


# Visual representation of survived in train dataset

barplot(table(train$Survived), xlab = "Survived", ylab = "People", main = "Train Data Survival")

# lets consider all died in test dataset
# create a "Survived" col in test dataset and set '0' to all observation/row for "Survived" col

test$Survived<-rep(0,418)

#create a dataframe containing 2 cols which are "PassengerId" and "Survived" from test dataset

prediction1<-data.frame(PassengerId = test$PassengerId, Survived=test$Survived)

#send the dataframe to a physical csv file

write.csv(prediction1, file = "1stprediction.csv", row.names = FALSE)

result <- read.csv("~/datasets/m_titanic/1stprediction.csv")
#read.csv("~/datasets/m_titanic/train.csv")

View(result)



















