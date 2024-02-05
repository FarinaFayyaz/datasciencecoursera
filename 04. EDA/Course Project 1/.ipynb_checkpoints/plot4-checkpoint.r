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
