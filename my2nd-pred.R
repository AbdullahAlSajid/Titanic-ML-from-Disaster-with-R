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

#access sex col of train data

table(train$Sex)

#access survived col of train data with proportions

prop.table(table(train$Sex,train$Survived))

#access survived col of train data with proportions with  dimension '1'

prop.table(table(train$Sex,train$Survived),1)

# Visual representation of sex in train dataset

barplot(table(train$Sex), xlab = "Passenger", ylab = "People", main = "Train Data Passenger")

# lets consider all women survived in test dataset
# In test dataset and set '0' to all observation/row for "Survived" col and then set '1' for all the women

test$Survived <- 0
test$Survived[test$Sex == 'female'] <- 1

#create a dataframe containing 2 cols which are "PassengerId" and "Survived" from test dataset

prediction2<-data.frame(PassengerId = test$PassengerId, Survived=test$Survived)

#send the dataframe to a physical csv file

write.csv(prediction2, file = "2ndprediction.csv", row.names = FALSE)





















