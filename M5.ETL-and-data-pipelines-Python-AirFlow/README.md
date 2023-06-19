# Creating ETL and data pipelines with Python and Apache AirFlow

## "ETL using Python" assignment overview

The data warehouse gets information from several sources including the transactional (OLTP) database. Transactional data from the OLTP database (in this case MySQL) needs to be propagated to the warehouse on a frequent basis.

Automating this sync-up with ETL pipeline will save up time, resources and standardize the process.

### Tasks

#### **Preparations**

- created MySQL database "sales" and imported data
- imported data to my IBM Db2 on Cloud server instance
- installed mysql-connector-python
- installed ibm-db

#### Configure mysqlconnect.py to be able to connect to MySQL server instance and expand practice commands (populate and query data)

```python
import mysql.connector

# connect to database
connection = mysql.connector.connect(user='root', password='norealpasswordhere',host='127.0.0.1',database='sales')

# create cursor
cursor = connection.cursor()

# create table
SQL = """CREATE TABLE IF NOT EXISTS products(
rowid int(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
product varchar(255) NOT NULL,
category varchar(255) NOT NULL)"""

cursor.execute(SQL)

print("Table created")

# insert data
SQL = """INSERT INTO products(product,category)
    VALUES
    ("Television","Electronics"),
    ("Laptop","Electronics"),
    ("Mobile","Electronics")
    """

cursor.execute(SQL)

connection.commit()

# query data
SQL = "SELECT * FROM products"

cursor.execute(SQL)

for row in cursor.fetchall():
    print(row)

# close connection
connection.close()
```

- configured db2connect.py to be able to connect to IBM Db2 on Cloud instance (with practice commands)

```python
import ibm_db

# connection details
dsn_hostname = "norealhostnamehere"
dsn_uid = "uid"
dsn_pwd = "norealpasswordhere"
dsn_port = "50000"
dsn_database = "bludb"
dsn_driver = "{IBM DB2 ODBC DRIVER}"           
dsn_protocol = "TCPIP"
dsn_security = "SSL"

# create the dsn connection string
dsn = (
    "DRIVER={0};"
    "DATABASE={1};"
    "HOSTNAME={2};"
    "PORT={3};"
    "PROTOCOL={4};"
    "UID={5};"
    "PWD={6};"
    "SECURITY={7};").format(dsn_driver, dsn_database, dsn_hostname, dsn_port, dsn_protocol, dsn_uid, dsn_pwd, dsn_security)

# create connection
conn = ibm_db.connect(dsn, "", "")

print ("Connected to database: ", dsn_database, "as user: ", dsn_uid, "on host: ", dsn_hostname)

# create table
SQL = """CREATE TABLE IF NOT EXISTS products(
    rowid INTEGER PRIMARY KEY NOT NULL,
    product varchar(255) NOT NULL,
    category varchar(255) NOT NULL)"""

create_table = ibm_db.exec_immediate(conn, SQL)

print("Table created")

# insert data
SQL = "INSERT INTO products(rowid,product,category)  VALUES(?,?,?);"
stmt = ibm_db.prepare(conn, SQL)

row1 = (1,'Television','Electronics')
ibm_db.execute(stmt, row1)

row2 = (2,'Laptop','Electronics')
ibm_db.execute(stmt, row2)

row3 = (3,'Mobile','Electronics')
ibm_db.execute(stmt, row3)

# query data
SQL="SELECT * FROM products"
stmt = ibm_db.exec_immediate(conn, SQL)

tuple = ibm_db.fetch_tuple(stmt)
while tuple != False:
    print (tuple)
    tuple = ibm_db.fetch_tuple(stmt)

# close connection
ibm_db.close(conn)
```



In this first part of the assignment, you will setup an ETL process using Python to extract new transactional data for each day from the MySQL database, transform it and then load it into the data warehouse in DB2.

You will begin by preparing the lab environment by starting the MySQL server. You will then create a sales database in MySQL and import the sales.sql file into the sales database. Next, you will verify your access to the cloud instance of the IBM DB2 server. You will then upload the sales.csv to a table in DB2. To do so, you will download the Python files that have the template code to connect to MySQL and DB2 databases.

The final task requires you to automate the extraction of daily incremental data and load yesterday's data into the data warehouse. You will download the python script from this link and use it as a template to write a python script that automatically loads yesterday's data from the production database into the data warehouse. After performing each task, take a screenshot of the command you used and its output, and name the screenshot.

Part 2: Data Pipelines using Apache AirFlow
Our data platform includes a Big Data repository that is used for analytics using Machine Learning with Apache Spark. This Big Data repository gets data from several sources including the data warehouse and the web server log. As data from the web server log is logged, it needs to be added to the Big Data system on a frequent basis - making it an ideal process to automate using a data pipeline.

In this second part of the assignment, you will create and run a DAG using Apache Airflow to extract daily data from the web server log, process it, and store it in a format to prepare it for loading into the Big Data platform.

To complete this part of the assignment, you will perform a couple of exercises, but before proceeding with the assignment, you will prepare the lab environment by starting the Apache Airflow and then downloading the dataset from the source (link provided) to the mentioned destination.

In the first exercise, you will perform a series of tasks to create a DAG that runs daily. You will create a task that extracts the IP address field from the webserver log file and then saves it into a text file. The next task requires you to filter out all occurrences of the ip address 198.46.149.143 from the text file and save the output to a new text file. In the final task, you will load the data by archiving the transformed text file into a TAR file. Before moving on to the next exercise, you will define the task pipeline as per the given details.

In the second exercise, you will get the DAG operational by saving the defined DAG into a PY file. Further, you will submit, unpause and then monitor the DAG runs for the Airflow console. After performing each task, take a screenshot of the command you used and its output, and name the screenshot.