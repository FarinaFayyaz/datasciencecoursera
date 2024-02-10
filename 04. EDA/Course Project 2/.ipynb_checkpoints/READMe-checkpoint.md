# EDA Course Project 2
## **Author:** Farina Fayaz
## **Date:** 10 Febraury 2024
### Downloading Data
The data files for the project are available as a zip archive from this [link](https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip)
### Goal of the Project
The overall goal of this assignment is to explore the National Emissions Inventory database and see what it say about fine particulate matter pollution in the United states over the 10-year period 1999–2008. You may use any R package you want to support your analysis.

**Questions**
You must address the following questions and tasks in your exploratory analysis. For each question/task you will need to make a single plot. Unless specified, you can use any plotting system in R to make your plot.  

1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? Using the base plotting system, make a plot showing the total PM2.5 emission from all sources for each of the years 1999, 2002, 2005, and 2008.  
2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the base plotting system to make a plot answering this question.  
3. Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.  
4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?  
6. Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?  or vehicle emissions?


```R
if (!dir.exists("Data")) {
    dir.create("Data")
}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","Data/archive.zip")
unzip("Data/archive.zip",exdir="Data")
```

## Generting 1st plot
**Question:** Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 


```R
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
```

**Answer:** We can see from the barplot that the height of bars has decreased from 1999 to 2008. Therefore total emissions from PM2.5 have indeed decreased from 1999 to 2008.

## Generating 2nd plot
**Question:** Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?


```R
# Load libraries
library(data.table)

# Read data tables
SCC <- data.table::as.data.table(readRDS(file = "Data/Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(readRDS(file = "Data/summarySCC_PM25.rds"))

# Convert Emissions column to numeric
NEI[, Emissions := as.numeric(Emissions)]

# Filter data for Baltimore City (fips="24510")
NEI_baltimore <- NEI[fips == "24510"]

# Calculate total emissions per year for Baltimore City
totalNEI_baltimore <- NEI_baltimore[, .(Emissions = sum(Emissions, na.rm = TRUE)), by = year]

# Saving the plot to plot2.png
# Creating the barplot
png(filename = "plot2.png", width = 800, height = 600)  # Set desired dimensions
barplot(totalNEI_baltimore$Emissions, names = totalNEI_baltimore$year,
        xlab = "Years", ylab = "Total Emissions (tons)",
        main = "Total PM2.5 Emissions in Baltimore City by Year")
dev.off()

```

**Answer:** Yes, The Overall PM2.5 emission in Baltimore City has decreased from 1999 to 2008 as the height of bar corresponding to 1999 is the maximum. However, The PM2.5 emission for the year 2005 is significantly higher compared to 2002 and 2008.  
## Creating 3rd Plot
**Question:** Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008?


```R
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

```

**Answer:** All the source types have seen decrease in emission from 1998-2008. The POINT source was increasing from 1999-2005 but has decreased significantly for the year 2008. So, the overall trend of emissions for source types from 1998-2005 is *decreasing*.
## Creating 4th plot
**Question:** Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?


```R
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

```

**Answer:** The Overall Coal Combustion Source Emission is US has decreased from 1999-2008. It was the highest in 1998 and decreased a little in 20002. Then increased a little in 2005 and decreased significantly in 2008.
## Creating 5th plot
**Question:** How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?


```R
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

```

**Answer:** The emission from Motor Vehicles has decreased from the year 1998-2008. It decreased significantly from the year 1998 to 2002, after that it kept decreasing but the rate is relatively slow.
## Creating 6th plot
**Question:** Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions? or vehicle emissions?


```R
library("data.table")
library("ggplot2")
SCC <- data.table::as.data.table(x = readRDS(file = "Data/Source_Classification_Code.rds"))
NEI <- data.table::as.data.table(x = readRDS(file = "Data/summarySCC_PM25.rds"))

# Gather the subset of the NEI data which corresponds to vehicles
condition <- grepl("vehicle", SCC[, SCC.Level.Two], ignore.case=TRUE)
vehiclesSCC <- SCC[condition, SCC]
vehiclesNEI <- NEI[NEI[, SCC] %in% vehiclesSCC,]

# Subset the vehicles NEI data by each city's fip and add city name.
vehiclesBaltimoreNEI <- vehiclesNEI[fips == "24510",]
vehiclesBaltimoreNEI[, city := c("Baltimore City")]

vehiclesLANEI <- vehiclesNEI[fips == "06037",]
vehiclesLANEI[, city := c("Los Angeles")]

# Combine data.tables into one data.table
bothNEI <- rbind(vehiclesBaltimoreNEI,vehiclesLANEI)

png("plot6.png")

ggplot(bothNEI, aes(x=factor(year), y=Emissions, fill=city)) +
  geom_bar(aes(fill=year),stat="identity") +
  facet_grid(scales="free", space="free", .~city) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Kilo-Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore & LA, 1999-2008"))

dev.off()
```

    Registered S3 methods overwritten by 'ggplot2':
      method         from 
      [.quosures     rlang
      c.quosures     rlang
      print.quosures rlang
    


<strong>png:</strong> 2


**Answer:** Los Angeles has experienced more variation over time in Motor Vehicle Source Emission.


```R

```


```R

```
