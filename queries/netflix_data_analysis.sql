-- create the table for netflix data.

CREATE TABLE if not exists netflix (
    show_id TEXT PRIMARY KEY,
    "type" TEXT,
    title TEXT,
    director TEXT,
    "cast" TEXT,
    country TEXT,
    date_added DATE,
    release_year INTEGER,
    rating TEXT,
    duration TEXT,
    listed_in TEXT,
    description TEXT
);

-- finding out null values.
select
	count(*) as total_count,
	count(director) as director_count,
	count(*) - count(director) as null_count
from netflix;

-- updating those null values.
update netflix
set director = 'unknown' 
where director is null;

update netflix
set "cast" = 'unknown'
where "cast" is null;

update netflix
set country = 'unknown'
where country is null;

-- Task 1: Catalog Consistency Check.

with movie_count as (
	select
		count(*) as counts
	from netflix 
	where type in ('Movie')
	),
Tv_show as (
	select
		count(*) as counts
	from netflix
	where type in ('TV Show')
)

select
	mc.counts,
	ts.counts
from Tv_show as ts
cross join movie_count as mc;

-- Task 2: Recent Additions Audit.

select
	release_year,
	count(*) as yearly_title_count
from netflix
group by release_year
order by yearly_title_count desc;

-- Task 3: Content Type Trend.

select
	release_year,
	type,
	count(*) as content_count
from netflix
group by release_year, type
order by release_year desc, content_count desc;

-- more indepth trend finds using windows
select *
from (select release_year, type, count(*), row_number()
over(partition by release_year order by count(*) desc) as ranking from netflix group by release_year, type order by release_year desc) as new
where ranking = 1;


-- Task 4: Top Contributing Countries. (needed to unnest because of many values being present in a single row).
-- string_to_array : separates the comma separated string values of countries into an array.
-- unnest : this will expand the array into multiple rows, giving each value its own row.

with cleaned_data as (
	select
		type,
		unnest(string_to_array(country, ', ')) as country
	from netflix
	where country != 'unknown'
	)
	
select
	country,
	type,
	count(*) as produced_content_count
from cleaned_data
group by country, type
order by produced_content_count desc;

-- without types.
with cleaned_data as (
	select
		unnest(string_to_array(country, ', ')) as country
	from netflix
	where country != 'unknown'
	)
	
select
	country,
	count(*) as produced_content_count
from cleaned_data
group by country
order by produced_content_count desc;

-- Task 5: Top contributing genre trends and type contribution.

with clean_data as (
	select
		unnest(string_to_array(listed_in, ', ')) as listed_in
	from netflix
)

select 
	listed_in,
	count(*) as content_count
from clean_data
group by listed_in
order by content_count desc;

-- Task 5.2 — Top Genres by Content Type.

with clean_data as (
	select
		type,
		unnest(string_to_array(listed_in, ', ')) as genre
	from netflix
)
select
	type,
	genre,
	count(*) as content_count
from clean_data
group by type, genre
order by content_count desc;


-- Task 6: Find the Most Frequent Directors.
with director_clean as (
	select
		title,
		type,
		unnest(string_to_array(director, ', ')) as director
	from netflix
	where director not in ('unknown')
)
select
	director,
	type,
	count(title) as title_produced
from director_clean
group by director, type
order by title_produced desc;


-- Task 7: Analyze Ratings Distribution.
-- we have some null data in rating column so lets change that to unknown rating.

update netflix
set rating = 'unknown'
where rating is null;

select
	rating,
	count(*) as contents
from netflix
group by rating
order by contents desc;

-- Task 9: Find the Most Common Rating by Type (Movie vs TV Show).
select
	type,
	rating,
	count(rating) as rating_count
from netflix
group by type, rating
order by type, rating_count desc;

-- Task 10: Find the top 10 most common words used in the titles of Netflix content.
-- we can't use string_to_array and unnest because we aren't dividing with delimiters like " " or ,. we need divide those literals too.
with word_count as (
	select
		lower(regexp_split_to_table(title, '\s+')) as word
	from netflix
	)

select
	word,
	count(word) as w_count
from word_count
group by word
order by w_count desc;

-- Task 11: Content Longevity Analysis.
select * from netflix;

with extract_year as (
	select
		show_id,
		type,
		title,
		release_year,
		extract(year from date_added) as added_year,
		extract(year from date_added) - release_year as gap_of_year
	from netflix
	where release_year is not null and date_added is not null
	)

select
	type, 
	round(avg(gap_of_year), 2) as avg_gap
from extract_year
group by type;

-- lets make days of gap. But firstly we need to format the column 'release_year', 
-- which is just contains INT values of year, e.g. 2021, 1943 etc.
-- so we need concat it using '-1-1' like 1943-01-01 etc.

-- **although it may provide more granularity, but it could've been better if the dataset had the actual date of release_year.

select
	date(concat(release_year, '-01-01')) as release_year,
	date(date_added) as date_added
from netflix;

with date as (
	select
		type,
		title,
		date(concat(release_year, '-01-01')) as release_year,
		date(date_added) as date_added,
		date(date_added) - date(concat(release_year, '-01-01')) as gap_of_Days
	from netflix
	)

select
	type,
	round(avg(gap_of_days), 2) as avg_gap
from date
group by type;

--  Task 11: Duration Analysis — Movie Lengths & Show Seasons.
-- split_part(text, delimiter, field_number).
-- we also type casted it.

-- Movie part.
with duration_split as (
	select
		title,
		SPLIT_PART(duration, ' ', 1)::integer as duration
	from netflix
	where type in ('Movie')
	)
select
	round(avg(duration) ,2) as avg_duration,
	max(duration) as max_duration,
	min(duration) as min_duration
from duration_split;

-- binning cinemas.

with duration_split as (
	select
		title,
		split_part(duration, ' ', 1)::integer as duration
	from netflix
	where type in ('Movie')
)

select
	case
		when duration < 60 then 'under 60 minutes'
		when duration between 61 and 120 then 'under 2 hours'
		when duration between 121 and 180  then 'under 3 hours'
		else '3+ hours'
	end as movie_category,
	count(title) as content_count
from duration_split
group by movie_category
order by content_count desc;

-- binning Tv Shows.

with duration_split as (
	select
		title,
		split_part(duration, ' ', 1)::integer as season
	from netflix
	where type in ('TV Show')
)

select
	case
		when season < 3 then 'under 3 seasons'
		when season between 3 and 7 then 'under 7 seasons'
		when season between 8 and 12 then 'under 12 seasons'
		else '12+ seasons'
	end as TV_Show_category,
	count(title) as content_count
from duration_split
group by TV_Show_category;

-- TV Show part.
select
	min(split_part(duration, ' ', 1)::integer) as min_season,
	max(split_part(duration, ' ', 1)::integer) as max_season,
	round(avg(split_part(duration, ' ', 1)::integer), 2) as avg_season
from netflix
where type in ('TV Show');


-- Task 12 : Monthly Additions Trend.
select
	extract(month from date_added) as months,
	type,
	count(*) as content_count
from netflix
where extract(month from date_added) is not null
group by extract(month from date_added), type;

-- Task 13 : Seasonal Additions (Winter, Spring, etc).

with clean_data as (
	select
		extract(month from date_added) as months,
		type,
		count(*) as content_count
	from netflix
	where extract(month from date_added) is not null
	group by extract(month from date_added), type
	)
select
	case
		when months in (1,2,12) then 'winter season'
		when months in (3,4,5) then 'spring season'
		when months in (6,7,8) then 'summer season'
		when months in (9,10,11) then 'fall season'
	end as seasons,
	type,
	sum(content_count) as content_count
from clean_data
group by seasons, type
order by seasons;

-- task 14 : Count by Rating.
select distinct rating from netflix;

select
	rating,
	count(*) as content_count
from netflix
group by rating;

-- task 15 : Ratings by Content Type.
select
	type,
	rating,
	count(*) as rating_count
from netflix
group by type, rating
order by rating_count desc;

-- task 16 : Audience Classification or binning consumers based on rating.
update netflix
set rating = 'unknown'
where rating is null;

with rating_count as (
	select
		rating,
		count(*) as rating_count
	from netflix
	where rating not in ('74 min', '66 min', '84 min')
	group by rating
	)

select
	case
		when rating in ('G', 'TV-Y', 'TV-Y7', 'TV-Y7-FV', 'TV-G') then 'kids'
		when rating in ('PG', 'PG-13', 'TV-PG', 'TV-14') then 'teens'
		when rating in ('R', 'TV-MA', 'NC-17', 'UR', 'NR') then 'adult'
	end as content_category,
	sum(rating_count) as content_count,
	rank() over(order by sum(rating_count) desc) as ranking
from rating_count 
where rating is not null
group by content_category;

-- step : Director & Cast Insights.
-- Task 17 : Most Frequent Directors.

with clean_data as (
	select
		title,
		lower(regexp_split_to_table(director, ', ')) as director
	from netflix
	where director != 'unknown'
	)
select
	director,
	count(title) as title_count,
	rank() over(order by count(title) desc) as ranking
from clean_data
group by director;

-- Task 18 : Top Cast Members (Optional/Advanced).

with cast_split as (
	select
		title,
		lower(regexp_split_to_table("cast", ', ')) as casts
	from netflix
	where title != 'unknown' and "cast" != 'unknown'
	)

select
	casts,
	count(title) as titles_they_acted,
	rank() over(order by count(title) desc) as ranking
from cast_split
group by casts;

-- Task 19 : MoM upload rate.

with monthly_uplaod as (
	select
		to_char(date_added, 'yyyy-mm') as date_added,
		count(*) as content_count
	from netflix
	where date_added is not null
	group by to_char(date_added, 'yyyy-mm')
	),

	prev_month as (
	select
		date_added,
		content_count,
		lag(content_count) over(order by date_added) as prev_month_count
	from monthly_uplaod
	)

select
	date_added,
	content_count,
	prev_month_count,
	content_count - prev_month_count as quantity_gap,
	round((content_count - prev_month_count) * 100 / prev_month_count, 2) as MoM_trend
from prev_month;

/* step : Country & Category Intersection */
-- Task 20 : Most Popular Genres by Country.

with cleaning_1 as (
	select
		trim(unnest(string_to_array(country, ','))) as countries,
		trim(unnest(string_to_array(listed_in, ','))) as genre
	from netflix
	),

	cleaning_2 as (
	select
		countries,
		genre,
		count(genre) as genre_count,
		rank() over(partition by genre) as ranking_per_genre
	from cleaning_1
	where (countries is not null and countries != 'unknown') and (genre is not null and genre != 'unknown')
	group by countries,
		genre
)
select *		
from cleaning_2 countries order by genre_count desc;

-- Task 21 : Country & Content Type Breakdown.
select
	trim(unnest(string_to_array(country, ','))) as countries,
	type,
	count(type) as type_count,
	rank() over(order by count(type) desc) as ranking_per_type
from netflix
where country is not null and country != 'unknown'
group by countries, type;

-- Task 22 : YoY addition Trends.
with yearly_upload as (
	select
		extract(year from date_added) as adding_year,
		count(title) as title_count_per_year,
		lag(count(title)) over(order by extract(year from date_added)) as prev_year_production_count
	from netflix
	where extract(year from date_added) is not null
	group by adding_year
	)
select
	adding_year as active_year,
	title_count_per_year,
	prev_year_production_count,
	(title_count_per_year - prev_year_production_count) as content_upload_gap,
	round((title_count_per_year - prev_year_production_count) * 100 / prev_year_production_count, 2) as upload_gap_rate
from yearly_upload
where prev_year_production_count is not null;

-- Github polishing and project preparing.
-- counting null rows so that I can give a measurement of how much data is 'clean' and how much data is 'obsolete'.

with filter_report as (
	select
		count(*) as total_row_count,
		COUNT(*) FILTER (WHERE title IS NULL OR title = '' or title = 'unknown') AS null_title,
	    COUNT(*) FILTER (WHERE "cast" IS NULL OR "cast" = '' OR "cast" = 'unknown') AS null_cast,
	    COUNT(*) FILTER (WHERE director IS NULL OR director = '' OR director = 'unknown') AS null_director,
	    COUNT(*) FILTER (WHERE country IS NULL OR country = '' OR country = 'unknown') AS null_country,
	    COUNT(*) FILTER (WHERE rating IS NULL OR rating = '' OR rating = 'unknown') AS null_rating,
	    COUNT(*) FILTER (WHERE date_added IS NULL) AS null_date_added,
	    COUNT(*) FILTER (WHERE release_year IS NULL) AS null_release_year
	from netflix
	)

select
	total_row_count as total_row_percentage,
	round(null_cast * 100 / total_row_count, 2) as bad_cast_data_percentage,
	round(null_director * 100 / total_row_count, 2) as bad_director_data_percentage,
	round(null_country * 100 / total_row_count, 2) as bad_country_data_percentage,
	round(null_date_added * 100 / total_row_count, 2) as bad_date_added_data_percentage
from filter_report;


-- country wise top popular genres.
select * from netflix;