library(readr)
library(dplyr)
options(digits = 7)

#Read CSV with US zipcodes 
#found at https://hudgis-hud.opendata.arcgis.com/maps/zip-code-population-weighted-centroids
dat <- read_csv("ZIP_Code_Population_Weighted_Centroids.csv")
dat <- subset(dat, dat$USPS_ZIP_PREF_STATE_1221 != "AK" & dat$USPS_ZIP_PREF_STATE_1221 != "GU" & dat$USPS_ZIP_PREF_STATE_1221 != "HI" & dat$USPS_ZIP_PREF_STATE_1221 != "PR" & dat$USPS_ZIP_PREF_STATE_1221 != "VI")
head(dat)
dat$ZIPS <- dat$STD_ZIP5
summary(dat$ZIPS)

#Load 2020 CES
# Available at https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi%3A10.7910/DVN/E9N6PH
df <- read_csv("Downloads/CES20_Common_OUTPUT_vv.csv")
df$ZIPS <- df$lookupzip
summary(df$ZIPS)
df <- subset(df, inputstate != 15 & inputstate != 2)

#Remove HI and AK
#df <- read_csv("abortion_distances")
#df <- subset(df, inputstate != 15 & inputstate != 2)

#Merge abortion distance zipcodes with CES 2020
data <- merge(df, dat, by.x = "ZIPS", by.y = "ZIPS")

#Import driving distances
fdat <- read_csv("ABORTION DISTANCES DATAFRAME")
head(fdat$LONGITUDE_zip)

#combine distances with CES data
merged_df2 <- merge(data, fdat, by.x = c("LONGITUDE", "LATITUDE"), by.y = c("LONGITUDE_zip", "LATITUDE_zip"))

#plot distances of CES respondents to abortion facility
hist(merged_df2$driving_distance)
table(merged_df2$USPS_ZIP_PREF_STATE_1221)
