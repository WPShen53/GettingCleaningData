## Load Library
library(dplyr)

## Load activity labels & features
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

## Load training set
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", sep = "", 
                         na.strings ="", stringsAsFactors= FALSE)

colnames(train_data) <- features

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
train_data$subject <- as.vector(train_subject[,1])

train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_labels <- as.factor(train_labels[,1])
levels(train_labels) <- labels
train_data$label <- train_labels

col_vector <- grep("subject|label|mean|Mean|std", names(train_data))
train_data <- train_data[,col_vector]


## Load testing set 
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", sep = "" , header = F , 
                        na.strings ="", stringsAsFactors= F)

colnames(test_data) <- features

test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_data$subject <- as.vector(test_subject[,1])

test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_labels <- as.factor(test_labels[,1])
levels(test_labels) <- labels
test_data$label <- test_labels

col_vector <- grep("subject|label|mean|Mean|std", names(test_data))
test_data <- test_data[,col_vector]


## merge testing and training dataset
total <- rbind(train_data, test_data)

## create a tidy average dataset
avg <- total %>% group_by(subject, label) %>% summarise_each(funs(mean))

### write to a text file
write.table(avg, file = "w4_tidy_avg_dataset.txt", sep = ",", row.name = FALSE)

