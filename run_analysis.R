install.packages("data.table")
install.packages("dplyr")

library(data.table)
library(dplyr)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", header=FALSE)
feature_labels <- read.table("./UCI HAR Dataset/features.txt")

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE)
X_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE)
Y_test <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE)
X_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE)
Y_train <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE)

#1 - Merges the training and the test sets to create one data set.
subjects <- rbind(subject_train, subject_test)
features <- rbind(X_train, X_test)
activities <- rbind(Y_train, Y_test)

colnames(activities) <- "Activity"
colnames(features) <- t(feature_labels[2])
colnames(subjects) <- "Subject"

complete_data_set <- cbind(features, activities, subjects)

#2 - Extracts only the measurements on the mean and standard deviation for each measurement.
mean_std_only <- grep("mean()|std()", names(complete_data_set), ignore.case=TRUE) 
required_columns <- c(mean_std_only, 562, 563)
dim(complete_data_set)

extract_required_data <- complete_data_set[, required_columns]
dim(extract_required_data)

#3 - Uses descriptive activity names to name the activities in the data set
extract_required_data$Activity <- as.character(extract_required_data$Activity)

for (i in 1:6) {
  extract_required_data$Activity[extract_required_data$Activity == i] <- as.character(activity_labels[i,2])
}

extract_required_data$Activity <- as.factor(extract_required_data$Activity)

#4 - Appropriately labels the data set with descriptive variable names.
names(extract_required_data) <- gsub("^t", "time", names(extract_required_data))
names(extract_required_data) <- gsub("^f", "frequency", names(extract_required_data))
names(extract_required_data) <- gsub("Acc", "Accelerometer", names(extract_required_data))
names(extract_required_data) <- gsub("Gyro", "Gyroscope", names(extract_required_data))
names(extract_required_data) <- gsub("Mag", "Magnitude", names(extract_required_data))
names(extract_required_data) <- gsub("BodyBody", "Body", names(extract_required_data))

#5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
extract_required_data$Subject <- as.factor(extract_required_data$Subject)
extract_required_data <- data.table(extract_required_data)

tidy_data_set <- aggregate(. ~Subject + Activity, extract_required_data, mean)
tidy_data_set <- tidy_data_set[order(tidy_data_set$Subject, tidy_data_set$Activity),]
write.table(tidy_data_set, file = "Tidy.txt", row.names=FALSE)




