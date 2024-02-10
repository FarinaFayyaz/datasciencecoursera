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

# Filter for coal combustion-related data
combustion_related <- grepl("comb", SCC$SCC.Level.One, ignore.case = TRUE)
coal_related <- grepl("coal", SCC$SCC.Level.Four, ignore.case = TRUE)
combustion_SCC <- SCC[combustion_related & coal_related, SCC]
combustion_NEI <- NEI[NEI$SCC %in% combustion_SCC]

# Saving the plot to plot4.png
png("plot4.png", width = 800, height = 600) 

# Generating the plot
ggplot(combustion_NEI, aes(x = factor(year), y = Emissions / 10^5)) +
  geom_bar(stat = "identity", fill = "#FF9999", width = 0.75) +
  labs(x = "Year", y = expression("Total PM"[2.5]*" Emission (10^5 Tons)")) +
  labs(title = expression("PM"[2.5]*" Coal Combustion Source Emissions in US, 1999-2008"))
dev.off()
