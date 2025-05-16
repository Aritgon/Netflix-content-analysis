# Netflix-content-analysis
![](pngs/image-12.png)

# Netflix SQL/Excel Case Study

## Project Overview
This project explores netflix's content library by analysing the underlying data using python libraries such as pandas, SQL(postgresql) and excel.

## Dataset Summary
This dataset contains information about netflix contents, including 'type', 'title', 'director', 'cast', 'country', 'date_added', 'release_year', 'rating', 'duration', 'listed_in', 'description' and 3 null flags generated using pandas.

This dataset's shape is (8807, 15).

## Data Cleaning
- handled null values in important column like 'country'.
- created 'date_added_null', 'rating_null', 'duration_null' in respective to their columns for targeting null values(this are the 3 null flag columns that is mentioned in dataset summary). 
- changed data_added datatype from object(string in SQL) to actual date format(YYYY-mm-dd).

## Key question and analysis
- which genre contributed the most?
- which age group of audience does netflix target?
- Top 10 actors who appeared in the most shows/titles?
- Top 10 directors who directed the most shows/titles?
- which ratings of content is the most produced?
- average movie duration. Do older movies tends to be more lengthy or is it the modern movies?
- avg seasons per generation for TV shows. is it the older generation shows that has more seasons in their show?
- Top contributing countries for each type of contents?
- seasonal content upload rate.
