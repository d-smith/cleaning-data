## run_analysis - implementation of the class project project for the 
## Coursera Getting and Cleaning Data course.
run_analysis <- function() {
  # Check basic data file setup
  CheckDatafiles()
  
  # Load plyr
  library("dplyr")
  
  # Combine the test and training sets, labeling the variables using the features
  # provided with the dataset, extracting the features of interest to the project.
  combined <- CombineTrainingAndTestSets()
  
  # Summarize the data, and label the summarized data
  summarized <- ProduceSummarizedData(combined)
  summarized <- LabelSummarizedData(summarized)
  
  summarized
}

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
  if(!file.exists("UCI\ HAR\ Dataset/train")) {
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

## Int2Label returns a readable activity label based on the numeric encoding of
## the label. The lables and the integer value to readable label mapping is
## taken from the activity_labels.txt from the dataset.
Int2Label <- function(v) {
  label <- "unknown"
  if(v == 1) {
    label <- "WALKING"
  } else if(v == 2) {
    label <- "WALKING_UPSTAIRS"
  } else if(v == 3) {
    label <- "WALKING_DOWNSTAIRS"
  } else if(v == 4) {
    label <- "SITTING"
  } else if(v == 5) {
    label <- "STANDING"
  } else if(v == 6) {
    label <- "LAYING"
  }
  label
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
  
  # Name the variables
  names(combined) <- varNames
  
  # Improve the activity labels
  combined$label <- sapply(combined$label, Int2Label)
  
  # Subset the features of interest
  combined <- SelectFeaturesOfInterest(varNames,combined)
  
  combined
}


## IsFeatureOfInterest is a predicate that returns true if the feature name
## is one we want in our tidy data set
IsFeatureOfInterest <- function(featureName) {
  ofInterest <- FALSE
  if(grepl("mean",featureName)) {
    ofInterest <- TRUE
  } else if(grepl("std", featureName)) {
    ofInterest <- TRUE
  } else if(featureName == "subject-id") {
    ofInterest <- TRUE
  } else if(featureName == "label") {
    ofInterest <- TRUE
  }
  ofInterest
}

## SelectFeaturesOfInterest selects the features of interested
## from the combined dataset
SelectFeaturesOfInterest <- function(featureNames, combined) {
  # Make a data frame from the feature names
  featuresOfInterest <- data.frame("feature"=featureNames,"ofInterest"=TRUE)
  
  # Set the of interest column values by applying IsFeatureOfInterest
  featuresOfInterest$ofInterest <- sapply(featuresOfInterest$feature,IsFeatureOfInterest)
  
  # Subset just the feature names we want
  dsFeatures <- subset(featuresOfInterest,ofInterest==TRUE,select=c("feature"))
  
  # Convert dsFeatures to vector so we can use it to subset the dataset
  dsFeatures <- as.vector(dsFeatures[,1])
  
  # Extrac the features we want
  combined <- subset(combined,select=dsFeatures)
  
  combined
}

## ProduceSummarizedData returns a data set with the average of each
## variable for each activity and subject
ProduceSummarizedData <- function(dataset) {
  summarized <- dataset %>% group_by(d$"subject-id",label) %>% summarise_each(funs(mean),matches("mean|std"))
  summarized
}

## LabelSummarizedData returns the summarized data sets with descriptive labels
LabelSummarizedData <- function(ds) {
  labels <- names(ds)
  labels[1] <- "subject"
  labels[2] <- "activity"
  for(i in 3:length(ds)) {
    labels[i] <- paste("average", labels[i], sep=" ")
  }
  
  names(ds) <- labels
  ds
}


