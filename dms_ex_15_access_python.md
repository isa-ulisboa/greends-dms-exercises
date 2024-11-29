# Data Management and Storage

# Exercise 15 - Access to the database from Jupyter Notebook

The goal of this exercise is to learn how to make a connection to a database in
MySQL from a Jupyter Notebook.

## Introduction

It is possible to connect directly from a Jupyter Notebook to a MySQL or MariaBD
database. In this way, you can make queries directly to a database, and obtain 
the up-to-date data. Or you can load results from you analysis in Notebooks to 
the database, to persist them for future analysis.

The Jupyter Notebook will access to the MySQL databases using API calls. We will
use the module `mariadb` and `PyMySQL`. The former is a native driver to make 
connections to a MariaDB database. The later is a pure python  generic library 
that will provided more compatibility among different OS systems.


## Create a connection to MySQL from a Jupyter Notebook with mariadb library

1. If you haven't done before, you need to install the modules:

```
pip install mariadb
```

Remember that for running commands of the operating system command line inside a Jupyter
notebook, you need to use an exclamation mark `!`:
```
!pip install mariadb
```

2. Import the modules
```
import mariadb
```

3. Configure the connection

The following line of code provides the configuration for the connection. We need
to provide the `<hostname>`, `<database_name>`, `<database_user>` and `<password>` 
for you case.
```python
conn = mariadb.connect(
    host="localhost",
    user="database_user",
    password="password",
    database="database_name"
)
```
4. Execute queries

First, we need to create a cursor, using the connection created:
```python
cur = conn.cursor()
```
We can use the cursor to execute SQL queries
```python
cur.execute("SELECT * FROM <table_name>")
```
Results of the query will be stored in the cursor. We can get and print the first result:

```python
result = cur.fetchone()
print(result)
```

Or we can obtain all results:
```python
result = cur.fetchall()
```
And create a Pandas Dataframe containing all results:
```python
import pandas as pd
df = pd.DataFrame(result)
```


## An alternative method to make connections

Other way to establish a connection to a MySQL database is using the driver **PyMySQL**. To install with pip, you can do:
```
pip install pymysql
```

A typical access to a database involves the following steps:
1. Import the module
```python
import pymysql
```
2. Create a connection and run queries. You will provide the name or address of the server, 
the user, the database and the password
```python


import pymysql 
# Open database connection 
conn = pymysql.connect(
    host="localhost",
    user="database_user",
    password="password",
    database="database_name"
)

# Create a cursor object 
cursor = conn.cursor() 

# Execute SQL query 
cursor.execute("SELECT * FROM <table_name>") 

# Fetch all rows 
rows = cursor.fetchall()
 
for row in results: 
print(row)
# Close database connection 
db.close()
```
You need to replace  `<database_name>`, `<database_user>` and `<password>` by 
the actual values in your case.


## Execute queries to insert data
You can execute a query to insert data to the database. First, import the module
and create the connection

1. Import module and create a connection:
```python
import pymysql

conn = pymysql.connect(
    host="localhost",
    user="database_user",
    password="password",
    database="database_name"
)
```

2. Create a cursor
```python
cursor = connection.cursor()
```

3. Prepare your SQL insert query
```python
# this inserts three string values and one numeric value
sql_query = '''
INSERT INTO <table_name> 
(
   <column_01>, 
   <column_01>, 
   <column_01>, 
   <column_01>
) 
VALUES (%s, %s, %s, %d)
'''
```

4. Define to be inserted
```python
data = ("string 1", "string 3","string 3","value 1",)
```

5. Execute the query
```python
cursor.execute(sql_query, data)
```

6. Commit the changes
```python
connection.commit()
```

7. Close the cursor and the connection
```python
cursor.close()
connection.close()
```

## Experiment in a Jupyter Notebook

Now that we have covered how to connect to MySQL from python, we can experiment with the 
Notebook `dms_ex_15_mysql_python.ipynb`, available in this repository. 
Download it and run it using your local Jupyter installation. The exercise assumes
your have the version 2 of the database `dms_INE`, that resulted in the end of 
exercise 13.

In this case, it is not possible to run it from a Google Colabs, because the local MySQL 
instance is not accessible from your cloud Colab instance.


