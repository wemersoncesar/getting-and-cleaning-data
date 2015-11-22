

require("data.table")
require("reshape2")

activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")[,2]

features <- read.table("./UCI_HAR_Dataset/features.txt")[,2]

# Extract measurements (mean and std dev).
extract_features <- grepl("mean|std", features)

# Load and process X_test & y_test data.
X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
subject_test <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

names(X_test) = features
X_test = X_test[,extract_features]

# Load labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Binding
test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Load data.
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")

subject_train <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

names(X_train) = features

X_train = X_train[,extract_features]

y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge data
data = rbind(test_data, train_data)

idlabels  <- c("subject", "Activity_ID", "Activity_Label")
data_labels <- setdiff(colnames(data), idlabels)
melt_data   <- melt(data, id = idlabels, measure.vars = data_labels)

tdata  <- dcast(melt_data, subject + Activity_Label ~ variable, mean)

#write data
write.table(tdata, file = "./tidy_data.txt")