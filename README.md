Peer-graded Assignment: Getting and Cleaning Data Course Project
---------------------------------------------------------------

##Goal

One of the most exciting areas in all of data science right now is wearable computing. Companies like *FitBit, Nike,* and *Jawbone Up* are racing to develop the most advanced algorithms to attract new users. The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
<http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The data for the project is available at:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>

The aim of the project is to clean and extract usable data from the data provided for the project and create one R script called run_analysis.R that does the following:
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


In the github repository, we will have:
- *run_analysis.R* - code run on the project data set
- *Tidy.txt* - the clean data extracted from the original data using *run_analysis.R*
- *CodeBook.md* - the CodeBook reference to the variables in *Tidy.txt*
- *README.md* - the analysis of the code in *run_analysis.R*

## Getting Started

###Fetch data locally
The R code in *run_analysis.R* works with the zip file available at <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> that has been downloaded and extracted to the assignment working directory.

###R packages used
- `data.table` for efficient handling of large data sets as tables. 
- `dplyr` to aggregate variables to create a tidy data set.

```{r, message=FALSE}
install.packages("data.table")
install.packages("dplyr")

library(data.table)
library(dplyr)
```

###Read dataset metadata into variables
The metadata in the dataset are assigned to variables `feature_labels` and `activity_labels`.
```{r}
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
feature_labels <- read.table("UCI HAR Dataset/features.txt")
```

##Format training and test data sets
The training and test datasets are split up into subjects, activities and features. 

###Read training data
```{r}
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)
```

###Read test data
```{r}
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)
```

##Part 1 - Merge the training and the test sets to create one data set
Combine the training and test datasets corresponding to subjects, activities and features.

```{r}
subjects <- rbind(subject_train, subject_test)
features <- rbind(X_train, X_test)
activities <- rbind(Y_train, Y_test)
```
###Name the columns
The columns in the data set are renamed to sensible names

```{r}
colnames(activities) <- "Activity"
colnames(features) <- t(feature_labels[2])
colnames(subjects) <- "Subject"
```

###Merge the data
The data in `features`,`activities` and `subjects` are merged and the complete data is now stored in `complete_data_set`.

```{r}
complete_data_set <- cbind(features, activities, subjects)
```

##Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
Extract the column indices that have either mean or std in them.
```{r}
mean_std_only <- grep("mean()|std()", names(complete_data_set), ignore.case=TRUE)
```

Add activity and subject columns to the list and look at the dimension of `complete_data_set` 
```{r} 
required_columns <- c(mean_std_only, 562, 563)
dim(complete_data_set)
```

We create `extract_required_data` with the selected columns in `required_columns`. And again, we look at the dimension of `required_columns`. 
```{r}
extract_required_data <- complete_data_set[, required_columns]
dim(extract_required_data)
```

##Part 3 - Uses descriptive activity names to name the activities in the data set
The `activity` field in `extract_required_data` is of numeric type. We convert its type to character so that it can accept activity names. The activity names are taken from metadata `activity_labels`.
```{r}
extract_required_data$Activity <- as.character(extract_required_data$Activity)

for (i in 1:6) {
  extract_required_data$Activity[extract_required_data$Activity == i] <- as.character(activity_labels[i,2])
}
```
Once the activity names are updated, we need to factor the `activity` variable
```{r}
extract_required_data$Activity <- as.factor(extract_required_data$Activity)
```

##Part 4 - Appropriately labels the data set with descriptive variable names
Here are the names of the variables in `extractedData` 
```{r}
names(extract_required_data)
```

We can replace the following in "extract_required_data" with sensible names:
- `^f` can be replaced with frequency
- `^t` can be replaced with time
- `Acc` can be replaced with Accelerometer
- `Gyro` can be replaced with Gyroscope
- `BodyBody` can be replaced with Body
- `Mag` can be replaced with Magnitude

```{r}
names(extract_required_data) <- gsub("^t", "time", names(extract_required_data))
names(extract_required_data) <- gsub("^f", "frequency", names(extract_required_data))
names(extract_required_data) <- gsub("Acc", "Accelerometer", names(extract_required_data))
names(extract_required_data) <- gsub("Gyro", "Gyroscope", names(extract_required_data))
names(extract_required_data) <- gsub("Mag", "Magnitude", names(extract_required_data))
names(extract_required_data) <- gsub("BodyBody", "Body", names(extract_required_data))
```

##Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
Set `Subject` as a factor variable. 
```{r}
extract_required_data$Subject <- as.factor(extract_required_data$Subject)
extract_required_data <- data.table(extract_required_data)
```

We create `tidy_data_set` data set with average for each activity and subject. 
Then, order the enties in `tidy_data_set` and write it into data file `Tidy.txt` that contains the processed data.

```{r}
tidy_data_set <- aggregate(. ~Subject + Activity, extract_required_data, mean)
tidy_data_set <- tidy_data_set[order(tidy_data_set$Subject, tidy_data_set$Activity),]
write.table(tidy_data_set, file = "Tidy.txt", row.names=FALSE)