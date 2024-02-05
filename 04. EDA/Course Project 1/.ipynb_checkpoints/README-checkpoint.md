# Exploratory Data Analysis 
# Course Project 1
## Author: Farina Fayyaz
## Date: 5 Febraury,2024
## About the Project
This assignment uses data from the UC Irvine Machine Learning Repository, a popular repository for machine learning datasets. In particular, we will be using the “Individual household electric power consumption Data Set” which is available in the link provided below.  
**Dataset** [Electric power consumption](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zib)  
**Description:** Measurements of electric power consumption in one household with a one-minute sampling rate over a period of almost 4 years. Different electrical quantities and some sub-metering values are available.

## To Download the Dataset


```R
if (!dir.exists("Data")) {
    dir.create("Data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","Data/archive.zip")
unzip("Data/archive.zip",exdir="Data")
```


```R
library("data.table")

# Function to read data from file and subset for specified dates
read_and_subset_data <- function(file_path, start_date, end_date) {
  data <- data.table::fread(input = file_path, na.strings = "?")
  data[, Global_active_power := as.numeric(Global_active_power)]
  data[, Date := as.Date(Date, format = "%d/%m/%Y")]
  subset_data <- data[(Date >= start_date) & (Date <= end_date)]
  return(subset_data)
}

# Function to plot histogram and save to file
plot_and_save_histogram <- function(data, output_file) {
  png(output_file, width = 480, height = 480)
  hist(data$Global_active_power, main = "Global Active Power", 
       xlab = "Global Active Power (kilowatts)", ylab = "Frequency", col = "Red")
  dev.off()
}

# Define file path and date range
file_path <- "Data/household_power_consumption.txt"
start_date <- as.Date("2007-02-01")
end_date <- as.Date("2007-02-02")

# Read and subset data
powerDT <- read_and_subset_data(file_path, start_date, end_date)

# Plot histogram and save to file
plot_and_save_histogram(powerDT, "plot1.png")

```

![](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/04.%20EDA/Course%20Project%201/plot1.png)

```R
library("data.table")

# Function to read and preprocess data
read_and_preprocess_data <- function(file_path, start_date, end_date) {
  data <- data.table::fread(input = file_path, na.strings = "?")
  data[, Global_active_power := as.numeric(Global_active_power)]
  data[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]
  subset_data <- data[(dateTime >= start_date) & (dateTime < end_date)]
  return(subset_data)
}

# Define file path and date range
file_path <- "Data/household_power_consumption.txt"
start_date <- as.POSIXct("2007-02-01", tz = "UTC")
end_date <- as.POSIXct("2007-02-03", tz = "UTC")

# Read and preprocess data
powerDT <- read_and_preprocess_data(file_path, start_date, end_date)

# Set up plotting environment
png("plot2.png", width = 480, height = 480)

## Plot 2
plot(x = powerDT$dateTime, y = powerDT$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

dev.off()

```

![](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/04.%20EDA/Course%20Project%201/plot2.png)

```R
library("data.table")

# Function to read and preprocess data
read_and_preprocess_data <- function(file_path, start_date, end_date) {
  data <- data.table::fread(input = file_path, na.strings = "?")
  data[, Global_active_power := as.numeric(Global_active_power)]
  data[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]
  subset_data <- data[(dateTime >= start_date) & (dateTime < end_date)]
  return(subset_data)
}

# Define file path and date range
file_path <- "Data/household_power_consumption.txt"
start_date <- as.POSIXct("2007-02-01", tz = "UTC")
end_date <- as.POSIXct("2007-02-03", tz = "UTC")

# Read and preprocess data
powerDT <- read_and_preprocess_data(file_path, start_date, end_date)

# Set up plotting environment
png("plot3.png", width = 480, height = 480)

# Plot 3
plot(powerDT$dateTime, powerDT$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(powerDT$dateTime, powerDT$Sub_metering_2, col = "red")
lines(powerDT$dateTime, powerDT$Sub_metering_3, col = "blue")
legend("topright", col = c("black", "red", "blue"),
       legend = c("Sub_metering_1  ", "Sub_metering_2  ", "Sub_metering_3  "),
       lty = c(1, 1), lwd = c(1, 1))

dev.off()

```

![](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/04.%20EDA/Course%20Project%201/plot3.png)

```R
library("data.table")

# Read data from file and subset for specified dates
powerDT <- data.table::fread(input = "Data/household_power_consumption.txt", na.strings = "?")

# Prevent Scientific Notation for Global_active_power
powerDT[, Global_active_power := as.numeric(Global_active_power)]

# Create POSIXct date for filtering and graphing by time of day
powerDT[, dateTime := as.POSIXct(paste(Date, Time), format = "%d/%m/%Y %H:%M:%S")]

# Filter dates for 2007-02-01 and 2007-02-02
powerDT <- powerDT[(dateTime >= "2007-02-01") & (dateTime < "2007-02-03")]

# Set up the plot parameters
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))

# Plot 1: Global Active Power
plot(powerDT[, dateTime], powerDT[, Global_active_power], type = "l", xlab = "", ylab = "Global Active Power")

# Plot 2: Voltage
plot(powerDT[, dateTime], powerDT[, Voltage], type = "l", xlab = "datetime", ylab = "Voltage")

# Plot 3: Energy Sub Metering
plot(powerDT[, dateTime], powerDT[, Sub_metering_1], type = "l", xlab = "", ylab = "Energy sub metering")
lines(powerDT[, dateTime], powerDT[, Sub_metering_2], col = "red")
lines(powerDT[, dateTime], powerDT[, Sub_metering_3], col = "blue")
legend("topright", col = c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = c(1, 1), bty = "n", cex = 0.5)

# Plot 4: Global Reactive Power
plot(powerDT[, dateTime], powerDT[, Global_reactive_power], type = "l", xlab = "datetime", ylab = "Global Reactive Power")

# Save and close the plot
dev.off()

```

![](https://github.com/FarinaFayyaz/datasciencecoursera/blob/main/04.%20EDA/Course%20Project%201/plot4.png)

