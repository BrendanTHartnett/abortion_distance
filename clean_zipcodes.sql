SELECT *
FROM us_zipcodes
WHERE USPS_ZIP_1 NOT IN ('GU', 'VI', 'HI', 
  'AK', 'AS');