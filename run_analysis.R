#You should create one R script called run_analysis.R that does the following. 
#1: Merges the training and the test sets to create one data set.
#2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#3: Uses descriptive activity names to name the activities in the data set
#4: Appropriately labels the data set with descriptive variable names. 
#5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#setwd("E:\\Jaishree\\Coursera\\3-GettingAndCleaningData\\PROJECT-40Percent\\ProjectZipData\\UCI HAR Dataset\\")
#source("..\\..\\..\\GettingAndCleaningData_getdata-015\\run_analysis.R")
library(dplyr)

#########################################################################################
#1: Merges the training and the test sets to create one data set.
#########################################################################################
#Read in Training Data
  subjectTrain <- read.table("train//subject_train.txt", header = FALSE)
# dim(subjectTrain) #7352 1
# names(subjectTrain) #"V1"
# head(subjectTrain)

  activityTrain <- read.table("train//y_train.txt", header = FALSE)
# dim(activityTrain) #7352 1
# names(activityTrain)#"V1"
# activityTrain

  featuresTrain <- read.table("train//X_train.txt", header = FALSE)
# dim(featuresTrain)#7352 561
# names(featuresTrain)

#Read in Test Data
  subjectTest <- read.table("test//subject_test.txt", header = FALSE)
# dim(subjectTest) #2947 1
# names(subjectTest) #"V1"
# head(subjectTest)

  activityTest <- read.table("test//y_test.txt", header = FALSE)
# dim(activityTest) #2947 1
# names(activityTest)#"V1"
# activityTest

  featuresTest <- read.table("test//X_test.txt", header = FALSE)
# dim(featuresTest)#2947 561
# names(featuresTest)
# featuresTest[1:5]

# Now Combine the Train and Test data
subjectComb <- rbind(subjectTrain,subjectTest)
activityComb <- rbind(activityTrain,activityTest)
featuresComb <- rbind(featuresTrain,featuresTest)


#Assign subject data label
names(subjectComb) <- "Subject"

#Assign subject data label
names(activityComb) <- "Activity"
head(activityComb)

#Assign features attributes data labels
featuresLbl <- read.table("features.txt")

names(featuresComb) <- featuresLbl$V2 #4: Appropriately labels the data set with descriptive variable names. 


# Now Combine the Subject, Activity, Features data
SubActFeatCombined <- cbind(subjectComb, activityComb, featuresComb)

#Make this a Table
#SubActFeatCombinedTbl <- tbl_df(SubActFeatCombined)



#########################################################################################
#2: Extracts only the measurements on the mean and standard deviation for each measurement. 
#########################################################################################
# Use regular expressions grep to mark for retention only columns with "mean" and "std" and 'Subject", "Activity"
meanSTDcols <-  grepl("mean\\(\\)", colnames(SubActFeatCombined)) | 
                grepl("std\\(\\)", colnames(SubActFeatCombined)) |
                grepl("Subject", colnames(SubActFeatCombined)) |
                grepl("Activity", colnames(SubActFeatCombined)) 
  

# retain necessary columns
SubActFeatCombined <- SubActFeatCombined[, meanSTDcols]



#########################################################################################
#3: Uses descriptive activity names to name the activities in the data set
#########################################################################################
# convert the activity column from integer to factor
activityLabels <- read.table("activity_labels.txt", header = FALSE)[,2]

# use factor function to map the activity code to the label in activity_labels.txt
SubActFeatCombined$Activity <- factor(SubActFeatCombined$Activity, labels=activityLabels)
                                         
#########################################################################################
#4: Appropriately labels the data set with descriptive variable names. 
#########################################################################################
#This step done above
LabelledDataSet <- SubActFeatCombined

#Now tranform the abbreviated column naames
names(LabelledDataSet) <- names(LabelledDataSet) %>%
  sub("^t", "time", .) %>%            
  sub("^f", "frequency", .) %>%
  gsub("([^\\-])([A-Z])", "\\1\\_\\L\\2\\E", ., perl=TRUE) %>%
  gsub("body_body", "body", .) %>%
  gsub("acc", "accelerometer", .) %>%  
  gsub("gyro", "gyroscope", .) %>%
  gsub("mag", "magnitude", .) %>%
  gsub("std\\(\\)", "standard_deviation", .) %>%
  gsub("mean\\(\\)", "mean", .) %>%
  gsub("-", "_", .)


#########################################################################################
#5: From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.
#########################################################################################

#Make this a Table
TblLabelledDataSet <- tbl_df(LabelledDataSet)


# summarize
TblLabelledDataSet %>%
  select(Subject, Activity, contains("mean"), contains("standard_deviation")) %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean))%>%
  write.table("./tidy.txt",row.names=FALSE)

