## CheckDataFiles does a quick sanity check on the assumptions made by
## the program about the location of the data files relative to the script
## location.
CheckDatafiles <- function() {
  if(!file.exists("UCI HAR Dataset")) {
    stop("UCI HAR Hataset directory not found")
  }
  if(!file.exists("UCI\ HAR\ Dataset/test")) {
    stop("test subdirectory not found")
  }
  if(!file.exists("UCI\ HAR\ Dataset/trainw")) {
    stop("train subdirectory not found")
  }
}

## ReadTrainingData reads the training feature vector, label, and sensor data
## files and combines them into a single table, returning the combined
## table, combined in order subject id, label, sensor data.
ReadTrainingData <- function() {
  t_x <- read.table("UCI\ HAR\ Dataset/train/X_train.txt", header=0)
  t_y <- read.table("UCI\ HAR\ Dataset/train/y_train.txt", header=0)
  t_s <- read.table("UCI\ HAR\ Dataset/train/subject_train.txt", header=0)
  cbind(t_s, t_y, t_x)
}


## ReadTestData reads the test feature vector, label, and sensor data
## files and combines them into a single table, returning the combined
## table, combined in order subject id, label, sensor data.
ReadTestData <- function() {
  t_x <- read.table("UCI\ HAR\ Dataset/test/X_test.txt", header=0)
  t_y <- read.table("UCI\ HAR\ Dataset/test/y_test.txt", header=0)
  t_s <- read.table("UCI\ HAR\ Dataset/test/subject_test.txt", header=0)
  cbind(t_s, t_y, t_x)
}

## ReadFeatures reads the features from features.txt
ReadFeatures <- function() {
  features <- read.csv("UCI\ HAR\ Dataset/features.txt",header=0,sep=" ")
  features
}

## CombineTrainingAndTestSets combines the training and test sets, and names the
## variables using the features and subject_id and label
CombineTrainingAndTestSets <- function() {
  # Read and combine test and training data
  trainingData <- ReadTrainingData()
  testData <- ReadTestData()
  combined <- rbind(trainingData, testData)
  
  # Read features and add subject-id and activity label
  features <- ReadFeatures()
  varNames <- c("subject-id", "label",as.vector(features[,2]))
  
  # Name the variabled and return the data set
  names(combined) <- varNames
  combined
}