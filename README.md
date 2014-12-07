tsadata
=======

Gem to work with airport checkpoint wait times from the TSA.

1. dependencies

nokogiri

2. classes
2.1 TSAdata

pass an airport short code to create
a = TSAdata.new "JFK"

2.1.1 methods
2.1.1.1 recentwaits
returns a hash containing recent wait times reported for    each checkpoint at the airport.

2.2 TSAreport

pass an array of airport codes to create
a = TSAreport.new ["JFK","EWR","LGA"]

2.2.1 methods
2.2.1.1 writereport
takes a filename as parameter.  Creates a file containing wait times for the checkpoints at the airports.