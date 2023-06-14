# Setting up MongoDB as a NoSQL database for e-commerce organization "SoftCart"

"SoftCart" plans to use MongoDB to store the e-commerce catalog data.

Data is provided as "catalog.json" file.

## Importing data

![Alt text](mongoimport.png)

## Additional tasks

### Setting up mongoimport and mongoexport tools

![Alt text](setting_up_mongoimport_mongoexport.png)

![Alt text](checking_mongoimport_version.png)

### List all databases

![Alt text](list-dbs.png)

### List all collections in the database "catalog"

![Alt text](list-collections.png)

### Create an index on the field “type”

![Alt text](create-index.png)

### Write a query to find the count of laptops

![Alt text](mongo-query-laptops.png)

### Write a query to find the number of smartphones with screen size of 6 inches

![Alt text](mongo-query-mobiles1.png)

### Write a query to find out the average screen size of smartphones in catalog

![Alt text](mongo-query-mobiles2.png)

### Export the fields _id, “type”, “model”, from the ‘electronics’ collection into a file named electronics.csv

![Alt text](mongoexport.png)
