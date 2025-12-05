USE chinook;

-- Clients from Brazil and Canada
SELECT FirstName, LastName, Country, Email FROM customer
WHERE Country IN ('Brazil', 'Canada');

-- Country Rank
SELECT BillingCountry, COUNT(*) AS 'Invoice Count' FROM Invoice
GROUP BY BillingCountry
ORDER BY COUNT(*) DESC;

-- Best Selling Employee
SELECT employee.FirstName, employee.LastName, SUM(Invoice.Total) AS Total_Sum
FROM employee JOIN Customer ON employee.EmployeeId = Customer.SupportRepId 
JOIN invoice ON customer.CustomerId = invoice.CustomerId
GROUP BY employee.FirstName, employee.LastName 
ORDER BY Total_Sum DESC;

-- Music Genres
SELECT genre.Name , SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS SellAmount
FROM Genre JOIN Track ON Genre.GenreId = Track.GenreId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
WHERE genre.Name IN ('Rock','Jazz')
GROUP BY genre.Name
ORDER BY SellAmount;

-- Cleaning the Magazines
SELECT track.name, track.composer
FROM track LEFT JOIN invoiceline ON track.trackid = invoiceline.trackid
WHERE invoiceline.InvoiceLineId IS NULL;

-- Selling Trends
SELECT YEAR(InvoiceDate) AS Year1, SUM(Total) AS Income
FROM Invoice 
GROUP BY Year1
ORDER BY Year1 DESC;

-- Categorizing Clients
SELECT customer.FirstName, customer.LastName, SUM(invoice.Total) AS TotalSpent,
CASE 
	WHEN SUM(invoice.Total)  > 40 THEN 'VIP'
    WHEN SUM(invoice.Total)  > 20 THEN 'Regular'
    ELSE 'New'
END AS CustomerCategory
FROM customer JOIN invoice ON customer.CustomerId = invoice.CustomerId
GROUP BY customer.CustomerId , customer.FirstName, customer.LastName
ORDER BY TotalSpent DESC;

-- Best Clients in Every Country
WITH CustomerCountrySales AS (
	SELECT 
		c.Country, c.FirstName, c.LastName, SUM(i.Total) as TotalSpent
	FROM customer c
    JOIN invoice i ON c.CustomerID = i.CustomerId
    GROUP BY c.Country, c.FirstName, c.LastName
)
SELECT 
	Country, FirstName, LastName, TotalSpent, 
    RANK() OVER (PARTITION BY Country ORDER BY TotalSpent DESC) AS RankInCountry
FROM cUSTOMERcOUNTRYsALES
WHERE TotalSpent > 0;

-- Cumulated Sum Of Sales
WITH YearlySales AS (
    SELECT 
        YEAR(InvoiceDate) AS SalesYear, 
        SUM(Total) AS CurrentYearSales
    FROM Invoice
    GROUP BY YEAR(InvoiceDate)
)
SELECT 
    SalesYear, 
    CurrentYearSales, 
    SUM(CurrentYearSales) OVER (ORDER BY SalesYear) AS RunningTotal
FROM YearlySales;



