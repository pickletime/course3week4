#this makes my life easier, so i tend to do it.
ancestral_wd <- getwd()
setwd("./course3.week4.assignment")
current_wd <- getwd()

#standard test for file, download, etc.
if(!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "data.zip"); unzip(zipfile = "data.zip")



#Req'd packages - easiest to force this before i can forget to do it later
library(plyr)
library(dplyr)
library(data.table)


#read labels in first so i can assign them later
var_labels <- fread("./UCI HAR Dataset/features.txt")
var_vector <- var_labels$V2

#data in and useful. plus labelled. That's what i'm telling myself at least.
testdata <- fread("./UCI HAR Dataset/test/X_test.txt", 
                  col.names = var_vector)
testlabs <- fread("./UCI HAR Dataset/test/y_test.txt", 
                  col.names = "exercise_type")
testsubject <-fread("./UCI HAR Dataset/test/subject_test.txt", 
                    col.names = "ind_id")
traindata <- fread("./UCI HAR Dataset/train/X_train.txt", 
                   col.names = var_vector)
trainlabs <- fread("./UCI HAR Dataset/train/y_train.txt", 
                   col.names = "exercise_type")
trainsubject <-fread("./UCI HAR Dataset/train/subject_train.txt", 
                     col.names = "ind_id")


#add the exercise type into frames
testdata$exercise_type = testlabs
traindata$exercise_type = trainlabs

#add subject ID into frames
testdata$ind_ID = testsubject
traindata$ind_ID = trainsubject


#the merge that's not a merge at all
merged_data <- rbind(testdata,traindata)

#testing for relevant naming patterns, producing final dataset
merged_data_names <- names(merged_data)
desiredvarnames <- (grepl("exercise_type", merged_data_names)
                    | grepl("ind_ID", merged_data_names)
                    | grepl("std", merged_data_names)
                    | grepl("mean[^Freq]", merged_data_names))
                  #meanFreq != mean, so i'm pulling that specific one out
final_data <- merged_data[,desiredvarnames==TRUE, with = FALSE]

#cleaning variable names:
names(final_data) <- gsub("^t", "time", names(final_data))
names(final_data) <- gsub("^f", "frequency", names(final_data))
names(final_data) <- gsub("Acc", "Accelerometer", names(final_data))
names(final_data) <- gsub("Gyro", "Gyroscope", names(final_data))
names(final_data) <- gsub("Mag", "Magnitude", names(final_data))
names(final_data) <- gsub("BodyBody", "Body", names(final_data))

#Recoding exercise type:
final_data$exercise_type[final_data$exercise_type == 1] <- "Walking"
final_data$exercise_type[final_data$exercise_type == 2] <- "Walking upstairs"
final_data$exercise_type[final_data$exercise_type == 3] <- "Walking downstairs"
final_data$exercise_type[final_data$exercise_type == 4] <- "Sitting"
final_data$exercise_type[final_data$exercise_type == 5] <- "Standing"
final_data$exercise_type[final_data$exercise_type == 6] <- "Laying"

#constructing output table
tidy_output <- aggregate(. ~exercise_type + ind_ID, final_data, mean)

#outputting output table
write.table(tidy_output, file = "tidy_table_output.txt", row.names = FALSE)

setwd(ancestral_wd)
