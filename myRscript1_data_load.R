#set working directory

setwd("~/datasets")

#load train dataset

train <- read.csv("~/datasets/m_titanic/train.csv")

#load test dataset

test <- read.csv("~/datasets/m_titanic/test.csv")

# viewing the "train" dataframe in raw format

train

# viewing the "train" dataframe in table format

View(train)

# dataframe structure

str(train)
