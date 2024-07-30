-- 1. Display the clients (name) who lives in same city.
SELECT Client_Name
FROM clients
WHERE City IN (
    SELECT City
    FROM clients
    GROUP BY City
    HAVING COUNT(*) > 1
);


-- 2. Display city, the client names and salesman names who are lives in “Thu Dau Mot” city.
SELECT 
    C.City,
    C.Client_Name,
    S.Salesman_Name
FROM 
    clients C
INNER JOIN 
    salesman S
ON 
    C.City = S.City
WHERE 
    C.City = 'Thu Dau Mot';

-- 3. Display client name, client number, order number, salesman number, and product number for each
-- order.
SELECT
	C.Client_Name, 
    O.Client_Number, 
    O.Order_Number, 
    O.Salesman_Number, 
    P.Product_Number
FROM salesorder O 
INNER JOIN 
    clients C ON O.Client_Number = C.Client_Number
INNER JOIN 
    salesorderdetails P ON O.Order_Number = P.Order_Number;

-- 4. Find each order (client_number, client_name, order_number) placed by each client.
SELECT 
    C.Client_Number, 
    C.Client_Name, 
    O.Order_Number
FROM salesorder O
INNER JOIN clients C ON O.Client_Number = C.Client_Number;
-- 5. Display the details of clients (client_number, client_name) and the number of orders which is paid by
-- them.
SELECT 
C.Client_Number,C.Client_Name, COUNT(Order_Number) AS Number_Of_order
FROM clients C
LEFT JOIN 
    salesorder O ON C.Client_Number = O.Client_Number
WHERE 
    O.Order_Status = 'Successful'
GROUP BY 
    C.Client_Number, 
    C.Client_Name; 
-- 6. Display the details of clients (client_number, client_name) who have paid for more than 2 orders.
SELECT 
    C.Client_Number, 
    C.Client_Name
 
FROM 
    clients C 
JOIN 
    salesorder O ON C.Client_Number = O.Client_Number
WHERE 
    O.Order_Status = 'Successful'
GROUP BY 
    C.Client_Number, 
    C.Client_Name
HAVING 
    COUNT(O.Order_Number) > 2;

-- 7. Display details of clients who have paid for more than 1 order in descending order of client_number.
SELECT  C.*
FROM clients C 
JOIN salesorder O ON C.Client_Number=O.Client_Number
WHERE 
    O.Order_Status = 'Successful'
GROUP BY 
    C.Client_Number, 
    C.Client_Name
HAVING 
    COUNT(O.Order_Number) > 1 order by C.Client_Number desc;
-- 8. Find the salesman names who sells more than 20 products.
SELECT O.Salesman_Name 
from salesman O 
Join salesorder S ON O.Salesman_Number=S.Salesman_Number
JOIN salesorderdetails SO ON S.Order_Number=SO.Order_Number
GROUP BY O.Salesman_Name,SO.Order_Number
HAVING sum(SO.Order_Quantity)>20;
 
-- 9. Display the client information (client_number, client_name) and order number of those clients who
-- have order status is cancelled.
SELECT  C.Client_Number, 
		C.Client_Name
FROM clients C 
JOIN salesorder O ON C.Client_Number=O.Client_Number
WHERE 
    O.Order_Status = 'Cancelled'
GROUP BY 
    C.Client_Number, 
    C.Client_Name;
-- 10. Display client name, client number of clients C101 and count the number of orders which were
-- received “successful”.
SELECT  C.Client_Number, 
		C.Client_Name
FROM clients C 
JOIN salesorder O ON C.Client_Number=O.Client_Number
WHERE 
	C.Client_Number='C101' and
    O.Order_Status = 'Successful'
GROUP BY 
    C.Client_Number, 
    C.Client_Name;
-- 11. Count the number of clients orders placed for each product.
SELECT 
    SO.Product_Number, 
    COUNT(SO.Order_Number) AS NumberOfOrders
FROM 
    salesorderdetails SO
GROUP BY 
    SO.Product_Number;

-- 12. Find product numbers that were ordered by more than two clients then order in descending by product
-- number.
SELECT 
    SO.Product_Number
FROM 
    salesorderdetails SO
INNER JOIN 
    salesorder S ON SO.Order_Number = S.Order_Number
GROUP BY 
    SO.Product_Number
HAVING 
    COUNT(DISTINCT S.Client_Number) > 2
ORDER BY 
    SO.Product_Number DESC;

-- 13. Find the salesman’s names who is getting the second highest salary.
SELECT Salesman_Name 
FROM 
	salesman
WHERE 
	Salary= ( SELECT MAX(Salary) 
    FROM salesman
    WHERE Salary <(  SELECT MAX(Salary) 
    FROM salesman));
-- 14. Find the salesman’s names who is getting second lowest salary.
SELECT Salesman_Name 
FROM 
	salesman
WHERE 
	Salary= ( SELECT MIN(Salary) 
    FROM salesman
    WHERE Salary >(  SELECT MIN(Salary) 
    FROM salesman));
-- 15. Write a query to find the name and the salary of the salesman who have a higher salary than the
-- salesman whose salesman number is S001.
SELECT 
Salesman_Name
FROM salesman
WHERE Salary > (SELECT Salary FROM salesman WHERE Salesman_Number='S001');
-- 16. Write a query to find the name of all salesman who sold the product has number: P1002.
SELECT 
Salesman_Name 
FROM
salesman S 
INNER JOIN 
salesorder O ON S.Salesman_Number=O.Salesman_Number
INNER JOIN 
salesorderdetails SO ON O.Order_Number=SO.Order_Number
WHERE 
SO.Product_Number='P1002';

-- 17. Find the name of the salesman who sold the product to client C108 with delivery status is “delivered”.
SELECT
S.Salesman_Name
FROM
salesman S 
INNER JOIN 
salesorder O ON S.Salesman_Number=O.Salesman_Number
INNER JOIN 
salesorderdetails SO ON O.Order_Number=SO.Order_Number
WHERE 
Client_Number='C108' AND Delivery_Status='delivered';
-- 18. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity equal
-- to 5.
SELECT 
P.Product_Name
FROM product P


INNER JOIN
salesorderdetails SO ON P.Product_Number=SO.Product_Number
WHERE 
SO.Order_Quantity = 5;
-- 19. Write a query to find the name and number of the salesman who sold pen or TV or laptop.
SELECT distinct
S.Salesman_Name, S.Salesman_Number
FROM salesman S
INNER JOIN
    salesorder O ON S.Salesman_Number = O.Salesman_Number
INNER JOIN
    salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN
    product P ON SO.Product_Number = P.Product_Number
WHERE
	Product_Name in( 'pen' ,'TV' ,'laptop');
-- 20. Lists the salesman’s name sold product with a product price less than 800 and Quantity_On_Hand
-- more than 50.
SELECT 
S.Salesman_Name
from salesman S
INNER JOIN
    salesorder O ON S.Salesman_Number = O.Salesman_Number
INNER JOIN
    salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN
    product P ON SO.Product_Number = P.Product_Number
WHERE 
	Sell_Price <800 and Quantity_On_Hand >50;
-- 21. Write a query to find the name and salary of the salesman whose salary is greater than the average
-- salary.
SELECT 
Salesman_Name,
Salary
FROM salesman 
WHERE
Salary> ANY(SELECT AVG(Salary)from salesman);
-- 22. Write a query to find the name and Amount Paid of the clients whose amount paid is greater than the
-- average amount paid.
SELECT 
Client_Name,Amount_Paid

FROM clients
WHERE
Amount_Paid> ANY(SELECT AVG(Amount_Paid)from clients);
-- 23. Find the product price that was sold to Le Xuan.
SELECT 
    P.Product_Name,
    P.Sell_Price
FROM clients C
INNER JOIN salesorder O ON C.Client_Number = O.Client_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE C.Client_Name = 'Le Xuan';
-- 24. Determine the product name, client name and amount due that was delivered.
SELECT 
    P.Product_Name,
    C.Client_Name,
    C.Amount_Due
FROM clients C
INNER JOIN salesorder O ON C.Client_Number = O.Client_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE O.Delivery_Status = 'delivered';
-- 25. Find the salesman’s name and their product name which is cancelled.
SELECT 
    S.Salesman_Name,
    P.Product_Name
FROM salesman S
INNER JOIN salesorder O ON S.Salesman_Number = O.Salesman_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE O.Order_Status = 'cancelled';
-- 26. Find product names, prices and delivery status for those products purchased by Nguyen Thanh.
SELECT 
    P.Product_Name,
    P.Sell_Price,
    O.Delivery_Status
FROM clients C
INNER JOIN salesorder O ON C.Client_Number = O.Client_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE C.Client_Name = 'Nguyen Thanh';
-- 27. Display the product name, sell price, salesperson name, delivery status, and order quantity information
-- for each customer.
SELECT 
    P.Product_Name,
    P.Sell_Price,
    S.Salesman_Name,
    O.Delivery_Status,
    SO.Order_Quantity,
    C.Client_Name
FROM product P
INNER JOIN salesorderdetails SO ON P.Product_Number = SO.Product_Number
INNER JOIN salesorder O ON SO.Order_Number = O.Order_Number
INNER JOIN salesman S ON O.Salesman_Number = S.Salesman_Number
INNER JOIN clients C ON O.Client_Number = C.Client_Number;
-- 28. Find the names, product names, and order dates of all sales staff whose product order status has been
-- successful but the items have not yet been delivered to the client.
SELECT 
    S.Salesman_Name,
    P.Product_Name,
    O.Order_Date
FROM salesman S
INNER JOIN salesorder O ON S.Salesman_Number = O.Salesman_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE O.Order_Status = 'successful' AND O.Delivery_Status <> 'delivered';
-- 29. Find each clients’ product which in on the way.
SELECT 
    C.Client_Name,
    P.Product_Name
FROM clients C
INNER JOIN salesorder O ON C.Client_Number = O.Client_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
INNER JOIN product P ON SO.Product_Number = P.Product_Number
WHERE O.Delivery_Status = 'On Way';
-- 30. Find salary and the salesman’s names who is getting the highest salary.
SELECT 
    Salary,
    Salesman_Name
FROM salesman
WHERE Salary = (SELECT MAX(Salary) FROM salesman);
-- 31. Find salary and the salesman’s names who is getting second lowest salary.
SELECT 
    Salary,
    Salesman_Name
FROM salesman
WHERE Salary = (SELECT MAX(Salary) FROM salesman WHERE Salary< (SELECT MAX(Salary) FROM salesman));
-- 32. Display lists the ProductName in ANY records in the sale Order Details table has Order Quantity more
-- than 9.
SELECT DISTINCT 
    P.Product_Name
FROM product P
INNER JOIN salesorderdetails SO ON P.Product_Number = SO.Product_Number
WHERE SO.Order_Quantity > 9;
-- 33. Find the name of the customer who ordered the same item multiple times.
SELECT 
    C.Client_Name
FROM clients C
INNER JOIN salesorder O ON C.Client_Number = O.Client_Number
INNER JOIN salesorderdetails SO ON O.Order_Number = SO.Order_Number
GROUP BY C.Client_Name, SO.Product_Number
HAVING COUNT(SO.Order_Number) > 1;
-- 34. Write a query to find the name, number and salary of the salemans who earns less than the average
-- salary and works in any of Thu Dau Mot city.
SELECT 
    Salesman_Name,
    Salesman_Number,
    Salary
FROM salesman
WHERE Salary < (SELECT AVG(Salary) FROM salesman) AND City = 'Thu Dau Mot';
-- 35. Write a query to find the name, number and salary of the salemans who earn a salary that is higher than
-- the salary of all the salesman have (Order_status = ‘Cancelled’). Sort the results of the salary of the lowest to
-- highest.
-- 36. Write a query to find the 4th maximum salary on the salesman’s table.
SELECT DISTINCT Salary
FROM salesman
ORDER BY Salary DESC LIMIT 1 OFFSET 3;
-- 37. Write a query to find the 3th minimum salary in the salesman’s table.
SELECT DISTINCT Salary
FROM salesman
ORDER BY Salary DESC LIMIT 1 OFFSET 2;