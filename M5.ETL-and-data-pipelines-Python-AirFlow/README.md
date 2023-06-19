# Creating ETL and data pipelines with Python and Apache AirFlow

## Assignment overview

### Part 1. ETL using Python

The data warehouse gets information from several sources including the transactional (OLTP) database. Transactional data from the OLTP database (in this case MySQL) needs to be propagated to the warehouse on a frequent basis.

Automating this sync-up with ETL pipeline will save up time, resources and standardize the process.

### Part 2. Data Pipelines using Apache AirFlow

SoftCart's data platform includes a Big Data repository that is used for analytics using ML with Apache Spark.

This Big Data repository gets data from several sources - including the data warehouse and the web server log. As data from the web server log is logged, it needs to be added to the Big Data system on a frequent basis - making it an ideal process to automate using a data pipeline.

## Solution

### Part 1. "ETL using Python" tasks

#### Preparations

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

#### Configure db2connect.py to be able to connect to IBM Db2 on Cloud instance and expand practice commands (populate and query data)

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

#### Implement the function get_last_rowid()

This function must connect to the DB2 data warehouse and return the last rowid.

```python
def get_last_rowid():
    SQL = "SELECT MAX(ROWID) FROM sales_data"
    stmt = ibm_db.exec_immediate(conn, SQL)
    res = ibm_db.fetch_both(stmt)
    print(res)
    return int(res[0])
```

#### Implement the function get_latest_records()

This function must connect to the MySQL database and return all records later than the given last_rowid.

```python
def get_latest_records(rowid):
    SQL = "SELECT * FROM sales_data WHERE rowid > %s"
    cursor.execute(SQL, [rowid])
    latest_records = cursor.fetchall()
    return latest_records
```

#### Implement the function insert_records()

This function must connect to the DB2 data warehouse and insert all the given records.

```python
def insert_records(records):
    SQL = "INSERT INTO sales_data(rowid,product_id,customer_id,quantity) VALUES(?,?,?,?);"
    stmt = ibm_db.prepare(conn, SQL)

    for record in records:
        ibm_db.execute(stmt, record)
```

#### Collate all functions and connection scripts into one "automation.py" file

```python
# import libraries required for connecting to MySQL
import mysql.connector

# import libraries required for connecting to IBM Db2 on Cloud
import ibm_db

# implement the function get_last_rowid()
def get_last_rowid():
    SQL = "SELECT MAX(ROWID) FROM sales_data"
    stmt = ibm_db.exec_immediate(conn, SQL)
    res = ibm_db.fetch_both(stmt)
    print(res)
    return int(res[0])

# implement the function get_latest_records()
def get_latest_records(rowid):
    SQL = "SELECT * FROM sales_data WHERE rowid > %s"
    cursor.execute(SQL, [rowid])
    latest_records = cursor.fetchall()
    return latest_records

# implement the function insert_records()
def insert_records(records):
    SQL = "INSERT INTO sales_data(rowid,product_id,customer_id,quantity) VALUES(?,?,?,?);"
    stmt = ibm_db.prepare(conn, SQL)

    for record in records:
        ibm_db.execute(stmt, record)

# connect to MySQL
connection = mysql.connector.connect(
    user='root',
    password='norealpasswordhere',
    host='127.0.0.1',
    database='sales')

cursor = connection.cursor()

# connect to IBM Db2 on Cloud
dsn_hostname = "norealhostnamehere"
dsn_uid = "uid"
dsn_pwd = "norealpasswordhere"
dsn_port = "50000"
dsn_database = "bludb"
dsn_driver = "{IBM DB2 ODBC DRIVER}"           
dsn_protocol = "TCPIP"
dsn_security = "SSL"

dsn = (
    "DRIVER={0};"
    "DATABASE={1};"
    "HOSTNAME={2};"
    "PORT={3};"
    "PROTOCOL={4};"
    "UID={5};"
    "PWD={6};"
    "SECURITY={7};").format(dsn_driver, dsn_database, dsn_hostname, dsn_port, dsn_protocol, dsn_uid, dsn_pwd, dsn_security)

conn = ibm_db.connect(dsn, "", "")

print ("Connected to database: ", dsn_database, "as user: ", dsn_uid, "on host: ", dsn_hostname)

# find out the last rowid from Db2 data warehouse
last_row_id = get_last_rowid()

print("Last rowid in Db2 data warehouse: ", last_row_id)

# list out all records in MySQL database with 
# rowid greater than the one on the Data warehouse
new_records = get_latest_records(last_row_id)

print("Listing latest records:\n")

for row in new_records:
    print(row)

print("Finished listing latest records.")

# insert the additional records from MySQL into DB2 data warehouse
insert_records(new_records)

# disconnect from mysql warehouse
connection.close()

# disconnect from DB2 data warehouse
ibm_db.close(conn)
```

### Part 2. "Data Pipelines using Apache AirFlow"

The task is: "Write a pipeline that analyzes the web server log file, extracts the required lines (ending with html) and fields (timestamp, size), transforms (bytes to MB) and loads (append to an existing file), using "accesslog.txt".

#### Define the DAG arguments

DAG must contain at least these arguments: owner, start_date, email.

```python
default_args = {
    'owner': 'Niko',
    'start_date': days_ago(0),
    'email': ['test@gmail.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes = 5)
}
```

#### Create a DAG named "process_web_log" that runs daily

```python
dag = DAG(
    'process_web_log',
    default_args = default_args,
    description = "process_web_log for capstone project',
    schedule_interval = timedelta(days = 1)
)
```

#### Create an extraction task named "extract_data"

This task should extract the "ipaddress" field from the "accesslog.txt" and save it into "extracted_data.txt".

```python
extract_data = BashOperator(
    task_id = 'extract_data',
    bash_command = 'cut -d" " -f1 /home/project/airflow/dags/capstone/accesslog.txt > /home/project/airflow/dags/capstone/extracted_data.txt',
    dag = dag
)
```

#### Create a task to transform the data in the .txt file

Create a task named "transform_data". This task should filter out all the occurrences of ipaddress “198.46.149.143” from "extracted_data.txt" and save the output to a file named "transformed_data.txt".

```python
transform_data = BashOperator(
    task_id = 'transform_data',
    bash_command = 'cat /home/project/airflow/dags/capstone/extracted_data.txt | grep “198.46.149.143” > /home/project/airflow/dags/capstone/transformed_data.txt',
    dag = dag
)
```

#### Create a task to load the data

Create a task named "load_data". This task should archive the file "transformed_data.txt" into a .tar file named "weblog.tar".

```python
load_data = BashOperator(
    task_id = 'load_data',
    bash_command = 'tar -cvf /home/project/airflow/dags/capstone/weblog.tar /home/project/airflow/dags/capstone/transformed_data.txt',
    dag = dag
)
```

#### Define the task pipeline

```python
# task pipeline
extract_data >> transform_data >> load_data
```

#### Submit DAG as "process_web_log.py"

```terminal
sudo cp process_web_log.py $AIRFLOW_HOME/dags
```

#### Unpause the DAG

```terminal
airflow dags unpause process_web_log
```
