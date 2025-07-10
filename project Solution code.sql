-- Netflix Data Analysis using SQL
-- Solutions of 15 business problems

--Business Problems and Solutions--

--1Count the number of movies and Tv show

select type, Count(*) as Count_types 
from netflix_1
group by type


--2 find the most common rating for movies and tv shows

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


--3 list all movies released in a specific year(e.g,2020)--\
select 
type,
title,
release_year
FROM
netflix_1
where release_year=2020 and type='Movie'


--4 find the top 5 countries with the most content on netflix--
select 
trim(unnest(string_to_array(country,','))) as Top_5_country
,count(show_id) as total_content 
from netflix_1
group by Top_5_country
order by total_content desc
limit 5

--5 identify the longest movie
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

--6 find the content added in the last five years 
select*from

(SELECT title,
  TO_DATE(date_added, 'Month DD, YYYY') AS release_date_formatted
FROM netflix_1
)as t1

where t1.release_date_formatted is not null
order by t1.release_date_formatted desc ;


--7 find the movie and tv show dircted by 'Rajiv Chilaka'

select type,title
,split_part(director,',',1) as Director
from netflix_1
where Director ilike '%Rajiv Chilaka%'


--8 list all TV show more than 5 show

SELECT 
  type,
  CONCAT(split_part(duration, ' ', 1), ' seasons') AS new
FROM netflix_1
WHERE type = 'TV Show'
  AND split_part(duration, ' ', 1)::NUMERIC > 5 
ORDER BY split_part(duration, ' ', 1)::NUMERIC DESC;


select* from netflix_1
--9 count the number of content  items in each genre
SELECT
TRIM(UNNEST(STRING_TO_ARRAY(netflix_1.listed_in,','))) AS GENRE,
COUNT(show_id) AS TOTAL_COUNT
FROM
netflix_1
GROUP BY GENRE

--10 Find Each Year and Average Number of Content Release By India on Netflix,
--Return Top  5 Years With Highest Average Content Release


--11 List All the Movie Are Documentaries
select*from
(
SELECT type,title,
TRIM(UNNEST(STRING_TO_ARRAY(netflix_1.listed_in,','))) AS GENRE
FROM netflix_1
where type='Movie'
)as t1
WHERE GENRE ilike '%Documentaries%'

--12 find the all content without]  director
select*from netflix_1
where director is null

--find how many movies apear actor 'Salman Khan' appeared in the last 10 years
select type,casts
from netflix_1
where casts ilike'%Salman Khan%'
  AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


--14 find the top 10 actors who as appeared in the highest number movies produced in india
select count(*)as Count_of_cast,
unnest(string_to_array(casts,','))as Actors
from netflix_1
where country ilike '%India'
group by Actors
order by Count_of_cast desc
limit 10

--15 Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field .
--label content containing these keywords as 'Bad' and all other content as 'Good'.Count how many items fall into each category.
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

