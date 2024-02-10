# If the Data file is not already Downloaded, Creating the "Data" directory and Downloading the Data file 
if (!dir.exists("Data")) {
    dir.create("Data")
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","Data/archive.zip")
    unzip("Data/archive.zip",exdir="Data")
}

# Load necessary libraries
library(data.table)
library(ggplot2)

# Load data as data.tables
NEI <- as.data.table(readRDS("Data/summarySCC_PM25.rds"))
SCC <- as.data.table(readRDS("Data/Source_Classification_Code.rds"))

# Filter for vehicle-related emissions
vehiclesSCC <- SCC[grepl("vehicle", SCC.Level.Two, ignore.case = TRUE), SCC]
vehiclesNEI <- NEI[SCC %in% vehiclesSCC]

# Filter for Baltimore emissions
baltimoreVehiclesNEI <- vehiclesNEI[fips == "24510"]

# Create the plot
png("plot5.png")

ggplot(baltimoreVehiclesNEI, aes(factor(year), Emissions)) +
    geom_bar(stat = "identity", fill = "#FF9999", width = 0.75) +
    labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) +
    labs(title = expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))

dev.off()
