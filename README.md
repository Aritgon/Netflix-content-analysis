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
- Year by year content upload Trend.
- which genre contributed the most?
- which age group of audience does netflix target?
- which ratings of content is the most produced?
- average duration for movies. Do older movies tends to be more lengthy or is it the modern movies?
- avg seasons per generation for TV shows. is it the older generation shows that has more seasons in their show?
- seasonal content upload rate.
- Top contributing countries for each type of contents?


## Visual Insights

### Content type distribution : Movie vs TV Show
<img src="pngs/movie vs tv show.png" width = "600"/><br>
**🎯Insight:** _The netflix catalog is heavily skewed towards movies, which makes up around 70% of contents in netflix. TV Shows are at 30% of the netflix catalog._


### year by year content upload trend
<img src="pngs/year by year content type upload.png" width = "600"/><br>
**🎯Insight:** _While netflix began increasing additions of TV Shows starting from 2016, movies still consistently dominated the majority of the platform's catalog. TV Shows peaked in 2020, where for movies it was 2019. After that both format has seen a noticeable decline in new releases._


### Genre contributions : Top 10 Genre
<img src="pngs/top 10 genres.png" width = "600"/><br>
**🎯Insight:** _Internation Movies, Action & Adventure and Comedies, all three makes up to 54% of the netflix catalog, indicating a diverse audience preferences._


### Target audience by netflix
<img src="pngs/target audience group.png" width = "600"/><br>
**🎯Insight:** _Adults and Teens are the audience base which makes up to 91% of the audience, highlighting Netflix's Primary focus on these audience group. This consumer base likely contributes to higher engagement across the platform._


### Rating distribution
<img src="pngs/rating chart.png" width = "600"/><br>
**🎯Insight:** _TV-14 and TV-MA dominates Netflix's maturity rating, bringing out its strategic focus on teens and adult audiences who drive the majority of platform engagement(approximately 91% of engagement)._


### Average duration of movies per generation
<img src="pngs/generation wise movie timing.png" width = "600"/><br>
**🎯Insight:** _Movies from 1950s to 1990s had an average duration of 2 hours(approx. 119.66 minutes), whereas modern day movies have become shorter in duration(98.86 minutes). This suggests a well planned shift towards keeping content face-paced and full of entertainment, which helps to keep up with evolving short attention span of viewers across the world._


### Avereage seasons of TV Shows per generation
<img src="pngs/generation wise tv seasons.png" width = "600"/><br>
**🎯Insight:** _TV Shows also had an average season count of 3 per title. But in recent years, it dropped 2 seasons per title(1.76). This reflects Netflix's strategy of producing high volumes of short-timed series that goes well viewers short attention span._


#### Conclusion : 
💡_Netflix appears to prioritize high-volume content production with the both formats/types of content while keeping the duration short(approx 100 minutes of watch time for movies and 2 seasons of TV Shows). This strategy goes well with efficient budget maintaining and keeping the "binge watch trend" going on. This shows how value-driven Netflix is.


### Seasonal content upload rate.
<img src="pngs/seasonal content upload.png" width ="600"/><br>
**🎯Insight:** _Netflix maintains a relatively balanced release schedule throughout the year, with a slight spike during the months of summer. This may align with consumer behavior, as audiences tend to have more leisure time and prefer streaming content during the season of summer._


### Top contributing countries for each type of contents?
<img src="pngs/Top Contributing countries per type.png" width = "700"/><br>
**🎯Insight:** _Its the USA which is contributing more in both format of content type in Netflix with 44% share of movies and 35% TV Shows, Followed by India which is at 2nd position with 15% share of movies._



## 📍 Final thoughts & key takeaways
This case study explored Netflix's content strategy and its high audience engagement using SQL and EXCEL. Key findings include:
- **Movie dominance** remained strong which peaked in 2018. Though TV Shows have shown significant growth since 2016.
- **Genres like International Movies, Actions, adventures and Comedies** are the majority in Netflix's content catalog.
- **Target audience is primarily Teens and adults** which is shaping Netflix's content strategy.
- There's a noticeable shift towards producing **shorter contents in recent years**, reflecting bulk-production strategy.
- USA has produced 44% of movies and 35% of TV shows alone, helping in achieving Netflix's bulk production strategy.


## Thank you 👨‍💻