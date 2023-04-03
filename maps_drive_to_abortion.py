#!/usr/bin/env python
# coding: utf-8

import pandas as pd
from datetime import datetime
import googlemaps
import random
import time

# Define the Google Maps API key
gmaps = googlemaps.Client(key='YOUR KEY', retry_over_query_limit=True)

dat = pd.read_csv('RESTRICTED_ABORTIONS_DATA')

def get_directions_with_backoff(origin, destination, max_retries=5):
    for n in range(0, max_retries):
        try:
            now = datetime.now()
            directions_result = gmaps.directions(origin,
                                                 destination,
                                                 mode="driving",
                                                 departure_time=now)
            return directions_result
        except googlemaps.exceptions._OverQueryLimit:
            sleep_time = (2 ** n) + random.random()
            time.sleep(sleep_time)
    return None

dat = dat.reset_index(drop=True)

# Loop through each row in the dat dataframe and compute the driving distance
for i in range(0, len(dat)):
    # Define the coordinates for the two points
    origin = (dat['LAT'][i], dat['LGT'][i])
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
    print(f"Completed {i+1}/{len(dat)}")
