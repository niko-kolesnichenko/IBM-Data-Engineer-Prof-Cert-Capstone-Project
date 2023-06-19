# IBM Data Engineering Capstone Project

## Outline

As part of the Capstone project, I will assume the role of an Associate Data Engineer who has recently joined an e-commerce organization (SoftCart).
I am presented with a business challenge that requires building a data platform for retailer data analytics.

## Structure

I've created sub-folders in this repository, which correspond to listed tasks.

Each sub-folder has its own README.md file which is rendered by GitHub. These files contain tasks, my commentaries and solutions in easy readable form.

## Tasks

- design a data platform:
  - set up MySQL as an OLTP database
  - populate the OLTP Database with the data provided
  - automate the export of the daily incremental data into the data warehouse
  - set up MongoDB as a NoSQL database
  - load the E-Commerce catalog data into the NoSQL database
  - query the E-Commerce catalog data in the NoSQL database
- design and implement a data warehouse:
  - design the schema for a data warehouse based on the schema of the OLTP and NoSQL databases
  - create the schema and load the data into fact and dimension tables
  - automate the daily incremental data insertion into the data warehouse
  - create Cubes and Rollups to make the reporting easier
- create an ETL pipeline:
  - extract data from OLTP and NoSQL databases
  - transform data to suit data warehouse schema
  - load transformed data into the data warehouse
  - verify loaded data
- deploy a ML model for sales projections:
  - create a Spark connection to data warehouse
  - implement, train and deploy a ML model on SparkML
- design a reporting dashboard that reflects the key metrics:
  - create a Cognos data source that points to a data warehouse table
  - create bar, pie, line charts for selected metrics

## E-commerce organization user story

- SoftCart's online presence is primarily through its website, which customers access using a variety of devices like laptops, mobiles and tablets
- All the catalog data of the products is stored in the MongoDB NoSQL server
- All the transactional data like inventory and sales are stored in the MySQL database server
- SoftCart's webserver is driven entirely by these two databases
- To move data between OLTP, NoSQL and the data warehouse, ETL pipelines are used and these run on Apache Airflow
- Data is periodically extracted from these two databases and put into the staging data warehouse running on PostgreSQL
- The production data warehouse is on the cloud instance of IBM DB2 server
- SoftCart uses Hadoop cluster as its big data platform where all the data is collected for analytics purposes
- Spark is used to analyse the data on the Hadoop cluster
- BI teams connect to the IBM DB2 for operational dashboard creation. IBM Cognos Analytics is used to create dashboards

## E-commerce organization stack

- MySQL (OLTP)
- MongoDB (NoSQL)
- DB2 on Cloud as production data warehouse
- PostgreSQL as staging data warehouse
- Hadoop as Big Data platform
- Spark as Big data analytics platform
- IBM Cognos Analytics for BI tasks
- Apache Airflow for managing data pipelines
