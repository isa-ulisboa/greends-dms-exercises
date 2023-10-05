# Data Management and Storage

# Exercise 5 - Designing an Entity-Relationship Model

## Introduction

In this exercise we will train how to identify entities, attributes and relationships in a problem statement. You will solve this exercise in two steps, after discussion of classes 04 and 05 of the course. The exercise will be updated with further tasks accordingly. 

### Problem 1. Scenario:
You are tasked with designing a database to manage soil data for a research project. The database should store information about soil samples collected from various locations. The data to be stored includes details about the soil samples, the locations where they were collected, and the technicians who collected them. The following values are sampled for each of the soil samples: 
- Date of Collection
- Depth (in meters)
- Soil Type
- pH Level
- Organic Matter Content
- Moisture Content
- Texture (e.g., sandy, clayey)

In addition, for each sample location, the following attributes are always recorded:
- Latitude
- Longitude
- Country
- State/Province
- City/Town
- Elevation (in meters)

It is important to note that sometimes, multiple samples were collected at the same location. It is also always recorded the technician that performed the sampling, with the following data:
- First Name
- Last Name
- Email Address
- Affiliation

**Task:** 
1. Can you identify the entities and attributes of this scenario. Also identify possible relationships between entities. Represent it as a entity-relationship using a standard notation such as rectangles for entities, ellipses for attributes and diamonds for relationships.

### Problem 2. Scenario:
You have been tasked with designing a database to manage data related to water pollution in various bodies of water (e.g., rivers, lakes, oceans). The database should store information about water quality measurements, the locations where these measurements were taken, the pollutants found, and the monitoring agencies responsible. 

Requirements:

**a. Water Quality Measurement: Each measurement has the following attributes:**
- Date and Time of Measurement
- pH Level
- Dissolved Oxygen (DO) Level
- Turbidity
- Temperature
- Conductivity

**b. Location: Each location has the following attributes:**
- Latitude
- Longitude
- Country
- State/Province
- City/Town
- Body of Water (e.g., river, lake, ocean)

*c. Pollutant: Each pollutant has the following attributes:*
- Name
- Chemical Formula
- Maximum Permissible Limit (MPL) - the safe limit of this pollutant in water

*d. Monitoring Agency: Each monitoring agency has the following attributes:*
- Name
- Contact Person
- Email Address
- Phone Number

There are some constraints:
- Each Water Quality Measurement must be associated with one and only one Location.
- Each Water Quality Measurement can record the presence of multiple Pollutants.
- There can be multiple Water Quality Measurements taken at the same Location.
- Each Water Quality Measurement must be conducted by one and only one Monitoring Agency.

**Task:**

1. Create an Entity-Relationship Diagram (ERD) that represents the above requirements. Use standard notations such as rectangles for entities, diamonds for relationships. In this case, also define primary keys and foreign keys for each entity in the ERD.

