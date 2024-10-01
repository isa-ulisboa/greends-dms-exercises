# Data Management and Storage

# Exercise 3 - OpenRefine - Data wrangling - Agricultural Census data

> An exercise submission via Moodle is required once completed. The deadline for submissions is **11th October 2024**.

> 1. Create a blank txt file formatted in markdown to add your responses to the questions identified in **Discussion points**, and submitted via Moodle before the deadline.
> 1. Submit also the final csv file of the exercise.

## Introduction

In this exercise, we will prepare rectangular tables from the data files downloaded from INE's data service. 

These files can be downloaded as xls or csv files. Although both formats have their pros and cons, we will use csv files as basis, and OpenRefine to do all data wrangling.

Additionally, we will structure the outputs in a format that will better fit the relationships that we created to manage our data. This means to join in the same table, data that represent the same entity but which download might have been done in separated files. This might also require structure data in new attributes (columns).

Our exercise will include several steps:
- download data from INE Agricultural Census about permanent crop areas per geographic region
- import data to OpenRefine
- change the structure of the data table
- merge data of all years in one table
- export as a csv file

## 1. Download data from INE

**Suggestion**: before advancing to any tasks, organize your data project directories and files as discussed in FADS.

The INE data service only allow to download data tables with a maximum of 40 000 values. This is a big limitation, because for many parameters that combine several dates, locations and parameters, the number is rapidly overcome. For that reason, we need to make partial downloads, as is the following case.

1. Go to [this link in INE (Database)](https://www.ine.pt/xportal/xmain?xpid=INE&xpgid=ine_indicadores&indOcorrCod=0010504&contexto=bd&selTab=tab2), which displays a table of the **Area of permanent crops (ha) by Geographic localization (NUTS -2013) and Type (permanent crops); Decennial (1)**.
2. Select **Change selection conditions**, and check *Select all* for **Geographic localization** (NUTS-2013). 
3. Select **Type (permanent crops)**, and click on the plus sign on the right panel near to **Total**. Select all the items on the first level of the tree open: *Fresh fruit plantations, Citrus plantations, Fruit plantations, ...*. The total cells should be 27488.
3. Select **Obtain table** and then on the icon **Download table (CSV format)**. Download the csv and give an appropriate name, for example, **area_perm_crops_2019.csv**.
4. This file only contains data for the year *2019*. Repeat the **Change selection conditions**, but select a different year. Download the csv file naming it appropriately.
5. When you finish the previous step, you should have four csv files downloaded.

## 2. Import data to OpenRefine

1. In OpenRefine, select *Create project* and browse to open the downloaded file with data for the year 2019.
2. Adjust parameters in *Parse data as*, and click *Update preview* button to check changes:
    - Check Character encoding is appropriate (possibly WINDOWS-1252)
    - column delimiter (e.g. ';')
    - if using Windows, ignore first 4 rows. If using Mac, ignore first 8 rows. This will make the next row to become column headers. To check, the first 5 columns should be the following:

      | Column | Column2 | Total | Fresh fruit plantations (excluding citrus plantations) | Citrus plantations |
      | ------ | ------ | ------ | ------ | ------ |
3. Click on the button *Create project*, on the top-right corner of the window.
4. Remove the first column on the left
5. Rename the new first column on the left (now named Column2), and call it `Region`.

## 3. Delete rows that contain no data

The file was imported with all the rows, including the ones that contain metadata (in the bottom). We need to remove them, in order to obtain a rectangular table. To keep only rows with data, we will use the column `Region` that contains the code and name of the region to identify the rows of interest.

Analyze the values on this column, and verify that the codes for a region always start with the number `1`, `2` or `3`, except for the country, which starts with `PT`. We will use this pattern to define a **regular expression**

1. Create a new text filter for the column `Region`, and check the box *regular expression*.
2. Enter the filter criteria 
   ```
   ^PT|^[1-3]
   ```

In the expression `^` means *starts with*, `PT` is the string that the value can start with, `|` means *or* and `^[1-3]` means *starts with a digit in the range between 1 and 3*.

3. Click *invert* in the top of the filter box. Now, if you are using Windows you should have 26 rows, and if you are using Mac you should have 34 rows. If you like, scroll through the file to confirm that no rows with region codes appear.
4. Click on column `All --> Edit rows --> Remove matching rows` to delete the rows. Then remove the filter.
5. Now, to double check all the correct rows were removed, in the `Total` Column go to `Facet --> Customized facets --> Facet by null`. Select `include` next to `true` results, to see that 3 rows were still included from our regular expression filter that should not have been. Delete these rows.
6. Remove all filters to obtain all remaining rows. Now you should have 3463 rows.

## 4. Transpose columns

In order to obtain the table in a normalized format, we need to transpose the columns into rows. This will allow to merge in the same table values for the several years.

1. In the column `Region`, select `Transpose --> Transpose cells across columns into rows...`
2. On the parameters panel of the operation, select from column *Total* to column *(last column)*. On the right, select *Two new columns*, with the name `Perm_crop` for the the *Key column* and `area_2019` for the *Value column*. Click *Transpose*. You should have now 27488 rows.
3. In the column `Region`, select `Edit cells --> Fill down`.
4. We need to create a primary key. We will do this by merging two columns in a new column. To do that:
   - in the column `Perm_crop` select

      `
      Edit column --> Add column based on this column...
      `
   - Give to the new column the name `primary_key`
   - In the Expression, enter 
   ```
   cells["Region"].value + value
   ```   

## 5. Repeat the operation for the other files

In step 1, you downloaded tables also for years 2009, 1999 and 1989. We will now repeat the operation for that tables. However, because all the csv files have the same initial structure (same number of rows and columns) as for the table 2019, we can use the script that OpenRefine created when processing that table to speed up the wrangling of the other tables.

1. Click *Open* in OpenRefine to create a new project, but keep the current project open.
2. Click on *Create project* and open the table for 2009, with the same parameters in *Parse data as*, as in the 2019 table. Create the project.
3. Let's copy the OpenRefine script of the 2019 project to apply it to the current 2009 project. 
   - Go to the 2019 project in its browser tab
   - On the top-left corner, click on *Undo/Redo* tab
   - Click on *Extract*, select all the script code and copy it
4. Go to the 2009 project, click *Undo/Redo* and then *Apply*
5. Paste the code to the opened panel, and then click the button *Perform operations*.
6. Rename the column `area_2019` to `area_2009`.
7. Repeat these operations for the data files of 1999 and 1989, with the needed adjustments in the last step.

## 6. Merge all projects into one

Data from all years should be merged in only one table. And, in order to comply with the normalization rules, we should not have partial dependencies. This means that the table should have one column with the area values, and another column for the year to which it corresponds, in addition to the columns with region and crop values. To achieve this, we need to join data from all four projects into one table.

This is possible with the function *Create column based on this column*. But in order to do this, we need to link the projects, making sure that the correct rows are related. For that we will use the column `primary_key` we create before. The general GREL expression to use is:
```
cell.cross('arg1','arg2').cells['arg3'].value[arg4]
```
 
- arg1 = name of project you are exporting data from
- arg2 = name of the key column
- arg3 = name of the column you are importing
- arg4 = indicate which value to import in the array (if multiple matches for the key) (recommended to use 0)

Let's perform the operation to join data from the project 2009 with project 2019:

1. In the 2019 project, in column `primary_key`, select

   `
   Edit column --> Add column based on this column...
   `

2. Give to the new column the name `area_2009`
3. In the expression, write 
   ```
   cell.cross('area perm crops 2009 csv', 'primary_key').cells['area_2009'].value[0]
   ```

   Make sure to adjust the expression to your case. In particular, the first argument in **cell.cross** function, that refers to the name of the project for 2009 data. Check in the preview panel that the values are being recovered

4. Click *OK* to create the new column. Confirm that all rows are fill in. You can do this by creating a facet to check blanks. To do this, in the newly created column, select

   `
   Facet --> Customized facets --> Facet by blank (null or empty string)
   `

   A new facet will be show which should not contain rows with true value 

5. Repeat the previous steps for the projects 1999 and 1989. You can reuse the GREL expression, available in the history of the *Add column based on column...* panel, but remember to adjust it, namely the name of the project you are exporting data and and of the name of the column that contains the values (arg1 and arg3 in the generic expression above).

## 6. Create the table in normalized form

To comply with the 3rd Normal Form, we need to change the format of the table, so that we have only one column with area values, for the corresponding year, region and crop. Therefore, the final table should have the following columns:
   - ID
   - Region
   - Crop
   - Year
   - area_ha

To achieve this, we will need to make the following operations:

1. The first is a transpose, as in step 4. In the column `primary_key` 
   - select *Transpose cells across columns into rows*, from **area_1989** to **last column**
   - give the name `year` to the Key Column and `area_ha` to the Value Column
   - check the box *Fill down in other columns*

2. In the column `year`, we need to change values by replacing text. Select in this column `Edit cells --> Replace`, placing in the *Find* box `area_`, and leaving the box *Replace with* empty.

3. In the column `area_ha`, **no data** values are represented by two hyphens separated by a space: `- -`. We need to replace that with an empty string, like in the previous step.

4. The column `Region` has the aggregated value of the ID of the NUTS region with its name. In the previous exercise, we created tables of NUTS to be imported to the database, where the codes are separated from the name. Therefore we need to have equivalent codes in this table. We can achieve this by split the values in `Regions`. In this column:
   - select `Edit column --> Split into several columns...`. 
   - Place the character `:` as separator.
   - uncheck the box *Guess cell type*
   - rename the new column `Region 1` as `codes`.
   - remove the column `Region 2`

5. The column `primary_key` is not valid as primary key anymore - can you explain why? You can delete it.

6. We can create a new column to serve as primary key, with an artificial key based on a sequence of numbers. To create it:
   - On the column `codes`, select `Add column based on this column...`
   - give the name `primary_key`
   - write in the expression 
      ```
      row.index + 1
      ```
      and click OK.

7. Reorder the columns to place the column `primary_key` as the first column. 


## 7. Export table

At this stage, your should have a table with 5 columns and 109952 rows. All the data wrangling to prepare a normalized table is completed. We will later create a key for crops, but this will be done in the database. 
You can now export the table as a csv file. Give the name area_crops_census2019.csv to the exported file, and place it in the folder *data_processing*.

## 8. Other entities
We will need to repeat the processing for other entities of the Agricultural census. The list of entities we need to get from the agricultural census is:
- temporary crops
- permanent crops
- lifestock
- education
- labour
- grassland
- production

> ## 9. Submission of exercise
> **Submit one file**:
> 1. Compress the *processed* directory using zip or similar
> 2. Submit the zipped file via Moodle
> 
> The submission in Moodle is at [Exercise 3 submission](https://elearning.ulisboa.pt/mod/assign/view.php?id=471529).




## Wrap up

In this exercise we learned:
- how to export data from INE
- how to import csv files into OpenRefine
- how to create special filters with regular expressions
- how to invert selections in filters and facets
- how to transpose in OpenRefine
- how to join data between OpenRefine projects

This concludes this exercise.







