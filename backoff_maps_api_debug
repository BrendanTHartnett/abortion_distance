import pandas as pd
from datetime import datetime
import googlemaps
import random
import time

# Define the Google Maps API key
gmaps = googlemaps.Client(key='YOUR KEY', retry_over_query_limit=True)

#Create a backoff to be employed when the API call rate exceeds the max of gmaps API. 
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
