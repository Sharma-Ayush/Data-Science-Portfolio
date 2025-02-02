/*
1683. Invalid Tweets

Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
In SQL, tweet_id is the primary key for this table.
This table contains all the tweets in a social media app.
 
Find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.
*/

--Solution:
Select tweet_id
from dbo.Tweets
where len(content) > 15;