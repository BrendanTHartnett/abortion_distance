library(ggplot2)
library(maps)
library(mapdata)
library(readr)
library(rgdal)
library(sf)

dat <- read_csv("zipcodes_to_abortion.csv")

#shapefile available here: https://catalog.data.gov/dataset/tiger-line-shapefile-2019-2010-nation-u-s-2010-census-5-digit-zip-code-tabulation-area-zcta5-na 
zones <- read_sf("tl_2019_us_zcta510/tl_2019_us_zcta510.shp")

dat$numericZIPS
fdat <- merge(zones, dat, by.x = "GEOID10", by.y = "numericZIPS")

# Convert the fdat data frame to an sf object
fdat_sf <- st_as_sf(fdat, wkt = "geometry")

# Create the plot
ggplot() +
  geom_sf(data = fdat_sf, aes(fill = driving_distance)) +
  scale_fill_gradient(low = "white", high = "red") +
  theme_void()
