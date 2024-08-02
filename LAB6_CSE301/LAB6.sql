use salemanagement;
-- 1. How to check constraint in a table?
SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'salesman';
-- 2. Create a separate table name as “ProductCost” from “Product” table, which contains the information
-- about product name and its buying price.
CREATE TABLE ProductCost (
    ProductName VARCHAR(255),
    BuyingPrice DECIMAL(10, 2)
);
INSERT INTO ProductCost (ProductName, BuyingPrice)
SELECT Product_Name, Cost_Price
FROM product;
-- 3. Compute the profit percentage for all products. Note: profit = (sell-cost)/cost*100
SELECT 
    Product_Name,
    Cost_Price,
    Sell_Price,
    ((Sell_Price - Cost_Price) / Cost_Price * 100) AS ProfitPercentage
FROM 
    product;
-- 4. If a salesman exceeded his sales target by more than equal to 75%, his remarks should be ‘Good’.
ALTER table salesman
ADD remark VARCHAR(255);
UPDATE salesman
SET remark = CASE  WHEN Target_Achieved >=Sales_Target * 1.75 then 'Good'
ELSE remark
end;
-- 5. If a salesman does not reach more than 75% of his sales objective, he is labeled as 'Average'.
UPDATE salesman
SET remark = CASE WHEN Target_Achieved < Sales_Target * 0.75 AND remark != 'Good' THEN 'Average'ELSE remark
END;
-- 6. If a salesman does not meet more than half of his sales objective, he is considered 'Poor'.
UPDATE salesman
SET remark = CASE WHEN Target_Achieved < Sales_Target * 0.5 AND remark NOT IN ('Good', 'Average') THEN 'Poor'ELSE remark
END;
SELECT Salesman_Number, Salesman_Name, Target_Achieved, Sales_Target, remark
FROM salesman;
-- 7. Find the total quantity for each product. (Query)
SELECT 
    p.Product_Number,
    p.Product_Name,
    SUM(sod.Order_Quantity) AS Total_Quantity
FROM 
    product p
INNER JOIN 
    salesorderdetails sod ON p.Product_Number = sod.Product_Number
GROUP BY 
    p.Product_Number , p.Product_Name;
-- 8. Add a new column and find the total quantity for each product.
ALTER table product 
add Total_Quantity INT;

UPDATE product p
JOIN (
    SELECT Product_Number, SUM(Order_Quantity) AS Total_Quantity
    FROM salesorderdetails
    GROUP BY Product_Number
) 
INNER JOIN  salesorderdetails sod ON p.Product_Number = sod.Product_Number
SET p.Total_Quantity = sod.Total_Quantity;
-- 9. If the Quantity on hand for each product is more than 10, change the discount rate to 10 otherwise set to 5.
ALTER table product  
ADD Discount_Rate INT;
UPDATE product p 
 SET Discount_Rate= CASE WHEN Quantity_On_Hand >10 then 10 
 else 5
 end;
-- 10. If the Quantity on hand for each product is more than equal to 20, change the discount rate to 10, if it is
-- between 10 and 20 then change to 5, if it is more than 5 then change to 3 otherwise set to 0.
UPDATE product p 
 SET Discount_Rate= CASE WHEN Quantity_On_Hand >20 then 10 
 WHEN Quantity_On_Hand between 10 and 20 then 5
 WHEN Quantity_On_Hand >5 then 3
 else 0
 end;
-- 11. The first number of pin code in the client table should be start with 7.
SELECT * FROM clients WHERE Pincode not like'%7';
UPDATE clients
SET Pincode = CONCAT('7', SUBSTRING(Pincode, 2))
WHERE Pincode NOT LIKE '7%';
-- 12. Creates a view name as clients_view that shows all customers information from Thu Dau Mot.
ALTER TABLE clients 
ADD Client_View VARCHAR(255);
UPDATE clients
SET Client_View = Client_Name
WHERE City= 'Thu Dau Mot';
-- 13. Drop the “client_view”.
DROP VIEW Client_View;
-- 14. Creates a view name as clients_order that shows all clients and their order details from Thu Dau Mot.
CREATE VIEW clients_order AS
SELECT 
    c.Client_Number,
    c.Client_Name,
    c.Address,
    c.City,
    c.Pincode,
    c.Province,
    c.Amount_Paid,
    c.Amount_Due,
    so.Order_Number,
    so.Order_Date,
    so.Delivery_Status,
    so.Delivery_Date,
    sod.Product_Number,
    sod.Order_Quantity
FROM 
    clients c
JOIN 
    salesorder so ON c.Client_Number = so.Client_Number
JOIN 
    salesorderdetails sod ON so.Order_Number = sod.Order_Number
WHERE 
    c.Province = 'Thu Dau Mot';

SELECT * FROM clients_order;
-- 15. Creates a view that selects every product in the "Products" table with a sell price higher than the average
-- sell price.
CREATE VIEW products_above_average_price AS
SELECT 
    Product_Number,
    Product_Name,
    Quantity_On_Hand,
    Quantity_Sell,
    Sell_Price,
    Cost_Price
FROM 
    product
WHERE 
    Sell_Price > (SELECT AVG(Sell_Price) FROM Product);
SELECT * FROM products_above_average_price;
-- 16. Creates a view name as salesman_view that show all salesman information and products (product names,
-- product price, quantity order) were sold by them.
CREATE VIEW salesman_view AS
SELECT 
    s.Salesman_Number,
    s.Salesman_Name,
    s.Address,
    s.City,
    s.Pincode,
    s.Province,
    s.Salary,
    s.Sales_Target,
    s.Target_Achieved,
    s.Phone,
    p.Product_Name,
    p.Sell_Price,
    sod.Order_Quantity
FROM 
    salesman s
JOIN 
    salesorder so ON s.Salesman_Number = so.Salesman_Number
JOIN 
    salesorderdetails sod ON so.Order_Number = sod.Order_Number
JOIN 
    product p ON sod.Product_Number = p.Product_Number;
SELECT * FROM salesman_view;
-- 17. Creates a view name as sale_view that show all salesman information and product (product names,
-- product price, quantity order) were sold by them with order_status = 'Successful'.
CREATE VIEW sale_view as
SELECT 
	s.Salesman_Number,
    s.Salesman_Name,
    s.Address,
    s.City,
    s.Pincode,
    s.Province,
    s.Salary,
    s.Sales_Target,
    s.Target_Achieved,
    s.Phone,
    p.Product_Name,
    p.Sell_Price,
    sod.Order_Quantity
FROM 
    salesman s
JOIN 
    salesorder so ON s.Salesman_Number = so.Salesman_Number
JOIN 
    salesorderdetails sod ON so.Order_Number = sod.Order_Number
JOIN 
    product p ON sod.Product_Number = p.Product_Number
WHERE so.Order_Status ='Successful';
SELECT * FROM sale_view;
-- 18. Creates a view name as sale_amount_view that show all salesman information and sum order quantity
-- of product greater than and equal 20 pieces were sold by them with order_status = 'Successful'.
CREATE VIEW sale_amount_view AS
SELECT 
    s.Salesman_Number,
    s.Salesman_Name,
    s.Address,
    s.City,
    s.Pincode,
    s.Province,
    s.Salary,
    s.Sales_Target,
    s.Target_Achieved,
    s.Phone,
    sd.Product_Number,
    SUM(sd.Order_Quantity) AS Total_Quantity_Sold
FROM 
    Salesman s
JOIN 
    Salesorder so ON s.Salesman_Number = so.Salesman_Number
JOIN 
    Salesorderdetails sd ON so.Order_Number = sd.Order_Number
WHERE 
    sd.Order_Quantity >= 20
    AND so.Order_Status = 'Successful'
GROUP BY 
    s.Salesman_Number, s.Salesman_Name, s.Address, s.City, s.Pincode, s.Province, s.Salary, s.Sales_Target, s.Target_Achieved, s.Phone, sd.Product_Number;

SELECT * from sale_amount_view ;
-- 19. Amount paid and amounted due should not be negative when you are inserting the data.
ALTER TABLE Clients
ADD CONSTRAINT chk_amount_paid_non_negative CHECK (Amount_Paid >= 0),
ADD CONSTRAINT chk_amount_due_non_negative CHECK (Amount_Due >= 0);
-- 20. Remove the constraint from pincode;

-- 21. The sell price and cost price should be unique.
ALTER TABLE Product
ADD CONSTRAINT unique_sell_price UNIQUE (Sell_Price),
ADD CONSTRAINT unique_cost_price UNIQUE (Cost_Price);
-- 22. The sell price and cost price should not be unique.
SHOW CREATE TABLE Product;
ALTER TABLE Product
DROP INDEX unique_sell_price, DROP INDEX unique_cost_price;


-- 23. Remove unique constraint from product name.
SHOW INDEXES FROM Product;
ALTER TABLE product
DROP INDEX Product_Name;
-- 24. Update the delivery status to “Delivered” for the product number P1007.
UPDATE Salesorder
SET Delivery_Status = 'Delivered'
WHERE Order_Number IN (SELECT Order_Number FROM Salesorderdetails WHERE Product_Number = 'P1007');
-- 25. Change address and city to ‘Phu Hoa’ and ‘Thu Dau Mot’ where client number is C104.
UPDATE clients
SET Address = 'Phu Hoa', City = 'Thu Dau Mot'
WHERE Client_Number = 'C104';
-- 26. Add a new column to “Product” table named as “Exp_Date”, data type is Date.
ALTER TABLE product
ADD Exp_Date DATE;
-- 27. Add a new column to “Clients” table named as “Phone”, data type is varchar and size is 15.
ALTER TABLE clients
ADD Phone VARCHAR(15);
-- 28. Update remarks as “Good” for all salesman.
UPDATE salesman
SET remark = 'Good';
-- 29. Change remarks to "bad" whose salesman number is "S004".
UPDATE salesman
SET remark = 'bad'
WHERE Salesman_Number = 'S004';
-- 30. Modify the data type of “Phone” in “Clients” table with varchar from size 15 to size is 10.
ALTER TABLE clients MODIFY Phone VARCHAR(10);
-- 31. Delete the “Phone” column from “Clients” table.
ALTER TABLE clients DROP COLUMN Phone;
-- 32. alter table Clients drop column Phone;
ALTER TABLE clients DROP COLUMN Phone;
-- 33. Change the sell price of Mouse to 120.
UPDATE product
SET Sell_Price = 120
WHERE Product_Name = 'Mouse';
-- 34. Change the city of client number C104 to “Ben Cat”.
UPDATE clients SET City = 'Ben Cat'
WHERE Client_Number = 'C104';
-- 35. If On_Hand_Quantity greater than 5, then 10% discount. If On_Hand_Quantity greater than 10, then 15%
-- discount. Othrwise, no discount.
UPDATE product
SET Discount_Rate = CASE
WHEN Quantity_On_Hand > 10 THEN 15
WHEN Quantity_On_Hand > 5 THEN 10
ELSE 0
END;
