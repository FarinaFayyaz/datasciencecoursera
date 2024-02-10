# If the Data file is not already Downloaded, Creating the "Data" directory and Downloading the Data file 
if (!dir.exists("Data")) {
    dir.create("Data")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","Data/archive.zip")
    unzip("Data/archive.zip",exdir="Data")
}

# Loading necessary libraries
library(data.table)
library(ggplot2)

# Read data tables
SCC <- data.table::as.data.table(readRDS(file = "Data/Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(readRDS(file = "Data/summarySCC_PM25.rds"))

# Filter for Baltimore City data
baltimoreNEI <- NEI[fips == "24510"]

# Saveing the plot to plot3.png
png("plot3.png", width = 800, height = 600)
# Generating the plot
ggplot(baltimoreNEI, aes(factor(year), Emissions, fill = type)) +
  geom_bar(stat = "identity") +
  theme_bw() +
  guides(fill = FALSE) +
  facet_grid(. ~ type, scales = "free", space = "free") +
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (Tons)")) +
  labs(title = expression("PM"[2.5]*" Emissions in Baltimore City, 1999-2008 by Source Type"))
dev.off()

