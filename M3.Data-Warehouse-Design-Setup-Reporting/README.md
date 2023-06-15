# Implementing a data warehouse for "SoftCart"

SoftCart has international presence and customers from all over the world, and deals in e-books, movies and songs (streaming and downloads).

The company would like to create a data warehouse so that it can create the following reports:

- total sales per year per country
- total sales per month per category
- total sales per quarter per country
- total sales per category per country

SoftCart has provided sample data:

![Alt text](ecom-sample-data.png)

## Designing a star schema

### Designing dimension table softcartDimDate

SoftCart's requirements for reports state a granularity of a day.

Therefore, dimension table for date and its parts will include day, day of the week, weekday number, month, name of the month, year, quarter and name of the quarter.

![Alt text](softcartDimDate.png)

### Designing dimension table softcartDimCategory

Judging by sample, we have only 3 categories: "Movie", "Ebook" and "Song".

### Designing dimension table softcartDimItem

Sample data has movies, songs and ebooks in it.

Interestingly, the longest book title is currently at 27,978 characters!

But I think that in absence of detailed information I will stop at 300 characters for "item_name", which will hold the longest song title, all movie titles and 99% of book titles out there.

### Designing dimension table softcartDimCountry

Straightforward, with varchar(56) for the name.

#### Results for softcartDimCategory, softcartDimItem, softcartDimCountry

![Alt text](dimtables.png)

### Designing fact table softcartFactSales

![Alt text](softcartFactSales.png)

### Setting up relationships

![Alt text](softcartRelationships.png)

### Generating SQL script from ERD tool

[ERD-to-SQL-generated-schema.sql](ERD-to-SQL-schema.sql)

### Creating schema in new database named "staging" using generated SQL script

![Alt text](createschema.png)

## Working with IBM Db2 on cloud

### Loading data into the data warehouse

I've been provided with .csv files for each table (softcartDimDate, etc.). These tables aren't exactly the same as those I've designed.

![Alt text](DimDate_loading.png)

### Additional tasks

#### Create a grouping sets query using the columns "country", "category", "totalsales"

![Alt text](groupingsets.png)

#### Create a rollup query using the columns "year", "country", and "totalsales"

![Alt text](rollup.png)

#### Create a cube query using the columns "year", "country", and "average_sales"

![Alt text](cube.png)

#### Create an MQT named "total_sales_per_country" that has the columns "country" and "total_sales"

![Alt text](mqt.png)
