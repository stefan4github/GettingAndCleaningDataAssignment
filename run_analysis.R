#Check if a Data directory exists. If not, create one
if (!file.exists("./Data")) {dir.create("./Data")}

#The zip file provided with the instructions
zipFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#Create a temporary file
tempZipFile <- tempfile()

#Download the zip file into the temporary zip file
download.file(zipFile, tempZipFile)

#Unzip the contents of the temporry zip file
unzip(tempZipFile, exdir="Data")

#Delete the temporary zip file
unlink(tempZipFile)

#Read data from all provided relevant files into datasets
XTest <- read.table("Data/UCI HAR Dataset/test/X_test.txt", sep = "", header = FALSE) 
YTest <- read.table("Data/UCI HAR Dataset/test/Y_test.txt", sep = "", header = FALSE) 
SubjectTest <- read.table("Data/UCI HAR Dataset/test/subject_test.txt", sep = "", header = FALSE) 
XTrain <- read.table("Data/UCI HAR Dataset/train/X_train.txt", sep = "", header = FALSE) 
YTrain <- read.table("Data/UCI HAR Dataset/train/Y_train.txt", sep = "", header = FALSE) 
SubjectTrain <- read.table("Data/UCI HAR Dataset/train/subject_train.txt", sep = "", header = FALSE) 

#Merge dataframes by test, train and subject description
xMerged <- rbind(XTest, XTrain)
yMerged <- rbind(YTest, YTrain)
subjectMerged <- rbind(SubjectTest, SubjectTrain)

#Merge all sets into one
finalSet <- cbind(xMerged, yMerged, subjectMerged)

#Get activities and associated labels
activityLabels <- read.table("Data/UCI HAR Dataset/activity_labels.txt", sep = "", header = FALSE)
features <- read.table("Data/UCI HAR Dataset/features.txt", sep = "", header = FALSE )

#Set appropiate variables' names
names(xMerged) <- as.character(features[,2])
names(yMerged) <- "ActivityCode"
names(subjectMerged) <- "SubjectCode"
names(activityLabels) <- c("V1","ActivityDescription")

#Substitute initial IDs with the actual activity name
activityNames <- merge(finalSet, activityLabels, by.x = "Activity", by.y = "V1")

#Filter only on the mean and standard deviation measurements, and get values for each measurement
meanAndStandardDev <- activityNames[,names(activityNames[,grep("mean|std", names(activityNames))])]

#Create a tidy data set. Specify average of each variable
tidySet <- aggregate(meanAndStandardDev, by = list(activityNames$ActivityDescription,activityNames$Subject),mean)

#Replace variables' names as were specify by the aggregate function
names(tidySet) <- c("ActivityDescription","SubjectCode",names(meanAndStandardDev))

#Transfer the tidy set to a comma (,) delimited text file
write.table(tidySet, file = "TempTidyData.txt", sep = ",", row.names = FALSE)

#Convert the tidy set into a csv file
write.csv(activityNames, file = "TidySet.csv", row.names = FALSE)