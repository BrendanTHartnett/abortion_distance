SELECT *
FROM abortion_data
WHERE longitude IS NOT NULL
  AND latitude IS NOT NULL
  AND state NOT IN ('AL', 'AR', 'GA', 
  'ID', 'KY', 'KY', 'LA', 'MS', 'MO',
  'OK', 'SD', 'TN', 'TX', 'WV', 'WI');
