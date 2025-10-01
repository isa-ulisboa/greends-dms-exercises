# Data Management and Storage

# Exercise 5 - Install and configure MariaDB

The goal of this exercise is to setup your environment to have a functional and secure  MariaDB service for your databases. We will install and review the selected IDE tool - DBeaver - to work with the database, in addition to the terminal.

> A confirmation of completing this exercise should be submitted via Moodle. The deadline for submissions is **24th October 2025**.

### Conventions of this document

In all commands, `$` indicates that it should be run at the operating system terminal. But `$` should not be included in the instruction. If the command prompt is `mysql>`, it means it should be run inside MariaDb.

## 1. Secure your MariaDB installation

After a new installation of MariaDB, it is recommended to execute the script `mysql_secure_installation`, particularly on production machines. Do execute, do the following at the MariaDB terminal
```bash
$ mysql_secure_installation
```
The script you make several questions. The first step will allow to create a `root` password. This is the administrator user of your MariaDB installation, so you should create a strong password, and keep it stored in a safe place.

Then, in the following questions, it is important to answer the following:
- Remove anonymous users? `Y`
- Disallow root login remotely? `Y`
- Remove test database and access to it? `Y` 

> ## Submission of exercise
> **Submit one file**:
> 1. Make a screenshot of your MariaDB installation in the terminal and submit it via Moodle.
> 
> The submission in Moodle is at [Exercise 5 submission](https://elearning.ulisboa.pt/mod/assign/view.php?id=477024).

## Wrap up
We have secured your database server.

This concludes this exercise. In the next exercise, `dms_ex_06_create_database.md`, you will learn how to create, backup and restore a database in mysql.
