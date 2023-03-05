library(readr)
library(dplyr)
options(digits = 7)

#Read CSV with US zipcodes 
dat <- read_csv("ZIP_Code_Population_Weighted_Centroids.csv")
dat <- subset(dat, dat$USPS_ZIP_PREF_STATE_1221 != "AK" & dat$USPS_ZIP_PREF_STATE_1221 != "GU" & dat$USPS_ZIP_PREF_STATE_1221 != "HI" & dat$USPS_ZIP_PREF_STATE_1221 != "PR" & dat$USPS_ZIP_PREF_STATE_1221 != "VI")
dat$ZIPS <- as.numeric(dat$STD_ZIP5)

#Read CES
df <- read_csv("CES20_Common_OUTPUT_vv.csv")
df <- subset(df, !is.na(df$inputzip))
df$ZIPS <- df$inputzip
#Remove HI and AK
df <- subset(df, inputstate != 15 & inputstate != 2)

#Merge abortion distance zipcodes with CES 2020
data <- merge(df, dat, by.x = "ZIPS", by.y = "ZIPS")

#Import driving distances
fdat <- read_csv("ABORTION DATA GIS")

#combine distances with CES data
merged_dat <- merge(data, fdat, by.x = c("LONGITUDE", "LATITUDE"), by.y = c("LONGITUDE_zip", "LATITUDE_zip"))

#plot distances of CES respondents to abortion facility
hist(merged_dat$driving_distance)
