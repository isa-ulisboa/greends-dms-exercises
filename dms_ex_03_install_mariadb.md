# Data Management and Storage

# Exercise 3 - Install and configure MariaDB

The goal of this exercise is to setup your environment to have a functional and secure  MariaDB service for your databases. We will install and review the selected IDE tool - DBeaver - to work with the database, in addition to the terminal.

### Conventions of this document

In all commands, `$` indicates that it should be run at the operating system terminal. But `$` should not be included in the instruction. If the command prompt is `mysql>`, it means it should be run inside MariaDb.

## 1. Secure your MariaDB installation

After a new installation of MariaDB, it is recomended to execute the script `mysql_secure_installation`, particularly on production machines. Do execute, do the following at the MariaDB terminal
```bash
$ mysql_secure_installation
```
The script you make several questions. The first step will allow to create a `root` password. This is the administrator user of your MariaDB installation, so you should create a strong password, and keep it stored in a safe place.

Then, in the following questions, it is important to anwser the following:
- Remove anonymous users? `Y`
- Disallow root login remotelly? `Y`
- Remove test database and access to it? `Y` 

## Wrap up
We have secured your database server.

This concludes this exercise. In the next exercise, `sql_exercise_2_2.md`, you will learn how to create, backup and restore a database in mysql.
