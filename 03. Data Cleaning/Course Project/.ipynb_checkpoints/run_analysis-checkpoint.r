#Data Cleaning Course Project
#By Farina Fayyaz 
#1st Febraury 2024

# Loading necessary libraries
library(dplyr)

#Getting Working Directory
getwd()
#Creating Data subdirectory
if (!dir.exists("Data")) {
    dir.create("Data")
}

#Downloading Dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Data/archive.zip")
date.downloaded <- date()
unzip("Data/archive.zip",exdir="Data")

#Loading the Dataset
#1. Create a list file which contains the path of each file as arguments
#2. Create a list colClasses which contains the classes of all variables in each file as arguments
#3. Create a list nrows which contains the number of rows to read from each file as arguments
#4. Finally create the list of instructions which contains above generated lists as arguments
#5. Using the instructions list created above we load the data into R with read.table function
## the correct arguments for each file are supplied with 'Map()' function
## Function 'with()' is used to make the code easily readable

file = list(
            activity_labels = "Data/UCI HAR Dataset/activity_labels.txt",
            features = "Data/UCI HAR Dataset/features.txt",
            subject_train = "Data/UCI HAR Dataset/train/subject_train.txt",
            y_train = "Data/UCI HAR Dataset/train/y_train.txt",
            X_train = "Data/UCI HAR Dataset/train/X_train.txt",
            subject_test = "Data/UCI HAR Dataset/test/subject_test.txt",
            y_test = "Data/UCI HAR Dataset/test/y_test.txt",
            X_test = "Data/UCI HAR Dataset/test/X_test.txt")
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
data_files <- with(instructions,
                   Map(read.table,
                       file = file, colClasses = colClasses, nrows = nrows,
                       quote = "", comment.char = "",
                       stringsAsFactors = FALSE))
#Merge the Training and Test Data to create one Dataset
merged_data <- with(data_files,
                    rbind(cbind(subject_train, y_train, X_train),
                          cbind(subject_test,  y_test,  X_test)))
#Extracting the measurements of Mean and Standard Deviation from measurements
#1. Find the indices of mean() and sd() from features.txt dataframe
#2. Add 2 to each index to adjust for the two extra column
## in the beginning of the merged data frame, 'subject' and 'activity'
#3. Extracts the target variables to create the target data frame
feature_indices <- grep("mean\\(\\)|std\\(\\)",
                                data_files$features[[2]])
variable_indices <- c(1, 2, feature_indices + 2)
target_data <- merged_data[ ,variable_indices]
#Creating the Tidy Dataset
#1. Renaming the activities to more descriptive names
#2. Customising Data Labels with relevant activity names
#3. Correcting typo
#4. Create a tidy data set with appropriate labels for the variable names

target_data[[2]] <- factor(target_data[[2]],
                           levels = data_files$activity_labels[[1]],
                           labels = data_files$activity_labels[[2]])
descriptive_variable_names <- data_files$features[[2]][feature_indices]

descriptive_variable_names <- gsub(pattern = "BodyBody", replacement = "Body",
                                   descriptive_variable_names)

tidy_data <- target_data
names(tidy_data) <- c("subject", "activity", descriptive_variable_names)
#Creating the Tidy Data Summary Text File
#1. Create the dataset with the mean of each column for 'subject' and 'activity'
#2. Save the data frame created as a text file in working directory

tidy_data_summary <- tidy_data %>%
      group_by(subject, activity) %>%
      summarise_all(list(mean=~mean(.))) %>%
      unlist()
new_names_for_summary <- c(names(tidy_data_summary[c(1,2)]),
                           paste0("Avrg-", names(tidy_data_summary[-c(1, 2)])))
names(tidy_data_summary) <- new_names_for_summary
write.table(tidy_data_summary, "tidy_data_summary.txt", row.names = FALSE)

