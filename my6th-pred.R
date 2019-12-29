setwd("~/datasets/m_titanic")
train <- read.csv("~/datasets/m_titanic/train.csv")
test <- read.csv("~/datasets/m_titanic/test.csv")

library(rpart)

# Join together the test and train sets for easier feature engineering
test$Survived <- NA
combined_set <- rbind(train, test)
View(combined_set)
View(test)


#changing Data type of Name from factor to character
combined_set$Name <- as.character(combined_set$Name)


#finding child passengers
combined_set$Child[combined_set$Age <14] <- "Child"
combined_set$Child[combined_set$Age >= 14] <- "Adult"

table(combined_set$Child, combined_set$Survived)

combined_set$Child <- factor(combined_set$Child)


#finding mother
combined_set$Mother <- "Not Mother"
combined_set$Mother[combined_set$Sex == "female" & combined_set$Age > 18 & combined_set$Parch > 0] <- "Mother"

table(combined_set$Mother, combined_set$Survived)
combined_set$Mother <- factor(combined_set$Mother)


#Title feature
#test
train$Name[1]
strsplit(combined_set$Name[1], split = '[,.]')
strsplit(combined_set$Name[1], split = '[,.]')[[1]]
strsplit(combined_set$Name[1], split = '[,.]')[[1]][2]

#new Title column
combined_set$Title <- sapply(combined_set$Name, FUN = function(x){strsplit(x,split = '[,.]')[[1]][2]})
combined_set$Title <- sub(' ','',combined_set$Title)
View(combined_set$Title)
table(combined_set$Title)

#combining title
combined_set$Title[combined_set$Title %in% c('Mme','Mlle')] <- 'Mlle'
combined_set$Title[combined_set$Title %in% c('Capt','Don','Major','Sir')] <- 'Sir'
combined_set$Title[combined_set$Title %in% c('Dona','Lady','theCountess','Jonkheer')] <- 'Lady'
combined_set$Title <- factor(combined_set$Title)

#updating Mother col depending on Title col
combined_set$Mother[combined_set$Sex == "female" & combined_set$Age > 18 & combined_set$Parch > 0 & combined_set$Title != 'Miss'] <- "Mother"


#Cabin & Deck
combined_set$Cabin <- as.character(combined_set$Cabin)
strsplit(combined_set$Cabin[2],NULL)[[1]]
combined_set$Deck <- factor(sapply(combined_set$Cabin,function(x){strsplit(x,NULL)[[1]][1]}))
View(combined_set$Surname)


#Fare Category
combined_set$Fare_type[combined_set$Fare <= 50] <- "low"
combined_set$Fare_type[combined_set$Fare >50 & combined_set$Fare <=100] <- "med1"
combined_set$Fare_type[combined_set$Fare >100 & combined_set$Fare <=150] <- "med2"
combined_set$Fare_type[combined_set$Fare >150 & combined_set$Fare <=500] <- "high"
combined_set$Fare_type[combined_set$Fare >500] <- "vhigh"
table(combined_set$Fare_type, combined_set$Survived)
aggregate(Survived~Fare_type, data = combined_set, mean)


######  Family Members
#Family Size
combined_set$FamilySize <- combined_set$SibSp + combined_set$Parch + 1

#Family Surname
combined_set$Surname <- sapply(combined_set$Name, FUN = function(x){strsplit(x, split = '[,.]')[[1]][1]})

#FamilyID
combined_set$FamilyID <- paste(as.character(combined_set$FamilySize), combined_set$Surname, sep = "")

combined_set$FamilyID[combined_set$FamilySize <= 2] <- "Small"

#Family Size Group
combined_set$FamilySizeGroup[combined_set$FamilySize == 1] <- 'single' 
combined_set$FamilySizeGroup[combined_set$FamilySize > 1 & combined_set$FamilySize <= 4] <- 'smaller'
combined_set$FamilySizeGroup[combined_set$FamilySize >= 5 ] <- 'large' 

table(combined_set$FamilySizeGroup, combined_set$Survived)

mosaicplot(table(combined_set$FamilySizeGroup, combined_set$Survived), main = 'Survival affected by Family Size', shade = TRUE)

table(combined_set$FamilyID)
table(combined_set$FamilySizeGroup)

View(combined_set$Name[combined_set$FamilyID == "6Skoog"])

#factoring
combined_set$FamilyID <- factor(combined_set$FamilyID)
combined_set$FamilySizeGroup <- factor(combined_set$FamilySizeGroup)


#Filling NA AGEs
summary(combined_set$Age)

Fillage <- rpart(Age~Pclass+Mother+FamilySize+Sex+SibSp+Parch+Deck+Fare+Embarked+Title+FamilyID+FamilySize+FamilySizeGroup, data = combined_set[!is.na(combined_set$Age),], method = "anova")
combined_set$Age[is.na(combined_set$Age)] <- predict(Fillage,combined_set[is.na(combined_set$Age),])

summary(combined_set)


#Filling NA Embarkes
summary(combined_set$Embarked)
which(combined_set$Embarked == '')
combined_set$Embarked[c(62,830)] = "S"
combined_set$Embarked <- factor(combined_set$Embarked)


#Filling NA Fares
summary(combined_set$Fare)
which(is.na(combined_set$Fare))
combined_set$Fare[1044] = median(combined_set$Fare,na.rm = TRUE)
combined_set$Embarked <- factor(combined_set$Embarked)

library(mice)
library(lattice)
md.pattern(combined_set)


#Splitting Train & Test Data
train <- combined_set[1:891,]
test <- combined_set[892:1309,]
fit <- rpart(Survived ~ Pclass+Sex+Age+SibSp+Parch+Fare+Embarked+Title+FamilySize+FamilySizeGroup+FamilyID, data = train, method = "class")
library(rattle)
library(RColorBrewer)
fancyRpartPlot(Fillage)

#Prediction
prediction6 <- predict(fit,test,type = "class")
submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction6)
write.csv(submit, file = "6thprediction.csv",row.names = FALSE)
