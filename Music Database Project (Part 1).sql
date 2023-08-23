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


Answer: 42, Wyatt, Girard, 23.76


