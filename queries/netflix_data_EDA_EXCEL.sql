create table if not exists netflix (
	show_id TEXT,
	"type" TEXT,
	title TEXT,
	director TEXT,
	"cast" TEXT,
	country TEXT,
	date_added date,
	release_year int,
	rating TEXT,
	duration TEXT,
	listed_in TEXT,
	description TEXT,
	date_added_null int,
	rating_null int,
	duration_null int

);

select * from netflix;

-- frequent actors.
select
	unnest(string_to_array("cast", ',')) as cast_members,
	count(*) as appearance_count
from netflix
where "cast" not in ('unknown')
group by cast_members
order by appearance_count desc;

-- numbers of title released per year.
select
	extract(year from date_added) as years,
	count(*) as content_count
from netflix
where date_added is not null
group by years
order by content_count desc;

-- Share of Movies vs TV Shows.

with type_total_count as (
	select
		"type",
		count(*) as content_count
	from netflix
	group by "type"
),

total_count as (
	select
		count(*) as total_content_count
	from netflix
)

select
	ttc."type",
	round(sum(ttc.content_count) * 100 / sum(tc.total_content_count), 2) as content_share_percentage
from type_total_count as ttc
cross join total_count as tc
group by ttc."type";

-- Top producing countries.
select
	unnest(string_to_array(country, ',')) as countries,
	count(*) as content_upload_count
from netflix
group by countries
order by content_upload_count desc;

-- Top 5 genres per year.
with yearly_count as (
	select
		extract(year from date_added) as years,
		unnest(string_to_array(listed_in, ',')) as genres,
		count(*) as genre_count
	from netflix
	group by years , genres
	order by genre_count desc
	),

	ranking as (
	select
		years,
		genres,
		genre_count,
		row_number() over(partition by years order by genre_count desc) as ranking_per_year
	from yearly_count
)

select *
from ranking
where ranking_per_year <= 5;

-- Duration vs content type.
-- avg movie duration for both content.

select
	"type",
	round(avg(split_part(duration, ' ', 1)::int), 2) as duration
from netflix
group by "type";

-- Distribution of movie durations.
with movie_duration as (
	select
		"type",
		split_part(duration, ' ', 1)::int as duration
	from netflix
	where "type" = 'Movie'
)

select
	case
		when duration between 60 and 120 then '1-2 hours'
		when duration between 121 and 180 then '2-3 hours'
	else 'more than 3 hours'
	end as duration_category,
	count(*) as movie_counts
from movie_duration
group by duration_category;

-- Top 10 longest movies or shows.
select
	title,
	"type",
	split_part(duration, ' ', 1)::int as duration
from netflix
where duration is not null
order by duration desc
limit 10;

-- Distribution of TV show seasons.
with movie_duration as (
	select
		"type",
		split_part(duration, ' ', 1)::int as duration
	from netflix
	where "type" = 'TV Show'
)

select
	case
		when duration between 1 and 3 then '1-3 seasons'
		when duration between 4 and 6 then '4-6 seasons'
	else 'more than 6 seasons'
	end as duration_category,
	count(*) as movie_counts
from movie_duration
group by duration_category;

-- Top 10 Longest TV Shows.
select
	title,
	"type",
	split_part(duration, ' ', 1)::int as duration
from netflix
where duration is not null and "type" = 'TV Show'
order by duration desc
limit 10;

-- do older movies had more duration time?
select * from netflix;

with yearly_analysis as (
	select
		release_year,
		title,
		split_part(duration, ' ', 1):: int as duration
	from netflix 
	where "type" in ('Movie')
	)
select
	case
		when release_year between 1920 and 1950 then 'Very old generation'
		when release_year between 1951 and 1990 then '50s-90s generation'
		when release_year between 1991 and 2021 then '90s-modern generation'
	end as year_segments,
	round(avg(duration), 2) as avg_duration
from yearly_analysis
group by year_segments;

-- do older tv shows had more duration time?
with yearly_analysis as (
	select
		release_year,
		title,
		split_part(duration, ' ', 1):: int as duration
	from netflix 
	where "type" in ('TV Show')
	)
select
	case
		when release_year between 1920 and 1950 then 'Very old generation'
		when release_year between 1951 and 1990 then '50s-90s generation'
		when release_year between 1991 and 2021 then '90s-modern generation'
	end as year_segments,
	round(avg(duration), 2) as avg_season
from yearly_analysis
group by year_segments;

select
	distinct rating

from netflix;

-- age group of people does netflix target?
with rating_counts as (
	select
		rating,
		count(*) as content_count
	from netflix
	where rating not in ('74 min', '66 min', '84 min')
group by rating
)
select
	case
		when rating in ('TV-Y', 'TV-Y7', 'G', 'TV-Y7-FV') then 'Kids (0-12)'
		when rating in ('TV-14', 'PG-13', 'PG', 'TV-PG') then 'Teens (13-17)'
		when rating in ('TV-G', 'G') then 'Family Show'
		when rating in ('TV-MA', 'R', 'NC-17') then 'Adults (18+)'
		when rating in ('UR', 'NR') then 'not rated / unrated'
	end as age_group_category,
	sum(content_count) as content_counts
from rating_counts
group by age_group_category;

-- mosts uploads by quarter.
select
	extract(QUARTER from date_added) as upload_quarter,
	count(*) as content_count
from netflix
where date_added is not null
group by 
	extract(QUARTER from date_added);

-- seasonal show upload and percentage of total upload rate.
select
	extract(quarter from date_added) as quarters,
	count(*) as content_count,
	round(count(*) * 100 / (select count(*) from netflix where date_added is not null), 2) as portions
from netflix
where date_added is not null
group by quarters;

-- TV Show vs movies?
select
	"type",
	count(*) as content_count
from netflix
group by "type";