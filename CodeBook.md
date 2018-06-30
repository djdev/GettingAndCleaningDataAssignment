CodeBook
---------------------------------------------------------------
A document that describes the variables in *Tidy.txt* and data and transofrmations used by *run_analysis.R*.

##Dataset Used
This data for the above analysis and transformations is acquired from "Human Activity Recognition Using Smartphones Data Set". 

The data linked are collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>.

The data set for the project was downloaded from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>. 

##Project Input Dataset Contents
The input data contains the following files:

- `X_train.txt` Training set.
- `y_train.txt` Training labels corresponding to `X_train.txt`.
- `subject_train.txt` Information of subjects from whom data is collected.
- `X_test.txt` Test set.
- `y_test.txt` Test labels corresponding to `X_test.txt`.
- `subject_test.txt` Information of subjects from whom data is collected.
- `activity_labels.txt` Links the class labels with their activity name.
- `features.txt` List of all features.

##Input Dataset Transformations
Following transformations were performed on the project dataset:

- `X_train.txt` is read into `X_train`.
- `y_train.txt` is read into `Y_train`.
- `subject_train.txt` is read into `subject_train`.
- `X_test.txt` is read into `X_test`.
- `y_test.txt` is read into `Y_test`.
- `subject_test.txt` is read into `subject_test`.
- `features.txt` is read into `feature_labels`.
- `activity_labels.txt` is read into `activity_labels`.
- The subjects in training and test set are merged into `subjects`.
- The activities in training and test set are merged into `activities`.
- The features of test and training are merged into `features`.
- The name of the features are set in `features` from `feature_labels`.
- `subjects`, `activities` and `features` are merged into `complete_data_set`.
- Indices of columns that contain std or mean, activities and subjects are extracted into `required_columns` .
- `extract_required_data` is created from column data in `required_columns`.
- Short variable names in `extract_required_data` such as '^t',  '^f', 'Acc', 'Gyro', 'Mag', and 'BodyBody' are renamed as descriptive labels such as 'Time', 'Frequency', 'Accelerometer', 'Gyroscope', 'Magnitude' and 'Body'.
- `tidy_data_set` is created as a set with average for each activity and subject of `extract_required_data`.
- The data in `tidy_data_set` is outputted into `Tidy.txt`.

##Output Data Set
`Tidy.txt` is a space-delimited file. The header line contains the names of the variables. It also contains the mean and standard deviation values of the data found in the input files.
