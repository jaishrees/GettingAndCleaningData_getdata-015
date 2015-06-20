#Getting and Cleaning Data - Project - CodeBook
##Analysis

##Variables used in Code
##Transformations of Data Columns
Here are the transformations performed on data columns for features
"^t" -> "time"
"^f"-> "frequency"
regular expression "([^\\-])([A-Z])", "\\1\\_\\L\\2\\E", ., perl=TRUE) 
"body_body" -> "body"
"acc"-> "accelerometer"
"gyro"-> "gyroscope"
"mag"-> "magnitude"
"std\\(\\)"-> "standard_deviation"
"mean\\(\\)"-> "mean"
"-"-> "_"
