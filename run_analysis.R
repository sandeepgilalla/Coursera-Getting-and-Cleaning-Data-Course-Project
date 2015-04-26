library(plyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################
path_rf <- file.path("/Users/Gilalla/Desktop/Data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)

x_train <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)
y_train <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)

subject_train <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)

x_test <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
y_test <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)

subject_test <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

# create 'x' data set
x_data <- rbind(x_train, x_test)

# create 'y' data set
y_data <- rbind(y_train, y_test)

# create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
# get only columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the desired columns
x_data <- x_data[, mean_and_std_features]

# correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

# update values with correct activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# correct column name
names(y_data) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name
names(subject_data) <- "subject"

# bind all the data in a single data set
all_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

# 66 <- 68 columns but last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "averages_data.txt", row.name=FALSE)