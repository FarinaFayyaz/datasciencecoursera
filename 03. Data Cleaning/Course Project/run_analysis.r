#Data Cleaning Course Project
#By Farina Fayyaz 
#1st Febraury 2024

#Getting Working Directory
getwd()
#Creating Data subdirectory
if (!dir.exists("Data")) {
    dir.create("Data")
}

#Downloading Dataset
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Data/test.zip")
unzip("Data/archive.zip",exdir="Data")

#Loading the