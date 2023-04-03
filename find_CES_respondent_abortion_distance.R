library(readr)

data_clean <- subset(data, !is.na(driving_distance))

#Zipcode distances obtained from maps_drive_to_abortion.py
zip_dat <- read_csv("zipcodes_to_abortion.csv")

#CES Data found at: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/PR4L8P
CCES <- read_csv("CES22_Common.csv")
CCES$numericZIPS <- as.numeric(CCES$lookupzip)

#Merge zips_to_abortion.csv with CES22_Common
merged_data_distances_CCES <- merge(CCES, data_clean, by.x = "numericZIPS", by.y = "ZIPS")
