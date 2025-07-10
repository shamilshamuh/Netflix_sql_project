-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

## Business Problems and Solutions

## 1.Count the Number of Movies vs TV Shows
```sql
select type, Count(*) as Count_types 
from netflix_1
group by type
```
**Objective:** Determine the distribution of content types on Netflix.

### 2.find the most common rating for movies and tv shows
```sql
select 
type,
rating

from
(
select type,count(*), rating,
rank() over(PARTITION BY type order by count(*) desc )as Ranking
FROM netflix_1
group by type,rating
) as t1
where Ranking=1
```
**Objective:** Identify the most frequently occurring rating for each type of content.


### 3. list all movies released in a specific year(e.g,2020)
```sql
select 
type,
title,
release_year
FROM
netflix_1
where release_year=2020 and type='Movie'
```
**Objective:** Retrieve all movies released in a specific year.


### 4.find the top 5 countries with the most content on netflix
```sql
select 
trim(unnest(string_to_array(country,','))) as Top_5_country
,count(show_id) as total_content 
from netflix_1
group by Top_5_country
order by total_content desc
limit 5
```
**Objective:** Identify the top 5 countries with the highest number of content items.
	
### 5. identify the longest movie
```sql
select 
*from
(select distinct title as movie,
split_part(duration,' ',1)::numeric as duration_1
from netflix_1
where type='Movie' 
)as t1
where duration_1 is not null
order by duration_1 desc
limit 1
```
**Objective:** Find the movie with the longest duration.

### 6.find the content added in the last five years 
```sql
select*from

(SELECT title,
  TO_DATE(date_added, 'Month DD, YYYY') AS release_date_formatted
FROM netflix_1
)as t1

where t1.release_date_formatted is not null
order by t1.release_date_formatted desc ;
```
**Objective:** Retrieve content added to Netflix in the last 5 years.
### 7.find the movie and tv show dircted by 'Rajiv Chilaka'
```sql
select type,title
,split_part(director,',',1) as Director
from netflix_1
where Director ilike '%Rajiv Chilaka%'
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8 list all TV show more than 5 show
```sql
SELECT 
  type,
  CONCAT(split_part(duration, ' ', 1), ' seasons') AS new
FROM netflix_1
WHERE type = 'TV Show'
  AND split_part(duration, ' ', 1)::NUMERIC > 5 
ORDER BY split_part(duration, ' ', 1)::NUMERIC DESC;
```

select* from netflix_1
**Objective:** Identify TV shows with more than 5 seasons.

	
### 9 count the number of content  items in each genre
```sql
SELECT
TRIM(UNNEST(STRING_TO_ARRAY(netflix_1.listed_in,','))) AS GENRE,
COUNT(show_id) AS TOTAL_COUNT
FROM
netflix_1
GROUP BY GENRE
```
**Objective:** Count the number of content items in each genre.
### 10. Find Each Year and Average Number of Content Release By India on Netflix, Return Top  5 Years With Highest Average Content Release


```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

**Objective:** Calculate and rank years by the average number of content releases by India.
### 11. List All the Movie Are Documentaries
```sql
select*from
(
SELECT type,title,
TRIM(UNNEST(STRING_TO_ARRAY(netflix_1.listed_in,','))) AS GENRE
FROM netflix_1
where type='Movie'
)as t1
WHERE GENRE ilike '%Documentaries%'
```
**Objective:** Retrieve all movies classified as documentaries.
### 12. find the all content without]  director
 ```sql
select*from netflix_1
where director is null
```
	
**Objective:** List content that does not have a director.
###13.find how many movies apear actor 'Salman Khan' appeared in the last 10 years
```sql
select type,casts
from netflix_1
where casts ilike'%Salman Khan%'
  AND 
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 14 find the top 10 actors who as appeared in the highest number movies produced in india
```sql
select count(*)as Count_of_cast,
unnest(string_to_array(casts,','))as Actors
from netflix_1
where country ilike '%India'
group by Actors
order by Count_of_cast desc
limit 10
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field . Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field .
```sql
select *from netflix_1

with cte as(
select *,
case
when description ilike '%kill%' or description ilike 'violence' then 'Bad_content'
else 'Good_content'
end as Category
from netflix_1
)
select count(*) as Count_of_Contents,category
from cte
group by category
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
