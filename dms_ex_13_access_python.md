# Data Management and Storage

# Exercise 13 - Access to the database from Jupyter Notebook

The goal of this exercise is to learn how to make a connection to a database in
MySQL from a Jupyter Notebook.

## Introduction

It is possible to connect directly from a Jupyter Notebook to a MySQL or MariaBD
database. In this way, you can make queries directly to a database, and obtain 
the up-to-date data. Or you can load results from you analysis in Notebooks to 
the database, to persist them for future analysis.

The Jupyter Notebook will access to the MySQL databases using API calls. We will
use the module `ipyhton-sql` and `mysqlclient`. The latter will enable the connectiom
to the database, while the former allows to use ipython *magic* commands.


## Create a connection to MySQL from a Jupyter Notebook

1. If you haven't done before, you need to install the modules:

```
pip3 install ipython-sql
pip3 install mysqlclient
```

Remember that for running commands of the operating system commadn line inside a Jupyter
notebook, you need to use an exclamation mark `!`:
```
!pip3 install ipython-sql
!pip3 install mysqlclient
```

2. Import the modules
```
import MySQLdb
```
and the SQL *magic*
```
%load_ext sql
```

3. Configure the connection

The follwing line of code provides the configuration for the conenction. We need
to provide the `<database_name>`, `<database_user>` and `<mypassord>` for you
case.
```
mysql://`<username>`:`<password>`@`<localhost>`/`<dms_INE>`
```
4. Execute queries

```
result = %sql SELECT * FROM region LIMIT 10;
```
The result set will be stored in the variable `result`.

It is easy to import that result set to a dataframe:
```
pdf = result.DataFrame()
```

## An alternative method to make connections

Other way to establish a connection to a MySQL database is using the driver **MySQL Connector**. To install with pip, you can do:
```
pip install mysql-connector-python
```

A typical access to a database involves the following steps:
1. Import the modules
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

## Experiment in a Jupyter Notebook

Now that we have covered how to connect to MySQL from python, we can experiment with the 
Notebook `dms_ex_13_mysql_python.ipynb`, available in this repository. Download it and run it using your local Jupyter installation.

In this case, it is not possible to run it from a Google Colabs, because the local MySQL 
instance is not accessible from your cloud Colab instance.


