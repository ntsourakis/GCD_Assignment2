###
# 1. Load the libraries
###

require("data.table")
require("reshape2")

###
# 2. Read the data
###

# Train data
X_train = read.table("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
Y_train = read.table("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
subject_train = read.table("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)

# Test data
X_test = read.table("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
Y_test = read.table("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
subject_test = read.table("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)

# Features
features = read.table("UCI HAR Dataset/features.txt", sep="", header=FALSE)[,2]

# Activity labels
activity_labels = read.table("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)[,2]

###
# 3. Process the data
###

# Set the names of the object. 
names(X_train) = features
names(X_test) = features

# Extract mean and standard deviation
X_train = X_train[,grepl("mean|std", features)]
X_test = X_test[,grepl("mean|std", features)]

# Load activity labels
Y_train[,2] = activity_labels[Y_train[,1]]
names(Y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

Y_test[,2] = activity_labels[Y_test[,1]]
names(Y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

###
# 4. Merge training and test data
###

alltrain = cbind(as.data.table(subject_train), X_train, Y_train)
alltest = cbind(as.data.table(subject_test), X_test, Y_test)
all = rbind(alltrain, alltest)

# Create a tidy data set that has the average of each variable for each activity and each subject.
id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(all), id_labels)
melt_data = melt(all, id = id_labels, measure.vars = data_labels)

# Apply mean function to dataset using dcast function
tidy_data = dcast(melt_data, subject + Activity_Label ~ variable, mean)

###
# 5. Save the tidy data
###

write.table(tidy_data, "tidy.txt", sep="\t")
