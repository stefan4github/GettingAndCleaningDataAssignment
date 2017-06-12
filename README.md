 The following script was developed  in order to address the assignment\'92s requirements:
 Merge the training and the test sets to create one data set.\
Extract only the measurements on the mean and standard deviation for each measurement. \
Uses descriptive activity names to name the activities in the data set\
Appropriately label the data set with descriptive variable names. \
From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
 In addition, each line of script includes a comment describing the specific functionality:\
\
Step 1: Check if a Data directory exists. If not, create one\
if (!file.exists("./Data")) \{dir.create("./Data")\}\
\
Step 2: The zip file provided with the instructions\
zipFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"\
\
Step 3: Create a temporary file\
tempZipFile <- tempfile()\
\
Step 4: Download the zip file into the temporary zip file\
download.file(zipFile, tempZipFile)\
\
Step 5: Unzip the contents of the temporary zip file\
unzip(tempZipFile, exdir="Data")\
\
Step 6: Delete the temporary zip file\
unlink(tempZipFile)\
\
Step 7: Read data from all provided relevant files into datasets\
XTest <- read.table("Data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE) \
YTest <- read.table("Data/UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE) \
SubjectTest <- read.table("Data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE) \
XTrain <- read.table("Data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE) \
YTrain <- read.table("Data/UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE) \
SubjectTrain <- read.table("Data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE) \
\
Step 8: Merge dataframes by test, train and subject description\
xMerged <- rbind(XTest, XTrain)\
yMerged <- rbind(YTest, YTrain)\
subjectMerged <- rbind(SubjectTest, SubjectTrain)\
\
Step 9: Merge all sets into one\
finalSet <- cbind(xMerged, yMerged, subjectMerged)\
\
Step 10: Get activities and associated labels\
activityLabels <- read.table("Data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)\
features <- read.table("Data/UCI HAR Dataset/features.txt", sep = "", header = FALSE )\
\
#Step11: Set appropriate variables' names\
names(xMerged) <- as.character(features[,2])\
names(yMerged) <- "ActivityCode"\
names(subjectMerged) <- "SubjectCode"\
names(activityLabels) <- c("V1","ActivityDescription")\
\
Step 12: Substitute initial IDs with the actual activity name\
activityNames <- merge(finalSet, activityLabels, by.x = "Activity", by.y = "V1")\
\
Step 13: Filter only on the mean and standard deviation measurements, and get values for each measurement\
meanAndStandardDev <- activityNames[,names(activityNames[,grep("mean|std", names(activityNames))])]\
\
Step 14: Create a tidy data set. Specify average of each variable\
tidySet <- aggregate(meanAndStandardDev, by = list(activityNames$ActivityDescription,activityNames$Subject),mean)\
\
Step 15: Replace variables' names as were specify by the aggregate function\
names(tidySet) <- c("ActivityDescription","SubjectCode",names(meanAndStandardDev))\
\
Step 16: Transfer the tidy set to a comma (,) delimited text file\
write.table(tidySet, file = "TempTidyData.txt", sep = ",", row.names = FALSE)\
\
Step 17: Convert the tidy set into a csv file\
write.csv(activityNames, file = "TidySet.csv", row.names = FALSE)}