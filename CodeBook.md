#Getting and Cleaning Data - Project - CodeBook
##Analysis
<ul>
<li><code>X_train.txt</code> contains variable features that are intended for training.</li>
<li><code>y_train.txt</code> contains the activities corresponding to <code>X_train.txt</code>.</li>
<li><code>subject_train.txt</code> contains information on the subjects from whom data is collected.</li>
<li><code>X_test.txt</code> contains variable features that are intended for testing.</li>
<li><code>y_test.txt</code> contains the activities corresponding to <code>X_test.txt</code>.</li>
<li><code>subject_test.txt</code> contains information on the subjects from whom data is collected.</li>
<li><code>activity_labels.txt</code> contains metadata on the different types of activities.</li>
<li><code>features.txt</code> contains the name of the features in the data sets.</li>
</ul>

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
