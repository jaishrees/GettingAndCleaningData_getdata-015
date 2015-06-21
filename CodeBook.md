# Getting and Cleaning Data -Course Project - CodeBook.md

---
##Code Analysis and Description
###Code Variables and Purpose
|R variable|datatype|Description/Purpose|Dimensions|
|----------|----------|----------|----------|
|subjectTrain|table|reads the data from train/subject_train.txt|7352 rows, 1 column|
|activityTrain|table|reads the data from train/y_train.txt|7352 rows, 1 column|
|featuresTrain|table|reads the data from train/x_train.txt|7352 rows, 561 columns|
|subjectTest|table|reads the data from test/subject_test.txt|2947 rows, 1 column|
|activityTest|table|reads the data from test/y_test.txt|2947 rows, 1 column|
|featuresTest|table|reads the data from test/x_test.txt|2947 rows, 561 columns|
|subjectComb|table|UNION of the sets subjectTrain and subjectTest|10299 rows, 1 column|
|activityComb|table|UNION of the sets activityTrain and activityTest|10299 rows, 1 column|
|featuresComb|table|UNION of the sets featuresTrain and featuresTest|10299 rows, 561 columns|
|featuresLbl|table|read data from features.txt, contains heading for measurements|561 rows, 1 column|
|SubActFeatCombined|table|Combined columns from subjectComb, activityComb and featuresComb|10299 rows, 563 rows|
|meanSTDcols|logical vector|Contains a subset of truth values identifying column names from table SubActFeatCombined containing mean(), std(), Subject and Activity||
|SubActFeatMeanSTD|table|Narrow Subset of SubActFeatCombined containing only columns identified by logical vector meanSTDcols|10299 rows, 81 cols|
|activityLabels|table|read data from activity_labels.txt, contains description for activity codes|6 values(1:WALKING, 2:WALKING_UPSTAIRS, 3:WALKING_DOWNSTAIRS, 4: SITTING, 5: STANDING, 6: LAYING )|
|LabelledDataSet|table|Copy of SubActFeatMeanSTD, with descriptive column names|10299 rows, 81 cols|
|TblLabelledDataSet|tbl_df|tbl_df(LabelledDataSet)||

###Code Flow - Refer to Variables list above
- 1: Merge the training and the test sets to create one data set- reads the data from train/subject_train.txt and reads the data from test/subject_test.txt and UNIONS them into a table subjectComb. Reads the data from train/y_train.txt and reads the data from test/y_test.txt and UNIONS them into activityComb. Reads the data from train/x_train.txt and reads the data from test/x_test.txt and UNIONS them into featuresComb.
```Javascript
  subjectTrain <- read.table("train//subject_train.txt", header = FALSE)
  activityTrain <- read.table("train//y_train.txt", header = FALSE)
  featuresTrain <- read.table("train//X_train.txt", header = FALSE)
  subjectTest <- read.table("test//subject_test.txt", header = FALSE)
  activityTest <- read.table("test//y_test.txt", header = FALSE)
  featuresTest <- read.table("test//X_test.txt", header = FALSE)
subjectComb <- rbind(subjectTrain,subjectTest)
activityComb <- rbind(activityTrain,activityTest)
featuresComb <- rbind(featuresTrain,featuresTest)
```

- Assign labels to ActivityComb and SubjectComb
```Javascript
names(subjectComb) <- "Subject"
names(activityComb) <- "Activity"
```
- Label the featuresComb data set with descriptive variable names from features.txt
- ```Javascript
featuresLbl <- read.table("features.txt")
names(featuresComb) <- featuresLbl$V2
```
- Combine the Subject, Activity, Features data
```Javascript
SubActFeatCombined <- cbind(subjectComb, activityComb, featuresComb)
```
- Use regular expressions grep to mark for retention only columns with "mean" and "std" and 'Subject", "Activity"
- ```Javascript
meanSTDcols <-  grepl("mean", colnames(SubActFeatCombined)) | 
                grepl("std\\(\\)", colnames(SubActFeatCombined)) |
                grepl("Subject", colnames(SubActFeatCombined)) |
                grepl("Activity", colnames(SubActFeatCombined)) 
```
- retain columns prescribed by the above step
```Javascript
SubActFeatMeanSTD <- SubActFeatCombined[, meanSTDcols]
```
- convert the activity column from integer to factor
```Javascript
activityLabels <- read.table("activity_labels.txt", header = FALSE)[,2]
SubActFeatMeanSTD$Activity <- factor(SubActFeatMeanSTD$Activity, labels=activityLabels)
```
- Transform the abbreviated column namesusing regular expressions
```Javascript
names(LabelledDataSet) <- names(LabelledDataSet) %>%
  sub("^t", "time", .) %>%            
  sub("^f", "frequency", .) %>%
  gsub("([^\\-])([A-Z])", "\\1\\_\\L\\2\\E", ., perl=TRUE) %>%
  gsub("bodybody", "body", .) %>%
  gsub("acc", "accelerometer", .) %>%  
  gsub("gyro", "gyroscope", .) %>%
  gsub("mag", "magnitude", .) %>%
  gsub("std\\(\\)", "standard_deviation", .) %>%
  gsub("mean", "mean", .) %>%
  gsub("-", "_", .)
```
- Finally do the grouping by Subject and Activity and perform aggregation
```Javascript
TblLabelledDataSet <- tbl_df(LabelledDataSet)
TblLabelledDataSet %>%
  select(Subject, Activity, contains("mean"), contains("standard_deviation")) %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean))%>%
  write.table("./tidy.txt",row.names=FALSE)
```
---

