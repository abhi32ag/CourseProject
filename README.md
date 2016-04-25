#Getting and Cleaning Data Course Project

This file describes how the run_analysis.R script works.

* Step 1, unzip data from 
  <a>https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>
* Ensure that the current directory is set to the path where data and run_analysis.R are stored
* Step 2, use the source command in RStudio
* Step 3, output files will be stored in the current working directory:
  *merged_data.txt : it contains a data frame called tidyData
  *data_with_means.txt : it contains a data frame called result
* Step 4, use the read.table() function to read the file in RStudio.