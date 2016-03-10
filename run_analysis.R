## Load Library
library(dplyr)

## Load activity labels & features
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

## Load training set
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", 
                         na.strings ="", stringsAsFactors= FALSE)

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_data$subject <- as.vector(train_subject[,1])

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_data$activity <- as.factor(train_labels[,1])

## Load testing set 
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "" , header = F , 
                        na.strings ="", stringsAsFactors= F)

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data$subject <- as.vector(test_subject[,1])

test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_data$activity <- as.factor(test_labels[,1])

## 1. Merges the training and the test sets to create one data set.
total <- rbind(train_data, test_data)
colnames(total) <- features

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
col_vector <- grep("subject|activity|mean|Mean|std", names(total))
total <- total[,col_vector]

## 3. Uses descriptive activity names to name the activities in the data set
levels(total$activity) <- activities

## 4. Appropriately labels the data set with descriptive variable names. (was done in Step 1)

## 5. creates a tidy data set with the average of each variable for each activity and each subject.
avg <- total %>% group_by(subject, label) %>% summarise_each(funs(mean))

### write to a text file
write.table(avg, file = "w4_tidy_avg_dataset.txt", sep = ",", row.name = FALSE)

