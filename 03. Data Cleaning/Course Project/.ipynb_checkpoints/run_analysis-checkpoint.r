#Data Cleaning Course Project
#By Farina Fayyaz 
#1st Febraury 2024

#Getting Working Directory
getwd()
#Creating Data subdirectory
if (!dir.exists("Data")) {
    dir.create("Data")
}
#Downloading Datasets
download.file("https://archive.ics.uci.edu/static/public/240/human+activity+recognition+using+smartphones.zip","Data/train.zip")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","Data/test.zip")
unzip("train.zip",exdir="Data")
unzip("test.zip",exdir="Data")