library(readr)
library(dplyr)
options(digits = 7)

#Read CSV with US zipcodes 
dat <- read_csv("ZIP_Code_Population_Weighted_Centroids.csv")
dat <- subset(dat, dat$USPS_ZIP_PREF_STATE_1221 != "AK" & dat$USPS_ZIP_PREF_STATE_1221 != "GU" & dat$USPS_ZIP_PREF_STATE_1221 != "HI" & dat$USPS_ZIP_PREF_STATE_1221 != "PR" & dat$USPS_ZIP_PREF_STATE_1221 != "VI")
dat$zipcode <- as.numeric(dat$STD_ZIP5)
head(dat)
dat$ZIPS <- dat$STD_ZIP5

df <- read_csv("Downloads/CES20_Common_OUTPUT_vv.csv")
df <- subset(df, !is.na(df$inputzip))
df$ZIPS <- df$inputzip
#Remove HI and AK
df <- read_csv("abortion_distances")
df <- subset(df, inputstate != 15 & inputstate != 2)

#Merge abortion distance zipcodes with CES 2020
data <- merge(df, dat, by.x = "ZIPS", by.y = "ZIPS")

#Import driving distances
fdat <- read_csv("checkiffucked.csv")

#combine distances with CES data
merged_df2 <- merge(data, fdat, by.x = c("LONGITUDE", "LATITUDE"), by.y = c("LONGITUDE_zip", "LATITUDE_zip"))

#plot distances of CES respondents to abortion facility
hist(merged_df2$driving_distance)
