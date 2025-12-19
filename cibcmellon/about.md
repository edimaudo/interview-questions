## Overview

Approximately 2.8 million parking tickets are issued annually across the City of Toronto. This dataset contains non-identifiable information relating to each parking ticket issued for each calendar year. The tickets are issued by Toronto Police Services (TPS) personnel as well as persons certified and authorized to issue tickets by TPS.  For more information check [here](https://open.toronto.ca/dataset/parking-tickets/)

This data set contains complete records only. Incomplete records in the City database are not included in the data set. Incomplete records may exist due to a variety of reasons e.g. the vehicle registration is out-of-province, tickets paid prior to staff entering the ticket data, etc.The volume of incomplete records relative to the overall volume is low and therefore presents insignificant impact to trend analysis.

The columns in this data are defined as follows:

- tagnumbermasked: Parking Violation Notice number or Violation/Ticket Number, used to create the record in city systems

- date_of_infraction: Violation Date or the date the offence was committedfield name to Date of Violation.

- infraction_code: Violation Code that refers to the parking bylaw that the vehicle has violated.

- infraction_description: Short description of the Violation Code

- set_fine_amount: Penalty Amount prescribe in the bylaw for the Violation Code

- time_of_infraction: Violation Time in which the offence was committed, and ticket issued

- location1: First part of the location of the violation where the offence was committed. This field is used to capture the proximity of the location and only captures the following information, NR=near, AT=at, OPP=opposite, S/S=south side, E/O=east of, etc

- location2: Second part of the location of the violation where the offence was committed, used to capture the street name or address of the location

- location3: Used in the same manner as the first location. This field is not always used, only in the event that the officer issues the violation near a corner

- location4: Used in the same manner as the second location, also only used when the officer issues the violation near a corner

- province: Province where the licence plate associated with the violation is registered