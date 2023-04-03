library(readr)

data_clean <- subset(data, !is.na(driving_distance))


zip_dat <- read_csv("zipcodes_to_abortion.csv")
CCES <- read_csv("Downloads/CES22_Common.csv")
CCES$numericZIPS <- as.numeric(CCES$lookupzip)


merged_data_distances_CCES <- merge(CCES, data_clean, by.x = "numericZIPS", by.y = "ZIPS")
