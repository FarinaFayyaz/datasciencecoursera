# Getting and Cleaning Data Project
Author: Farina Fayyaz
Data Zip File Location: [UC Irvine Repo](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Goal of the Project
1. A tidy data set
2. A link to a Github repository with your script for performing the analysis
3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
5. Analysis R Script

## Content
| Goal | Item | Link to Item |
|---|---|---|
| The run_analysis.R script that performs all the analysis| run_analysis.R | [R Script Link](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/03.%20Data%20Cleaning/run_analysis.r) |
| Tidy Dataset  | Clean Dataset | [Dataset Link](insert link here) |
| Github Repository | Repository | [Repository Link](https://github.com/FarinaFayyaz/datasciencecoursera/tree/main/03.%20Data%20Cleaning) |
| The CodeBook.md with description of all the variables in the final tidy data set | Codebook.md | [Codebook Link](insert link here) |
| This README.md with all the instructions to run and explanations | README.md | [File Link](http://localhost:8888/edit/Course%20Project%2FREADME.md) |

## To Perform the run_analysis.R file
* Check for Dplyr: Make sure you have the "dplyr" collection of packages installed in your R environment. If you don't, run this command in your R session: install.packages("dplyr")
* Clone the Repository: Obtain a copy of the project's repository onto your computer.
* Navigate to the Directory: Open R and use the setwd() function to set your working directory to the project's home directory (the main folder where the run_analysis.R script is located).
* Run the Script: Execute the following command in your R session to initiate the analysis: source("run_analysis.R")

## How it works
These are the steps followed in the run_analysis.r script

### 1. Load the dependence (dplyr)
```
library(dplyr)
```
### 2. Retrieve and Extract the data. 
Verify the existence of the data directory; if absent, create it. Download the file and unzip it to "Data" directory. "Data/UCI HAR Dataset" will contain the requisite files.
```
path <- getwd()
#Creating Data subdirectory
if (!dir.exists("path/Data")) {
    dir.create("path/Data")
}

#Downloading Dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","path/Data/test.zip")
date.downloaded <- data()
unzip("Data/test.zip",exdir="Data")
```
### 3. Loading the Dataset
```
#1. Create a list file which contains the path of each file as arguments
#2. Create a list colClasses which contains the classes of all variables in each file as arguments
#3. Create a list nrows which contains the number of rows to read from each file as arguments
#4. Finally create the list of instructions which contains above generated lists as arguments
#5. Using the instructions list created above we load the data into R with read.table function
## the correct arguments for each file are supplied with 'Map()' function
## Function 'with()' is used to make the code easily readable
file = list(
            activity_labels = "UCI HAR Dataset/activity_labels.txt",
            features = "UCI HAR Dataset/features.txt",
            subject_train = "UCI HAR Dataset/train/subject_train.txt",
            y_train = "UCI HAR Dataset/train/y_train.txt",
            X_train = "UCI HAR Dataset/train/X_train.txt",
            subject_test = "UCI HAR Dataset/test/subject_test.txt",
            y_test = "UCI HAR Dataset/test/y_test.txt",
            X_test = "UCI HAR Dataset/test/X_test.txt")
colClasses = list(
            activity_labels = c("integer", "character"),
            features = c("integer", "character"),
            subject_train = "integer",
            y_train = "integer",
            X_train = rep("numeric", 561),
            subject_test = "integer",
            y_test = "integer",
            X_test = rep("numeric", 561)
      )
nrows = list(
            activity_labels = 6,
            features = 561,
            subject_train = 7352,
            y_train = 7352,
            X_train = 7352,
            subject_test = 2947,
            y_test = 2947,
            X_test = 2947
      )
instructions <- list(list(file,colClasses, nrows))
data_files <- with(read.table_instructions,
                   Map(read.table,
                       file = file, colClasses = colClasses, nrows = nrows,
                       quote = "", comment.char = "",
                       stringsAsFactors = FALSE))
```
### 4. Merge the Training and Test Data to create one Dataset
```
merged_data <- with(data_files,
                    rbind(cbind(subject_train, y_train, X_train),
                          cbind(subject_test,  y_test,  X_test)))
```
### 5. Extracting the measurements of Mean and Standard Deviation from measurements
```
# Find the indices of mean() and sd() from features.txt dataframe
target_features_indexes <- grep("mean\\(\\)|std\\(\\)",
                                data_files$features[[2]])
#Add 2 to each index to adjust for the two extra column
## in the beginning of the merged data frame, 'subject' and 'activity'
target_variables_indexes <- c(1, 2, target_features_indexes + 2)
# Extracts the target variables to create the target data frame
target_data <- merged_data[ , target_variables_indexes]
```
### 6. Creating the Tidy Dataset
```
# Renaming the activities to more descriptive names
target_data[[2]] <- factor(target_data[[2]],
                           levels = data_files$activity_labels[[1]],
                           labels = data_files$activity_labels[[2]])
# Customising Data Labels with relevant activity names
descriptive_variable_names <- data_files$features[[2]][feature_indices]

# Correcting typo
descriptive_variable_names <- gsub(pattern = "BodyBody", replacement = "Body",
                                   descriptive_variable_names)

## Create a tidy data set with appropriate labels for the variable names
tidy_data <- target_data
names(tidy_data) <- c("subject", "activity", descriptive_variable_names)
```
### 7. Creating the Tidy Data Summary Text File
```
#Create a dataset with the mean of each column for 'subject' and 'activity'
tidy_data_summary <- tidy_data %>%
      group_by(subject, activity) %>%
      summarise_all(list(mean=~mean(.))) %>%
      unlist()
new_names_for_summary <- c(names(tidy_data_summary[c(1,2)]),
                           paste0("Avrg-", names(tidy_data_summary[-c(1, 2)])))
names(tidy_data_summary) <- new_names_for_summary
# Save the data frame created as a text file in working directory
write.table(tidy_data_summary, "tidy_data_summary.txt", row.names = FALSE)
```





