# Data Management and Storage

# Exercise 4 - Create, backup and restore a database

The goal of this exercise is to create a new database in MariaDB, create a new user, and provide privileges to that user to use the newly created database.

Although these operations can be done using an IDE like DBeaver, we will use the command line. The great advantage is that you will be able to reroduce these operations in any kind of environment (your machine, a remote machine in terminal, a virtual machine), even if you don't have access to a graphics interface.

### Conventions of this document

In all commands, "$" indicates that it should be run at the operating system terminal. But "$" should not be included in the instruction. If the command prompt is "mysql>", it means it should be run inside MariaDb.

## 1. Create a new database with 'mysqladmin'

The tool mysqladmin is a tool to administer the mariadb server. Check [this link](https://mariadb.com/kb/en/mysqladmin/) to see all the operations that it can do. In our case, we will use it to **create a new database**.

1. Open the mariadb terminal. Check that it is running by executing:
   ```
   $ mysql
   ```
   The expected response will be an error saying you cannot access to the database.

2. If `mysql` is running, then you shall have mysqladmin also available. We will create a database called *dms_2022*. To create the database, run:
   ```
   $ mysqladmin -u root -p create dms_2022
   ```
   **Explanation**

   In the above command, you are executing it as user root, "`-u root`" , informing the system to prompt for the password, "`-p`", and giving the command to create a database with the name provided, "`create dms_2022`".

2. After that, we need to login to MariaDB, to create a new user and provide credentials. Login to the database as root with the command:
   ```
   $ mysql -u root -p
   ```
   Enter the root password.

3. Inside MariaDB, we will create the user and provide privileges to the database at once. For that, run the following, but **remember to change the password** in the command:
   ```
   mysql> GRANT ALL PRIVILEGES ON dms_2022.* TO 'dms_user'@'localhost' IDENTIFIED BY 'mypassword';

   ```
   ```
   mysql> FLUSH PRIVILEGES;

   ```

   **Explanation**
   
   In the above command, you are providing all privileges to all tables of the database `dms_2022`, which is noted by the name of the database with the asterisc "*" (for all). These privileges are given to the user "`dms_user`" at the local machine "`localhost`", and using the specified password. If you want that user to be able to access to that database from a remote machine, then you should repeat the command, but replacing "`localhost`" by the IP address of that machine, or in case of any machime, by "`%`". Don't forget the "`;`" at the end of the command.

   Then, run flush privileges to make the system assume the new data immediately;

## 2. Create a backup of your database

Although your database is at the stage empty, we can create a backup of the database. To make a backup, we will use the script `mysqldump`, at the systems' terminal. The command is:
```
$ mysqldump -u root -p dms_2022 > dms_backup_2022-09-23.sql
```
The system will as for the `root` password. You could execute the command with the user `dms_user` instead of `root`.

This will create a new file `dms_backup_2022-09-23.sql` on the corrent location. You might want to adjust your output file with the corrent date. It is also possible to use a format in the output file to include automaticaly the date and time, for example, `dms_backup_$(date '+%Y-%m-%d_%H-%M').sql`. 

The mysqldump also has many options, like connecting to a remote host, or dumping data from a specific table.

Using `mysqldump` you can implement a shell script to make backups of your database regularly. There are many examples online of these scripts.

## 3. Restore a database

If you want to restore you database (to rever to a previous good state, before anyone made an erro, for example!), you can use the following:
```
$ mysql -u root -p dms_2022 < dms_backup_2022-09-23.sql
```
Again. this could be done with a user of the database, if it has the appropriate privileges.

## Wrap up
In this exercise we learned:
- how to create a new database and a database user;
- how to create a backup of our database;
- how to restore a database from a backup file.

This concludes this exercise. In the next exercise, `dms_ex_05_dbeaver.md`, you will get familiar with DBeaver and its interface.
