/*===================================== Online_Book_Store =====================================*/
-- Create Database
CREATE DATABASE Online_Book_Store;

-------------------------------- Create Tables ------------------------------------
-- Create Table Books
DROP TABLE IF EXISTS Books;

CREATE TABLE Books(
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(48),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);
SELECT * FROM Books;

-- Create Table Customers
DROP TABLE IF EXISTS Customers;

CREATE TABLE Customers(
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Email VARCHAR(71),
	Phone VARCHAR(15),
	City VARCHAR(35),
	Country VARCHAR(53)
);
SELECT * FROM Customers;

-- Create Table Orders
DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);


SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

------------------------------------ Basic Queations ----------------------------------------
-- 1.] Retrive all books in the 'Fiction' genre : 
SELECT * FROM Books
WHERE genre = 'Fiction';


SELECT COUNT(*)FROM Books
WHERE genre = 'Fiction';

-- 2.] Find books published after the year 1950:
SELECT * FROM Books
Where published_year > 1950;

SELECT COUNT(*) FROM Books
Where published_year > 1950;

-- 3.] List all the Customers from Canada
SELECT * FROM Customers
WHERE country = 'Canada';

SELECT Count(*) FROM Customers
WHERE country = 'Canada';

-- 4.] Show orders placed in November 2023 :
SELECT * FROM Orders;

SELECT * FROM Orders
Where order_date >= '2023-11-01' AND order_date <= '2023-11-30';

SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5.] Retrive the total stock of books available.
SELECT * FROM Books;

SELECT SUM(stock)AS Total_Stock FROM Books;
 

-- 6.] Find the details of the most expensive book : 
SELECT * FROM Books
WHERE price = (SELECT MAX(price)FROM Books);

SELECT * FROM Books
ORDER BY price
DESC LIMIT 1;

-- 7.] Show orders who ordered more then 1 Quantity of a book.
SELECT * FROM Orders
WHERE quantity > 1;

-- 8.] Retrive all orders where the total amount exceeds $20 : 
SELECT * FROM Orders
WHERE total_amount > 20.00;
 
-- 9.] List all the genres available in the Books table :
SELECT DISTINCT(genre)AS Available_Genres FROM Books;

SELECT COUNT(DISTINCT(genre))AS Available_Genres FROM Books;

-- 10.] Find the Books with lowest Stock
SELECT * FROM Books;

SELECT * FROM Books 
WHERE stock = (SELECT MIN(stock) FROM Books);

-- 11.] Calculate the total revenue generated from all orders : 
SELECT * FROM Orders;

SELECT SUM(total_amount)AS Revenue FROM Orders;

------------------------------------ Advanced Queations ------------------------------------
-- 1.] Retrive the Total No of books sold for each genre : 
SELECT * FROM Books;
SELECT * FROM Orders;

SELECT b.genre,SUM(o.quantity) AS Total_Books_Sold
FROM Books b
JOIN
Orders o 
ON b.book_id = o.book_id
GROUP BY b.genre;


-- 2.] Find the Average price of books in the 'Fantasy' genre : 
SELECT * FROM Books;
SELECT * FROM Orders;

SELECT ROUND(AVG(price),2) AS Averge_Price
FROM Books
WHERE genre = 'Fantasy';

-- 3. List Customers Placed atlist 02 Orders : 
SELECT * FROM Customers;
SELECT * FROM Orders;

SELECT c.customer_id,c.name,COUNT(o.order_id) AS Order_Count
FROM customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
HAVING COUNT(o.order_id) >=2
ORDER BY Order_Count DESC;

-- 4.] Find the Most frequently ordered book : 
SELECT * FROM Orders;
SELECT * FROM Books;

SELECT o.book_id,b.title,COUNT(o.order_id) AS Order_Count
FROM books b
JOIN
Orders o
ON b.book_id = o.book_id
GROUP BY o.book_id,b.title
ORDER BY Order_Count DESC
Limit 1;

-- 5.] Show the Top 03 most expensive books of 'Fantasy' genre : 
SELECT * FROM Books;

SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6.] Retrieve the Total Quantity of books sold by each Author :
SELECT * FROM Orders;
SELECT * FROM Books;

SELECT b.author,SUM(o.quantity)AS Total_Books_Sold
FROM Books b
JOIN
Orders o
ON b.book_id = o.book_id
GROUP BY b.author
ORDER BY Total_Books_Sold DESC; 

-- 7.] List the Cities where Customers who spent over $30 are located: 
SELECT * FROM Orders;
SELECT * FROM Books;
SELECT * FROM Customers;

SELECT DISTINCT(c.city),o.total_Amount
FROM Customers c
JOIN Orders o
ON c.customer_id = o.customer_id
WHERE o.total_Amount > 30
ORDER BY o.total_Amount DESC;

-- 8.] Find the Customers who spent the most on Orders : 
SELECT * FROM Orders;
SELECT * FROM Books;
SELECT * FROM Customers;

SELECT c.customer_id,c.name,SUM(o.total_amount) AS Total_Spent
FROM customers c
JOIN Orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id,c.name
ORDER BY Total_Spent DESC
LIMIT 5;


-- 9.] Calculate the Stock remaning after fulfilling all orders :
SELECT * FROM Orders;
SELECT * FROM Books;
SELECT * FROM Customers;

SELECT b.book_id,b.title,b.stock, COALESCE(SUM(o.quantity),0)AS Total_Sold,
	b.stock - COALESCE(Sum(o.quantity),0)AS Remaning_Stock
FROM Books b
LEFT JOIN Orders o
ON
b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;































