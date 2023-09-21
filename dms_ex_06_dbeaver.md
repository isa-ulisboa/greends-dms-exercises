# Data Management and Storage

# Exercise 5 - Get familiarized with the DBeaver interface

**DBeaver** is a complete IDE opensource application for managing SQL project which allows to link to many different SQL databases. The application is very complete, but will focus on the features that we will use most on our course.

In this exercise, we are mainly interested in:
- creating and managing a connection to our database server
- execute SQL statements.

## 1. Make a database connection 

To be able to use a database, the first thing you need to do is to establish a connection to it. This principle is basic, either if you're using an IDE, as it is the case, or a custom application developed by you. Normally, to do this, you will use a driver previously developed in the community.

In the case of **DBeaver**, the community version includes drivers for many different SQL databases. The software also has a pro (paid) version, which includes drivers for NoSQL databases.

In order to establish a connection, you need to know the following elements:
- **name of the server** (or ip address)
- **database name**
- **username** and **password** of the database.

You have these elements from the previous exercise, when you created the database.

   1. Define a new connection
   
      In DBeaver, you create a new database connection in the menu 

      `Database --> New Database Connection` 

       Then select the database, in this case MariaDB. Click Next and enter the elements for **Server host**, **Database**, **Username** and **Password**. If your database is running in the same machine were you are running DBeaver, then the server host is `localhost`, which is included by default.

      The newly create connection definition will appear on the left panel of DBeaver interface, called **Database Navigator**. You can use the context menu (right-click with mouse) to see several options like connecting, disconnecting, SQL Editor to create a new SQL script, etc. 

## 2. Create a SQL script

To create a new SQL Editor window to execute your statements, right-click on top of the connection and open 
       
`
SQL Editor --> New SQL script
`

This will open a new tab on the right panel of DBeaver with the name **\<localhost\>Script 1**. It is important to check that the prefix corresponds to the name of your active connection, because you may have several scripts for different connections to various database servers.

You can save the SQL script you will create with the menu `File --> Save`.

## 3. The Database Navigator

The top left panel of DBeaver is called **Database Navigator**. This is were the connections you create appear. This panel has a tree-like navigation fashion. If you click on the arrow on the left of your connection name, it will show four dependencies, which are Databases, Users, Administer and System Info. Clicking on the arrow for Databases, it will show all databases accessible for this connection. 

Clicking on the arrow for a database, it will show the database components, including the tables. You can continue the sequence to see columns. In each of these levels of the tree, the right-click context menu will several operations that you can explore.

## 4. The ER Diagrams

On the bottom left panel you have tge **Project Explorer**. A particularly interesting functionality is the possibility to create ER Diagrams for a database. Use the context menu to explore the options you have.

To create amn ER for a particular database, click `Create a new ER Diagram`, give a name to your ER, browse to select a specific database and click on finish. The new diagram will appear on the right panel of DBeaver with tables, relationships, etc. You can right-click on top of the diagram to see different options of styles and attributes to be shown in the diagram.

## 5. Reset the interface

In the case your interface gets too confused, you can reset to the default using the menu

`
File --> Reset UI setting
`

## Wrap up

In this exercise we learned:
- to interpret the fundamentals of the DBeaver User Interface;
- how to create a connection to a database;
- how to create a SQL script to make queries to the database;
- how to navigate on the components of connection including databases, tables, table columns
- how to create ER diagrams for a database
- how to reset the UI of DBeaver to the default.

This concludes this exercise. In the next exercise, `dms_ex_06_create_tables.md`, you will create your first tables in the database and load them with data.


