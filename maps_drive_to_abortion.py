#!/usr/bin/env python
# coding: utf-8

import pandas as pd
from datetime import datetime
import googlemaps
# Define the Google Maps API key
gmaps = googlemaps.Client(key='AIzaSyAKiqWAENqXLewMqGgh7_7yliWw_1VhFQ0')

dat = pd.read_csv('abortion_access_legal_clean.csv')
dat.head()

# Drop all rows where state is "AK", "HI", or "PR"
dat = dat[~dat['state'].isin(['AK', 'HI', 'PR'])]

# Loop through each row in the dat dataframe and compute the driving distance
for i in range(len(dat)):
    # Define the coordinates for the two points
    origin = (dat['zip_Y'][i], dat['zip_X'][i])
    destination = (dat['storeLAT'][i], dat['storeLONG'][i])

    # Find the nearest road using the Google Maps API
    origin_geocode_result = gmaps.reverse_geocode(origin)
    origin_nearest_road = origin_geocode_result[0]['formatted_address']
    destination_geocode_result = gmaps.reverse_geocode(destination)
    destination_nearest_road = destination_geocode_result[0]['formatted_address']

    # Find the driving distance between the two points
    now = datetime.now()
    directions_result = gmaps.directions(origin,
                                         destination,
                                         mode="driving",
                                         departure_time=now)
    if directions_result:
        distance_meters = directions_result[0]['legs'][0]['distance']['value']
        distance_miles = distance_meters * 0.000621371
        milage = distance_miles
    else:
        milage = None

    # Add the driving distance back to the dat dataframe
    dat.at[i, 'driving_distance'] = milage

    # Print the current iteration number
    print(f"Completed request {i+1}/{len(dat)}")

dat['driving_distance']
dat.to_csv("zip_distance_to_abortions.csv")
