if (!require("data.table")) {
  install.packages("data.table")
}
require("data.table")

fileName = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileName, 'data.zip', method = 'curl')
unzip('data.zip')

# Get Activity Labels
activity_labels = read.table("./UCI HAR Dataset//activity_labels.txt")

# Get column names
column_names = read.table("./UCI HAR Dataset//features.txt")

# Load Test data
x_test = read.table("./UCI HAR Dataset//test//X_test.txt",header=FALSE)
y_test = read.table("./UCI HAR Dataset//test//y_test.txt",header=FALSE)
subject_test = read.table("./UCI HAR Dataset//test//subject_test.txt",header=FALSE)

#Column Names and extract for Test Data
colnames(x_test) = column_names$V2
colnames(y_test) = ("Activity")
colnames(subject_test) = ("Subject")



# Load Train data
x_train = read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
y_train = read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
subject_train = read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

#Column Names and extract for Train Data
colnames(x_train) = column_names$V2
colnames(y_train) = ("Activity")
colnames(subject_train) = ("Subject")



# Merge Data
x_test = cbind(x_test,y_test)
x_test = cbind(x_test,subject_test)
x_train = cbind(x_train,y_train)
x_train = cbind(x_train,subject_train)
big_data = rbind(x_test, x_train)

# Extract Mean and SD
big_data_mean = sapply(big_data, mean, na.rm=TRUE)
big_data_sd = sapply(big_data, sd, na.rm=TRUE)

# Tidy Data
data_table = data.table(big_data)
tidy_data = data_table[, lapply(.SD,mean), by='Activity,Subject']
write.table(tidy_data,file="tidy_data.csv",sep=",",row.names = FALSE)