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
