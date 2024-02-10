# If the Data file is not already Downloaded, Creating the "Data" directory and Downloading the Data file 
if (!dir.exists("Data")) {
    dir.create("Data")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","Data/archive.zip")
    unzip("Data/archive.zip",exdir="Data")
}

# Importing necessary libraries
library("data.table")

# Read data tables
SCC <- data.table::as.data.table(readRDS(file = "Data/Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(readRDS(file = "Data/summarySCC_PM25.rds"))

# Convert Emissions column to numeric
NEI[, Emissions := as.numeric(Emissions)]

# Calculate total emissions per year
totalNEI <- NEI[, .(Emissions = sum(Emissions, na.rm = TRUE)), by = year]

# Saving the plot to plot1.png
png("plot1.png", width = 800, height = 600)

# Create bar plot with clear labels and title
barplot(totalNEI$Emissions, names = totalNEI$year,
        xlab = "Years", ylab = "Total Emissions (tons)",
        main = "Total PM2.5 Emissions in the US by Year")
dev.off()