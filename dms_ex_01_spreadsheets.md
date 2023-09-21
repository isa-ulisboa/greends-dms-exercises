# Data Management and Storage

# Exercise 1 - OpenRefine - Good practices in the use of spreadsheets in data handling

## Introduction

In this exercise, we will identify the errors that can occur in data manipulation through a spreadsheet. Two programs will be used, MS Excel and (optionally) LibreOffice Calc, highlighting the advantages of each one in data manipulation.

Preparation for exercises

- Download the files in the [following link](https://drive.google.com/open?id=1AXtXHJY3uVZIQSOXr3rFBRiLYUosQZTS) to a directory on your desktop.


## 1. Manipulating opening and writing files


### 1. Difference between Open and Import for a text file (csv), in Excel


1. Open the file `dados_sampleQLDB_ex01_code01.csv` in Excel, with the menu sequence: File → Open  
2. Identify the type of problems you find in the following columns
    `Collector`, `Start Date`, `Country`, `Province`, `District`, `Locality Name`, `Collection`
3. Close the file without saving
4. Open a new Book in Excel.
5. Import the csv file with the menu sequence: **Data → From text**
6. Select the File Origin, so that the accents, cedillas, etc., appear correctly encoded. You may need to try with more than one type of origin. The most common are Unicode (UTF-8), Western Europe, Portuguese. In this case, it is UTF-8. To learn more about character encoding, please visit [Wikipedia](https://pt.wikipedia.org/wiki/Codifica%C3%A7%C3%A3o_de_caracteres).
7. Select the correct column delimiter. The most common are the tab, the comma, and the semicolon. Complete the import and view the file.
8. Close the file without saving


### 2. Open a csv file in LibreOffice (optional)


1. Open the file dados_sampleQLDB_ex01_code01.csv in LibreOffice Calc, with the menu sequence: **File → Open**
2. Select the Character set - UTF-8 - and separator - comma - in the text import panel that appears. Check in the preview if the file was correctly interpreted. 
3. Click OK.

### Discussion

- What are the differences in opening the files you found between the two programs?


### 3. Save data tables in csv text formats

Saving files in csv (comma separated values) formats is one of the best ways to ensure compatibility with other programs. Sometimes it is also necessary to change the character encoding of the file to ensure compatibility. In this exercise, the file `dados_sampleQLDB_ex01_code02.csv` will be opened and saved with a UTF-8 encoding.

1. Open the file `dados_sampleQLDB_ex01_code02.csv` in Excel, with the import procedure described above. You must find out which character code and column separator are correct.

2. Save the file with *Save as*, with the name `dados_sampleQLDB_ex01_code02_utf8.csv` and choosing the CSV UTF-8 (Comma delimited) (.csv) format.

3. Confirm that the file was saved with the desired character encoding:

    a. Re-import in Excel and check that the UTF-8 encoding results in the correct interpretation of the characters.

    b. Open the file with Notepad++ (or equivalent text editor) and check that the encoding detected in the lower bar is UTF-8.

4. Now, repeat the previous steps, opening the file `dados_sampleQLDB_ex01_code02.csv` with LibreOffice (optional).

5. Do *Save as*, add "_utf8" to the name, and select **Edit filter settings** in the options below the file type selection.

6. Verify that you can select multiple formats of character encoding, field delimiters, and text delimiters (string). Save as UTF-8, and separated by commas.

7. Verify in Notepad (or equivalent text editor) that the saved file has the UTF-8 encoding*


### Discussion

- What is the importance of controlling character encoding in data sets?

## 2. Common data quality operations

### 4. Identify and remove blank spaces

Blank spaces are often introduced into data inadvertently. For the computer, it functions as a character, influencing the matching of values or the ordering of lists. Blank spaces should be removed.

1. Make a copy of the file `dados_sampleQLDBP_ex01.xls` to do your exercise.

2. Open this copy with your spreadsheet of choice, Excel or Libreoffice.

3. Insert a column to the left, with the name `ID`, and numbered in series. This column is used to be able to return to the initial ordering of the file.

4. Sort by order, ascending the `Collectors` column. Make sure the area selected for sorting includes all data columns. Failure to select all data columns when sorting is one of the common causes of errors, and can be fatal if not checked in time.

5. Check, by browsing the column, that the order of the collectors is affected by the blank spaces. You can also check by adding an automatic filter (Autofilter).

6. Remove the blank spaces that exist at the beginning and end of the text. To do this

    a. Add a blank column to the right of the `Collectors` column

    b. Apply the TRIM formula (in PT, ARRUMAR), using the cell in the `Collectors` column as a parameter.

    c. Copy this column and paste it over the `Collectors` column, with *paste special -> values only*.

### 5. Using a reference list to automatically fill in values

Many times it is necessary to complete data related to a particular value. An example is the filling in of the various taxonomic levels for a species, from Kingdom to Genus, or the various administrative levels, from Country to Municipality, in the case of the parish. This can be done using reference lists and the VLOOKUP function (in Portuguese, PROCV), which allows you to establish correspondences between tables.

1. Open the file `lista_nomesCientificos_ex01.xls`

2. Copy the entire table to a new sheet of the data file `dados_sampleQLDBP_ex01.xls` that you have used so far. Call this sheet *taxon*

3. In the original table, insert 5 new columns before the Full Name column, and give them the following names: `Phylum`, `Class`, `Order`, `Family`, `Genus`

4. In the Phylum column, enter the following formula: `=VLOOKUP(AA, BB:CC, 4,0)`, where 
- *AA* corresponds to the cell that contains the name of the taxon for which you want to get the value of the phylum, 
- *BB:CC* to the table that contains in the first column the corresponding taxon and in the following columns the values that you want to get, 
- 3 is the number of the column that contains the value that you want to get, and 
- 0 corresponds to the FALSE value for the values of the relation to be ordered. 
In this case, if the `Full Name` column, which contains the names of the taxa that you want to match, is in column `T`, then the formula should be, for row 2, 
```
=VLOOKUP(T2,$taxon!A$1:H$398,4,0)
```
The use of the `$` symbol is important to fix the address of the start and end cell of the table that provides the information.

5. Copy the formulas for all remaining rows of the column.
    
6. Repeat this operation for the `Class` to `Genus` columns. Do not forget to adjust the number of the column from which you want to get the value of each column.

7. Verify, by browsing the table, that the values are well filled in.

> Explanation (with regards from Bard):
> 
> The VLOOKUP function allows you to search for a value in a table and return the value from another > column in the same row. In this case, we are using the VLOOKUP function to search for the name of the taxon in the lista_nomesCientificos_ex01.xls table and return the value of the Phylum column in the same row.
>
>The formula for the Phylum column is as follows:
>
> =VLOOKUP(AA, BB:CC, 4,0)
>
>> AA: The cell that contains the name of the taxon for which you want to get the value of the phylum.
>> BB:CC: The table that contains in the first column the corresponding taxon and in the following columns the values that you want to get.
> 4: The number of the column that contains the value that you want to get.
> 0: The FALSE value for the values of the relation to be ordered.
>
> For example, if the cell T2 contains the name "Homo sapiens", then the VLOOKUP function will return the value "Chordata" from the Phylum column in the lista_nomesCientificos_ex01.xls table.
>
>The remaining columns (Class, Order, Family, Genus) can be filled in using the same process.

### 8. Export to csv and verify the table

1. Save the file in CSV format, as in the previous exercise, with UTF-8 encoding.

2. Open the CSV file in Notepad++, and verify that:

a. The character encoding is correct.

b. The number of rows in the file corresponds to the number of rows in the Excel or LibreOffice table.

c. There are no blank spaces at the beginning of the collector values.

### Discussion:

How can the procedures performed help improve data quality?

## Wrap-up

In this exercise, we explored best practices to improve data quality when using a spreadsheet:
- import data to OpenRefine
- use facets to filter records
- transform values in selected rows
- reuse expressions
- fill down values
- copy values from one column to the other
- reorder columns
- export data
 
This concludes the current exercise.






