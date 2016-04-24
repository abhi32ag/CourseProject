# step1 - Merging the training and testing data

# training data
trainData <- read.table("./train/X_train.txt")
trainLabel <- read.csv("./train/y_train.txt", sep= " ",header = F)

trainSubject <- read.table("./train/subject_train.txt")

# testing data
testData <- read.table("./test/X_test.txt")
testLabel <- read.csv("./test/y_test.txt", sep= " ",header = F)

testSubject <- read.table("./test/subject_test.txt")

# merged data
mergedData <- rbind(trainData,testData)
mergedLabel <- rbind(trainLabel,testLabel)
mergedSubject <- rbind(trainSubject,testSubject)


# step2 - Extracting measurements on mean and standard deviation

features <- read.table("./features.txt")
meanStdIndices <- grep("mean\\(\\)|std\\(\\)",features[,2])
mergedData <- mergedData[, meanStdIndices]
names(mergedData) <- gsub("\\(\\)","",features[meanStdIndices, 2]) # adding names to feaures in Data
names(mergedData) <- gsub("-","",names(mergedData)) # removes "-"
names(mergedData) <- gsub("mean","Mean",names(mergedData)) # replaces mean with Mean
names(mergedData) <- gsub("std","Std",names(mergedData)) # replaces std with Std


# step3 - Use descriptive activity name to name activites in data set

activity <- read.table("./activity_labels.txt")
activity[,2] <- tolower(gsub("_","",activity[, 2]))
substr(activity[2,2],8,8) <- toupper(substr(activity[2,2],8,8)) # captilize "U" in Upstairs
substr(activity[3,2],8,8) <- toupper(substr(activity[3,2],8,8)) # captilize "D" in Downstairs
activityLabel <- activity[mergedLabel[,1], 2]
mergedLabel[,1] <- activityLabel
names(mergedLabel) <- "activity"


# step4 - Label data set with descriptive variable names

names(mergedSubject) <- "subject"
tidyData <- cbind(mergedSubject,mergedLabel,mergedData)
write.table(tidyData,"merged_data.txt") # writes cleaned dataset

# step5 - Independent data set with average for each variable for each activity for each subject

sLen <- length(table(mergedSubject))
aLen <- dim(activity)[1]
fLen <- dim(tidyData)[2]

result <- matrix(NA,nrow =sLen*aLen, ncol = fLen )
result <- as.data.frame(result)
colnames(result) <- colnames(tidyData)
r <- 1

for(i in 1:sLen) {
    for(j in 1:aLen) {
        result[r, 1] <- sort(unique(mergedSubject)[, 1])[i]
        result[r, 2] <- activity[j, 2]
        b1 <- i == tidyData$subject
        b2 <- activity[j, 2] == tidyData$activity
        result[r, 3:fLen] <- colMeans(tidyData[b1&b2, 3:fLen])
        r <- r + 1
    }
}
write.table(result, "data_with_means.txt")

