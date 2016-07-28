#!/bin/sh
/etc/init.d/mongodb start
mongoimport --collection quotes --file data/quoteid.json --type json --jsonArray
gotty -w -p 3000 /bin/sh &
httpServe -port 5000
