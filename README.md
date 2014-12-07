# tsadata

Gem to work with airport checkpoint wait times from the TSA.

## dependencies

nokogiri

## classes
### TSAdata

pass an airport short code to create
a = TSAdata.new "JFK"

#### methods
##### recentwaits
returns a hash containing recent wait times reported for    each checkpoint at the airport.

### TSAreport

pass an array of airport codes to create
a = TSAreport.new ["JFK","EWR","LGA"]

#### methods
##### writereport
takes a filename as parameter.  Creates a file containing wait times for the checkpoints at the airports.