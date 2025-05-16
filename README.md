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
- Movie vs TV Show?
- Quarterly upload trend. which quarter has the most contents uploaded?
- which genre contributed the most?
- which age group of audience does netflix target?
- Top 10 actors who appeared in the most shows/titles?
- Top 10 directors who directed the most shows/titles?
- which ratings of content is the most produced?
- average duration for movies. Do older movies tends to be more lengthy or is it the modern movies?
- avg seasons per generation for TV shows. is it the older generation shows that has more seasons in their show?
- Top contributing countries for each type of contents?
- seasonal content upload rate.


## Visual Insights

### Content Type Distribution : Movie vs TV Show
<img src="pngs/movie vs tv show.png" width = "600"/>
**🎯Insight:** _The netflix catalog is heavily skewed towards movies, which makes up around 70% of contents in netflix. TV Shows are at 30% of the netflix catalog._


### year by year content upload trend
<img src="pngs/year by year content type upload.png" width = "600"/>
**🎯Insight:** _While netflix began increasing additions of TV Shows starting from 2016, movies still consistently dominated the majority of the platform's catalog. TV Shows peaked in 2020, where for movies it was 2019. After that both format has seen a noticeable decline in new releases._


### Genre contributions : Top 10 Genre
<img src="pngs/top 10 genres.png" width = "600"/>
**🎯Insight:** _Internation Movies, Action & Adventure and Comedies, all three makes up to 54% of the netflix catalog, indicating a diverse audience preferences._
