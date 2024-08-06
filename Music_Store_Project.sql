DROP DATABASE IF EXISTS Music_Store;
CREATE DATABASE Music_Store;


 -- Q1: Who is the senior most employee based on job title?  

SELECT first_name,last_name,title,employee_id
FROM  employee
ORDER BY levels DESC 
LIMIT 1; 

--  Q2: Which countries have the most Invoices? 

SELECT billing_country,COUNT(customer_id)
FROM invoice
GROUP BY billing_country
ORDER BY COUNT(customer_id) DESC;

-- Q3: What are top 3 values of total invoice?

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

--  Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

SELECT billing_city,SUM(total) invoice_totals
FROM invoice
GROUP BY billing_city
ORDER BY invoice_totals DESC
LIMIT 1;

-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money

SELECT c.first_name,c.last_name , c.customer_id ,SUM(i.total) total
FROM customer c
INNER JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id,c.first_name,c.last_name 
ORDER BY total DESC
LIMIT 1;


-- Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.

-- Method 1: 
SELECT DISTINCT email,first_name,last_name
FROM customer c
JOIN invoice i ON c.customer_id=i.customer_id
JOIN invoice_line il ON i.invoice_id=il.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id=t.track_id
WHERE g.name LIKE 'Rock'
ORDER by email;

-- Method 2:

SELECT DISTINCT email,first_name,last_name
FROM customer c
JOIN invoice i ON c.customer_id=i.customer_id
JOIN invoice_line il ON i.invoice_id=il.invoice_id
WHERE track_id IN ( 
  SELECT track_id 
  FROM track t
  JOIN genre g 
  ON t.genre_id=g.genre_id
  WHERE g.name LIKE 'Rock')
ORDER BY email; 

-- Q7: Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.
-- M-1:
SELECT a.name,a.artist_id, COUNT(t.track_id) no_of_songs
FROM artist a 
JOIN album b ON a.artist_id = b.artist_id
JOIN track t ON t.album_id = b.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name LIKE 'ROCK'
GROUP BY a.name,a.artist_id
ORDER BY no_of_songs DESC
LIMIT 10;

-- M2:
SELECT artist.artist_id, artist.name,COUNT(artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id,artist.name
ORDER BY number_of_songs DESC
LIMIT 10;

-- Q8: Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

SELECT name,milliseconds
FROM track
WHERE milliseconds> 
(SELECT AVG(milliseconds)
FROM track)
ORDER BY milliseconds DESC;

