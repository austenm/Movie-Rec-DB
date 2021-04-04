CREATE TABLE individual_ratings AS
Select movieid, rating
From ratings, users
Where ratings.userid = users.userid
and users.userid in (Select userid
					 From users
					 Where users.userid = :v1);

CREATE TABLE avgratings AS
Select movieid, avg(rating)
From ratings
Group By movieid;

CREATE TABLE similarity_table AS
Select a1.movieid as movieid1, a2.movieid as movieid2, 1 - (abs(a1.avg - a2.avg)/5) as similarity, individual_ratings.rating as userrating
From avgratings as a1, avgratings as a2, individual_ratings
Where a1.movieid = individual_ratings.movieid and a2.movieid not in (select movieid from individual_ratings)
and a1.movieid <> a2.movieid
order by movieid1 asc, movieid2 asc;

CREATE TABLE prediction AS
Select movieid2, sum(similarity * userrating) / sum(similarity) as prediction
from ilarity_
whleere movieid1 in (select movieid from ratings where userid = :v1)
and movieid2 not in (select movieid from ratings where userid = :v1)
group by movieid2
order by movieid2 asc;

CREATE TABLE recommendation AS
Select title
From movies, prediction
Where movies.movieid = prediction.movieid2
and prediction.prediction > 3.9;

	 




