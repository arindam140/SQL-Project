Question 1
Who is the senior most employee based on job title?

SELECT levels, employee_id, last_name, first_name FROM employee
ORDER BY levels DESC
LIMIT 1

---------------------------------------------------------------------------------------------------

Question 2
Which countries have the most Invoices?

SELECT COUNT(*) AS number_of_invoices,billing_country FROM invoice
GROUP BY billing_country
ORDER BY number_of_invoices DESC

COUNT (*) --> Counts the number of rows, this is useful in counting the occurences of an event

---------------------------------------------------------------------------------------------------


Question 3
What are top 3 values of total invoice?

SELECT total FROM invoice
ORDER BY total DESC
LIMIT 3

---------------------------------------------------------------------------------------------------


Question 4:

Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals

SELECT billing_city, SUM(total) AS invoice_total
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC

---------------------------------------------------------------------------------------------------


Question 5:

Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money


Using Natural Join

SELECT customer_id, first_name, last_name, SUM(total) AS total
FROM customer NATURAL JOIN invoice
GROUP BY customer_id
ORDER BY total DESC
LIMIT 1


Normal SQL

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total
FROM customer,invoice
WHERE customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1


Answer: 5, R, Madhav, 144.54

---------------------------------------------------------------------------------------------------


SET2

Question 6:
Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A

Solution 1:


SELECT DISTINCT email, first_name, last_name, genre.name
FROM (((track JOIN genre USING (genre_id))
				 JOIN invoice_line USING (track_id))
					 JOIN invoice USING (invoice_id))
					 	JOIN customer USING (customer_id)
WHERE genre.name = 'Rock'
ORDER BY email

Alternate Solution

SELECT DISTINCT email, first_name, last_name, genre.name
FROM (((customer
JOIN invoice USING (customer_id))
JOIN invoice_line USING (invoice_id))
JOIN track USING (track_id))
JOIN genre USING (genre_id)

WHERE genre.name = 'Rock'


---------------------------------------------------------------------------------------------------


Question 7
Lets invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands


SELECT artist.name AS artist_name, genre.name AS genre_name, COUNT (track.track_id) AS total_tracks
FROM ((genre JOIN track USING (genre_id)) 
				JOIN album USING (album_id))
					JOIN artist USING (artist_id)
WHERE genre.name = 'Rock'
GROUP BY artist_name, genre_name
ORDER BY total_tracks DESC
LIMIT 10

---------------------------------------------------------------------------------------------------

Question 8:
Return all the track names that have a song length longer than the average song length.

SELECT name, milliseconds AS len
FROM track
WHERE milliseconds > 
(SELECT AVG (milliseconds)
FROM track)
ORDER BY len ASC



---------------------------------------------------------------------------------------------------


Question 9:
Find how much amount spent by each customer on artists?
Write a query to return customer name, artist name and total spent

SELECT artist.name AS artistName,
		customer.first_name,
		 customer.last_name,
			SUM (invoice.total) AS invoiceTotal
FROM customer
JOIN invoice USING (customer_id)
JOIN invoice_line USING (invoice_id)
JOIN track USING (track_id)
JOIN album USING (album_id)
JOIN artist USING (artist_id)

GROUP BY artistName, customer.first_name, customer.last_name
ORDER BY invoiceTotal DESC

---------------------------------------------------------------------------------------------------

Invoice total match with InvoiceLine table

SELECT invoice.total, 
invoice_line.unit_price AS price,
invoice_line.quantity AS qty,
invoice_line.unit_price*invoice_line.quantity AS multiplier
FROM invoice_line
JOIN invoice USING (invoice_id)

---------------------------------------------------------------------------------------------------
In-Correct Solution for Q9:

SELECT artist.name AS artistName,
		customer.first_name,
		customer.last_name,
		SUM(invoice_line.quantity*invoice_line.unit_price) AS total_amount
		
		
FROM customer
JOIN invoice USING (customer_id)
JOIN invoice_line USING (invoice_id)
JOIN track USING (track_id)
JOIN album USING (album_id)
JOIN artist USING (artist_id)

GROUP BY 1,2,3
ORDER BY total_amount DESC

---------------------------------------------------------------------------------------------------

Correct Solution using CTE

WITH best_selling_artist AS (
	SELECT artist.name AS artist_name,
			artist.artist_id,
			SUM (invoice_line.unit_price*invoice_line.quantity) AS total_amount
	
				FROM invoice_line
				JOIN track USING (track_id)
				JOIN album USING (album_id)
				JOIN artist USING (artist_id)
			GROUP BY 1,2
			ORDER BY total_amount DESC
			LIMIT 1
	)
	
SELECT c.customer_id,
		c.first_name,
		c.last_name,
		bsa.artist_name,
		bsa.artist_id,
		SUM (il.unit_price*il.quantity) AS total_amount
		 

FROM customer c 
JOIN invoice i USING (customer_id)
JOIN invoice_line il USING (invoice_id)
JOIN track t USING (track_id)
JOIN album a USING (album_id)
JOIN best_selling_artist bsa USING (artist_id)

GROUP BY 1,2,3,4,5
ORDER BY 5 DESC



---------------------------------------------------------------------------------------------------


Question 10:
We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres


SELECT country, genre.name AS gen, genre.genre_id AS gen_id, SUM(quantity) AS total
FROM genre
JOIN track USING (genre_id)
JOIN invoice_line USING (track_id)
JOIN invoice USING (invoice_id)
JOIN customer USING (customer_id)

GROUP BY gen, gen_id,country
ORDER BY country, total DESC



---------------------------------------------------------------------------------------------------



Question 10 
Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent.For countries where the top amount spent is shared, provide all
customers who spent this amount

--trying window function


SELECT *
FROM 
(SELECT *,
RANK() OVER (PARTITION BY country ORDER BY total_spent DESC) AS rnk

FROM 
(SELECT c.first_name,
		c.last_name,
		c.country,
		SUM(il.quantity * il.unit_price) AS total_spent
		
		
FROM invoice_line il
JOIN invoice i USING (invoice_id)
JOIN customer c USING (customer_id)

GROUP BY 1,2,3
ORDER BY 3
) AS ctf)

AS r_ctf

WHERE r_ctf.rnk<2



-- TRYING CTE----

SELECT *, rank

FROM (WITH ctf_finder AS 
(SELECT c.first_name,
		c.last_name,
		c.country,
		SUM(il.quantity * il.unit_price) AS total_spent
		
		
FROM invoice_line il
JOIN invoice i USING (invoice_id)
JOIN customer c USING (customer_id)

GROUP BY 1,2,3
ORDER BY 3)

SELECT ctf_finder.*,
RANK () OVER (PARTITION BY country ORDER BY total_spent)  

FROM ctf_finder) AS ctf

WHERE ctf.rank<2






--------------------------------------------------------------------------------------------------

Window Functions:

These functions can be written using OVER(.) clause.


For example:



SELECT * 
FROM (SELECT e.*, 

max(salary) OVER (PARTITION BY dept_name) as max_salary
FROM employee e)

WHERE condition



In this query MAX is applied OVER(columns)
max is treated as a window functions OVER the window create by PARTITION
OVER is used to create a window of records

PARTITION BY (column1) : For every distinct value in column1, SQL will create one window and then the aggregate function will apply in the windows

Other Window Functions

ROW_NUMBER: allots distinct row number to the partitions mentioned in the over() clause, useful to list top n rows out of m rows in a partition

RANK: same as row_number, excepts duplicates are alloted the same rank, and for every duplicate a rank is skipped

DENSE_RANK: same as RANK, but for every duplicate a rank is not skipped

LAG: 

Window function can only be used when a table has been created. That is, we can output the window parameter only when we have the table available
or if a table is generated from a query, we will need an alias, hence a Subquery.



--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------

-- We want to find out the most popular music Genre for each country. 
-- We determine the most popular genre as the genre with the highest amount of purchases.
-- Write a query that returns each country along with the top Genre.
-- For countries where the maximum number of purchases is shared return all Genres.
-- Required values, country, amount, genre?


SELECT * FROM 

(WITH best_selling_genre AS
(SELECT c.country,
		g.name,
		SUM (il.unit_price*il.quantity) AS total_amount

FROM genre g
JOIN track t USING (genre_id)
JOIN invoice_line il USING (track_id)
JOIN invoice i USING (invoice_id)
JOIN customer c USING (customer_id)

GROUP BY 1,2
ORDER BY 3 DESC) 

SELECT *,
RANK () OVER (PARTITION BY country ORDER BY total_amount DESC)
FROM best_selling_genre) AS bsg_cw

WHERE bsg_cw.rank<2








