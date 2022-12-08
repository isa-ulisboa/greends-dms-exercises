# Data Management and Storage

# Exercise 13 - Access to the database from Jupyter Notebook

The goal of this exercise is to learn how to make a connection to a database in
MySQL from a Jupyter Notebook.

## Introduction

It is possible to connect directly from a Jupyter Notebook to a MySQL or MariaBD
database. In this way, you can make queries directly to a database, and obtain 
the up-to-date data. Or you can load results from you analysis in Notebooks to 
the database, to persist them for future analysis.

The Jupyter Notebook will access to the MySQL databases using API calls. The 

## How the connection to the database from python works?

A typical access to a database involves the following steps:
1. Import the connector
```
import mysql.connector
```
2. Create a connection. You will provide the name or address of the server, 
the user, the database and the password
```
conn = mysql.connector.connect(
    host = 'localhost',
	database = '<database_name>'
    user = '<database_user>',
    password = '<mypassword>'
)
```
You need to replace  `<database_name>`, `<database_user>` and `<mypassord>` by 
the actual values.


3. Execute the queries
You can execute a query and import the result to a Pandas datafrane with the 
following code:

```
import pandas as pd

query = ("SELECT NutsID, region_name FROM region WHERE region_level = 4")

result_df = pd.read_sql(query, conn)
```

4. Close the connection
```
conn.close()
```




