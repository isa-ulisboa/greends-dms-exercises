# Data Management and Storage

# Exercise 2 - OpenRefine - Create tables with territorial units - NUTS

> An exercise submission via Moodle is required once completed. The deadline for submissions is **15th October 2024**.

> 1. Create a blank txt file formatted in markdown to add your responses to the questions identified in **Discussion points**, and submitted via Moodle before the deadline.
> 1. Submit also the final csv file of the exercise.

## Introduction

In this exercise, we will create five tables, corresponding to the several NUTS categories for Portugal (i.e. NUTS 1 to NUTS 3, Municipalities and Freguesias). We will use as data source the official data provided by INE. These data is provided as one file, so we will process them to create the several tables.

In each of the tables, we will create a foreign key of the parent unit. We will use OpenRefine for the exercise.

## 1. Download data from INE

**Suggestion**: before advancing to any tasks, organize your data project directories and files as discussed in FADS Exercise 4.

1. Go to [INE (Metainformation System)](https://smi.ine.pt/Categoria/Parent/3504), to path "SMI/Módulo classificações/Famílias/Classificações/Versões/Categorias" and export all to a *csv* or *xslx* file.


## 2. Import data to OpenRefine

1. In OpenRefine, select *Create project* and open the downloaded file
2. Adjust parameters in *Parse data as*, and click *Update preview* button to check changes:
    - Check Character encoding is appropriate
    - column delimiter (e.g. commas)
    - number of lines to ignore
    - Parse next __ lines as column header
3. When all looks fine, click *Create project*.

At this point, you should have your *OpenRefine* project with 3435 rows and three columns: `Nível`, `Código`, `Designação`. 

4. If you have more columns, remove them with 

   `Edit column --> Remove this column`


## 3. Create keys that match codes in INE data files

To be able to establish relations between NUTS and data tables from the Agricultural census, codes of territorial units need to match. Observing the census data, we can verify that for municipalities and freguesias, the code includes the code of the NUTS3 region they belong. Therefore, we need to create the codes with that format. We will use a similar approach as before:

1. Create a new text facet for the column `Nível`
2. In the `Nível` facet, select rows with values `1`, `2` and `3`.
3. Create a new column based on the column `Código`, with the name `codes`.
4. Reset the facet of `Nível` to have all rows available
5. Fill down values in column `codes`
6. Select in the facet `Nível` the rows with values `4` and `5`.
7. In column `codes`, concatenate values of this column with the ones in column `Código`. To do that, in column `codes`, select:
    
    `Edit cells --> Transform...`

    - In Expression, write 
      ```
      value+cells["Código"].value
      ```


## 4. Create parent codes

1. We need a new column for the parent codes of each territorial unit. Because our dataset is ordered with a hierarchy (the parent is above of all of its children), we will fill in our codes in several iterations:
    - In the facet of the column `Nível`, select the values `4`, which are the parent codes of all level `5` items
    - On the column `codes`, create a new column by doing 
      
      `Edit column --> Add column based on this column`

      - Give the new column name `parent_code`. 
      - Make sure that in Expression text box it contains `value`. Check the preview
      - Click ok
    - In the facet of `Nível`, include rows with value `5`
    - In the column `parent_code`, do 
    
      `Edit cells --> Fill down`

    - We will need to clear values in parent code on rows with level `4`. In the facet of `Nível`, exclude rows with value `5`. Then, in column `parent_code`, select 
      
      `Edit cells --> Common transforms --> To null` 

3. Repeat this process, but for rows with level `4`.
    - In the facet, select rows with value `3` (parents of level `4`)
    - Copy codes from column `codes` to `parent_code`. To do this, select in the later column:
      
      `Edit cells --> Transforms...`

      - In the expression, write 
        ```
        cells["codes"].value
        ```

      - Check the preview and click OK.
    - Include rows with value `4` in the facet. 
    - Do the fill down operation done before
    - Select in the facet only rows with value `3` and delete values from column `parent_code`

4. Repeat this process for rows with values `3` and `2`.

   **Note**: you can reuse code. For example, to copy values from the column `codes`, you can select *History* and reuse the expression

5. For rows with value `1`, the parent code is `PT`. You can add this manually.

6. For more easy reading, reorder your columns to `codes`, `parent_code`, `Nível`, `Código`, `Designação`. You can do this using the column `All`, and then `Edit columns --> Re-order / remove columns...`

## 5. Export tables

You can now export the tables for each NUTS level. For that, filter with the facet `Nível` the value for each level corresponding to the NUTS table you want to export, and then use on the button *Export* at the top-right corner. Export data as *csv* files, to a directory called *processed*, under folder *data*. 

> ## 6. Submission of exercise
> **Submit one files**:
> 1. Compress the *processed* directory using zip or similar
> 2. Submit the zipped file via Moodle
> 
> The submission in Moodle is at [Exercise 2 submission](https://elearning.ulisboa.pt/mod/assign/view.php?id=471157).

## Wrap-up

In this exercise, we used OpenRefine to organize our data in several tables. For that, we learned how to:
- import data to OpenRefine
- use facets to filter records
- transform values in selected rows
- reuse expressions
- fill down values
- copy values from one column to the other
- reorder columns
- export data
 
This concludes the current exercise.






