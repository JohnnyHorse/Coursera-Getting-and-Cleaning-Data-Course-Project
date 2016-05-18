setwd("C:/Users/Johnny/Desktop/lol/Coursera/data")
filename <- "data.zip"
## Download and unzip the dataset:
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}
unzip(filename)

#1.Merges the training and the test sets to create one data set.
#train
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
#test
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# merges the x data set
x_data <- rbind(x_train, x_test)

# merges the x data set
y_data <- rbind(y_train, y_test)

# merges the subject data set
subject_data <- rbind(subject_train, subject_test)


#2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("UCI HAR Dataset/features.txt")

mean_std <- grep("-(mean|std)\\(\\)", features[, 2])

x_data_mod <- x_data[,mean_std]
colnames(x_data_mod)=features[mean_std, 2]

#3.Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# correct activity names & column name
y_data = subset(merge(y_data,activities,select="V2"),select = c(V2))
colnames(y_data)="activity"


#4.Appropriately labels the data set with descriptive variable names.
#correct subject names
colnames(subject_data) <- "subject"
#merges all together
all_data <- cbind(x_data_mod, y_data, subject_data)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyData    = aggregate(all_data[,names(all_data) != c('activity','subject')],by=list(activityId=all_data$activity,subjectId = all_data$subject),mean);
# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE)
