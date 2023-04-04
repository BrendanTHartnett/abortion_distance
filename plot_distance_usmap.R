library(ggplot2)
library(maps)
library(mapdata)
library(readr)
library(rgdal)
library(sf)

dat <- read_csv("Documents/TPOL/Abortion_Distance/zipcodes_to_abortion.csv")

zones <- read_sf("Downloads/tl_2019_us_zcta510/tl_2019_us_zcta510.shp")

dat$numericZIPS
fdat <- merge(zones, dat, by.x = "GEOID10", by.y = "numericZIPS")

# Convert the fdat data frame to an sf object
fdat_sf <- st_as_sf(fdat, wkt = "geometry")

# Create the plot
ggplot() +
  geom_sf(data = fdat_sf, aes(fill = driving_distance)) +
  scale_fill_gradient(low = "white", high = "red") +
  theme_void()
