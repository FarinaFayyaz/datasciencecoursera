# Getting and Cleaning Data Project
Author: Farina Fayyaz
Data Zip File Location: [UC Irvine Repo](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

# Goal of the Project
1. A tidy data set
2. A link to a Github repository with your script for performing the analysis
3. A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md.
4. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.
5. Analysis R Script

# Content
| Goal | Item | Link to Item |
|---|---|---|
| The run_analysis.R script that performs all the analysis| run_analysis.R | [R Script Link](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/03.%20Data%20Cleaning/run_analysis.r) |
| Tidy Dataset  | Clean Dataset | [Dataset Link](insert link here) |
| Github Repository | Repository | [Repository Link](https://github.com/FarinaFayyaz/datasciencecoursera/tree/main/03.%20Data%20Cleaning) |
| The CodeBook.md with description of all the variables in the final tidy data set | Codebook.md | [Codebook Link](insert link here) |
| This README.md with all the instructions to run and explanations | README.md | [File Link](http://localhost:8888/edit/Course%20Project%2FREADME.md) |

# To Perform the run_analysis.R file
* Check for Tidyverse: Make sure you have the "tidyverse" collection of packages installed in your R environment. If you don't, run this command in your R session: install.packages("tidyverse")
* Clone the Repository: Obtain a copy of the project's repository onto your computer.
* Navigate to the Directory: Open R and use the setwd() function to set your working directory to the project's home directory (the main folder where the run_analysis.R script is located).
* Run the Script: Execute the following command in your R session to initiate the analysis: source("run_analysis.R")

# How it works
These are the steps followed in the run_analysis.r script

1. Load the dependence (tidyverse)
'''
    library(tidyverse)
'''

