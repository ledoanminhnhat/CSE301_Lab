-- 1. Create a trigger before_total_quantity_update to update total quantity of product when 
-- Quantity_On_Hand and Quantity_sell change values. Then Update total quantity when Product P1004 
-- have Quantity_On_Hand = 30, quantity_sell =35. 
delimiter //
create trigger before_total_quantity_update
before update on product 
for each row
begin
set new.Total_Quantity=new.Quantity_On_Hand + new.Quantity_Sell;
end;
 //  delimiter ;
update product
set Quantity_On_Hand = 30,
    Quantity_Sell = 35
WHERE Product_Number = 'P1004';

-- 2. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman 
-- table (will be stored in PER_MARKS column) : per_remarks = target_achieved*100/sales_target. 
ALTER TABLE Salesman
ADD COLUMN PER_MARKS DECIMAL(5,2); 

delimiter //
create trigger before_remark_salesman_update
before update on salesman
for each row 
begin
set new.PER_MARKS = (Target_Achieved*100)/Sales_Target;
end ;
// delimiter ;
-- 3. Create a trigger before_product_insert to insert a product in product table. 
delimiter //
create trigger before_product_insert
before insert on product 
for each row
begin
end;
delimiter //
-- 4. Create a trigger to before update the delivery status to "Delivered" when an order is marked as 
-- "Successful". 
delimiter //
create trigger before_update_delivery_status
before update on salesorder
for each row
begin
end;
delimiter //
update salesorder
set Delivery_Status='Delivered'
where Delivery_Status='Successful';
-- 5. Create a trigger to update the remarks "Good" when a new salesman is inserted. 
delimiter //
create trigger after_salesman_insert
after insert on salesman
begin
update salesman
set remark='Good'
where Salesman_Number=new.Salesman_Number;
end;
delimiter //

-- 6. Create a trigger to enforce that the first digit of the pin code in the "Clients" table must be 7. 
delimiter //
create trigger before_pincode_check
before insert on clients
for each row
begin 
if left(pincode,1)!= '7'
then set new.Pincode = concat(('7',substring(new.Pincode,2))
end if ;
end;
delimiter //
-- 7. Create a trigger to update the city for a specific client to "Unknown" when the client is deleted 
delimiter //
create trigger after_deleted
after update on clients
for each row

begin 
update clients
set City='Unknown'
where Client_Number=old.Client_Number;
end;
delimiter //
-- 8. Create a trigger after_product_insert to insert a product and update profit and total_quantity in product 
-- table. 
ALTER TABLE product
ADD COLUMN profit DECIMAL(10, 2);

delimiter //
create trigger after_product_insert
after insert on product
for each row
begin
 DECLARE profit DECIMAL(10, 2);
    SET profit = NEW.Sell_Price - NEW.Cost_Price;
    
    -- Update the Profit and Total_Quantity for the newly inserted product
    UPDATE Product
    SET Profit = profit,
        Total_Quantity = NEW.Quantity_On_Hand + NEW.Quantity_Sell
    WHERE Product_Number = NEW.Product_Number;
    end;
delimiter //

-- 9. Create a trigger to update the delivery status to "On Way" for a specific order when an order is inserted. 
delimiter //
create trigger before_insert_delivery
before update on salesorder
for each row
begin 
update salesorder
set Delivery_Status='On Way'
where Order_Number=new.Order_Number 
order by Order_Number asc;
end;
delimiter //
-- 10. Create a trigger before_remark_salesman_update to update Percentage of per_remarks in a salesman 
-- table (will be stored in PER_MARKS column)  If  per_remarks >= 75%, his remarks should be ‘Good’. 
-- If 50% <= per_remarks < 75%, he is labeled as 'Average'. If per_remarks <50%, he is considered 
-- 'Poor'. 

-- 11. Create a trigger to check if the delivery date is greater than the order date, if not, do not insert it. 
delimiter //
create trigger before_salesorder_insert
before insert on salesorder
for each row
begin
if new.Delivery_Date<= new.Order_Date then
set new.Delivery_Date='null';
end if;
end;
// delimiter ;
-- 12. Create a trigger to update Quantity_On_Hand when ordering a product (Order_Quantity).
delimiter // 
create trigger update_quantity_on_hand
before update on salesorderdetails
for each row
begin
update product
set  Quantity_On_Hand=Quantity_On_Hand-new.Order_Quantity
where Product_Number=new.Product_Number;
end;
// delimiter ;

-- b) Writing Function: 
-- Hàm đơn trị 
-- CREATE FUNCTION name_function (Var) 
-- RETURNS data_type 
-- DETERMINISTIC 
-- BEGIN 
-- Statement SQL 
-- RETURN value 
-- END 
-- 1. Find the average salesman’s salary.
delimiter // 
create function average_salary()
returns decimal(10,2)
deterministic
begin 
declare avg_salary decimal(10,2);
select AVG(Salary) into avg_salary
from salesman;
return avg_salary;
end;
//
delimiter ;
SELECT average_salary() AS avg_salary;

-- 2. Find the name of the highest paid salesman. 
delimiter // 
create function name_find_highpaid()
returns decimal(10,2)
deterministic
begin 
declare high_paid decimal(10,2);
select max(Salary) into high_paid
from salesman;
return high_paid;
end;
//
delimiter ;
select name_find_highpaid() as high_paid;
-- 3. Find the name of the salesman who is paid the lowest salary. 
delimiter // 
create function name_find_lowpaid()
returns decimal(10,2)
deterministic
begin 
declare low_paid decimal(10,2);
select min(Salary) into low_paid
from salesman;
return low_paid;
end;
//
delimiter ;
select name_find_lowpaid() as low_paid;
-- 4. Determine the total number of salespeople employed by the company. 
delimiter // 
create function count_employ()
returns decimal(10,2)
deterministic
begin 
declare count_e  decimal(10,2);
select count(*)  into count_e
from salesman;
return count_e;
end;
//
delimiter ;
select count_employ() as count_e;
-- 5. Compute the total salary paid to the company's salesman. 
delimiter // 
create function sum_salary()
returns decimal(10,2)
deterministic
begin 
declare sum_s  decimal(10,2);
select sum(Salary)  into sum_s
from salesman;
return sum_s;
end;
//
delimiter ;
select sum_salary() as sum_s;
-- 6. Find Clients in a Province
 delimiter // 
create function find_clients()
returns varchar(255)
deterministic
begin 
declare client_f varchar(255);
select *  into client_f
from clients
where Province='Binh Dương';
return client_f;
end;
//
delimiter ;
select find_clients() as client_f;

-- 7. Calculate Total Sales 
DELIMITER //

CREATE FUNCTION calculate_total_sales()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_sales DECIMAL(10,2);
    SELECT SUM(Order_Quantity) INTO total_sales
    FROM Salesorderdetails;
    RETURN total_sales;
END;
//
DELIMITER ;

-- 8. Calculate Total Order Amount 
DELIMITER //

CREATE FUNCTION calculate_total_order_amount()
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total_amount DECIMAL(10,2);
SELECT SUM(p.Sell_Price * sod.Order_Quantity) INTO total_amount
    FROM Salesorderdetails sod
    JOIN Product p ON sod.Product_Number = p.Product_Number;
    RETURN total_amount;
END;
//

DELIMITER ;
