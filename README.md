## Overview

This repo contains code related to the class project for Getting and
Cleaning data.

The R script assumes the data set for the project has been downloaded and
unzipped in the working directory the script executes in. In other
words, to run the script, clone the repository from github, then
download and unzip the dataset into the directory containing the
cloned project (which will contain the run_analysis.R script).

The script
also assumes the dplyr package has been installed in the R environment: the script loads the dplyr library but does not install the dplyr
package.

The dataset may be downloaded from [here](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), and is described
[here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

## R Script

The run_analysis.R script produces a tidy data set consisting of the average of each
mean and standard deviation observation from the original dataset.

To run the script, source it into R Studio, set the working directory relative to the data set as described above, then invoke it as `run_analysis`, for example

<pre>
summarized <- run_analysis()
View(summarized)
</pre>

The script performs the following processing:

1. The existence of the dataset directory and training and test
subdirectories are verified.
2. The dplyr library is loaded
3. The sensor data, activity labels, and subject id files are loaded
and combined into a single data frame for both the training data and the test data.
4. The test and training data frames are then combined into a single
data frame and labeled with the subject id, the activity
label, and the features provided in features.txt with the dataset.
5. The features of interest for the project, those giving mean and
standard deviations for sensor measurements, are extracted from the data set (along with the subject id and activity label)
6. The data is then summarized using the dplyr group_by and
summarise_each functions.
7. Finally, the labels for the summarized data are updated to
indicate they represent average sensore readings.

## Code Book

The <a href="features_info.txt">Code Book</a> distributed with the
data set provides a comprehensive description of the features in the
data set processed by the R script in this project.

The feature names defined in the original project has been used as labels for the data in this project. Note that the subject ids are labeled
"subject" and the activities are labeled "activity" -- all other
labels are taken directly from the original code book, prepended
with "average" to make it clear in the tidy data set that average
values for the features are being presented in the summarized data.
Subject ids and activity labels were pulled from separate files and
combined with the feature data.

Note the activity values (WALKING, STANDING, etc) were obtained
using the mapping from the original codes in the raw dataset to
descriptive values provided in the activity_labels.txt file
