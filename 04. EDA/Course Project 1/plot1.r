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
