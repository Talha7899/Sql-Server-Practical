create database Practical;

use Practical;

--Create a table named Customers with columns: CustomerID, FirstName, LastName, Email, and PhoneNumber.

create table Customers(
	CustomerID int primary key identity,
	FirstName varchar(50),
	LastName varchar(50),
	Email varchar(100),
	PhoneNumber varchar(11)
);

--Create a table named Orders with columns: OrderID, CustomerID, OrderDate, and TotalAmount.

create table Orders(
	OrderID int primary key identity,
	CustomerID int foreign key
	references Customers(CustomerID),
	OrderDate date,
	TotalAmount int

);

select * from Customers;
select * from Orders;

--Create a table named Products with columns: ProductID, ProductName, UnitPrice, and InStockQuantity.

create table Products(
	ProductID int primary key identity,
	ProductName varchar(100),
	UnitPrice int,
	InStockQuantity int
);

--Create a table named OrderDetails with columns: OrderDetailID, OrderID, ProductID, Quantity, and UnitPrice.

create table OrderDetails(
	OrderDetailID int primary key identity,
	OrderID int foreign key
	references Orders(OrderID),
	ProductID int foreign key
	references Products(ProductID),
	Quantity int,
	UnitPrice int
);

select * from Products;
select * from OrderDetails;

-- Inserting records into the Customers table

INSERT INTO Customers (FirstName, LastName, Email, PhoneNumber) VALUES
('John', 'Doe', 'john.doe@example.com', '12345678901'),
('Jane', 'Smith', 'jane.smith@example.com', '23456789012'),
('Michael', 'Johnson', 'michael.johnson@example.com', '34567890123'),
('Emily', 'Williams', 'emily.williams@example.com', '45678901234'),
('William', 'Brown', 'william.brown@example.com', '56789012345'),
('Emma', 'Jones', 'emma.jones@example.com', '67890123456'),
('Daniel', 'Garcia', 'daniel.garcia@example.com', '78901234567'),
('Olivia', 'Martinez', 'olivia.martinez@example.com', '89012345678'),
('James', 'Hernandez', 'james.hernandez@example.com', '90123456789'),
('Sophia', 'Lopez', 'sophia.lopez@example.com', '01234567890');


-- Create Orders table
CREATE TABLE Orders (
    OrderID int PRIMARY KEY IDENTITY,
    CustomerID int,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    OrderDate date,
    TotalAmount int
);

-- Insert 10 orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2024-02-01', 100),
(2, '2024-02-02', 150),
(3, '2024-02-03', 200),
(4, '2024-02-04', 175),
(5, '2024-02-05', 120),
(6, '2024-02-06', 90),
(7, '2024-02-07', 220),
(8, '2024-02-08', 180),
(9, '2024-02-09', 130),
(10, '2024-02-10', 240);

select * from Orders;

-- Insert 10 products for both men and women
INSERT INTO Products (ProductName, UnitPrice, InStockQuantity) VALUES
('Shirt', 30, 50),
('Jeans', 40, 40),
('Shoes', 60, 30),
('Watch', 100, 20),
('Cologne', 50, 25),
('Dress', 50, 60),
('Handbag', 70, 35),
('Women Shoes', 80, 45),
('Women Jewelry Set', 120, 15),
('Women Perfume', 60, 20);

select * from Products;

-- Insert 10 order details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 2, 30),
(1, 2, 1, 40),
(2, 3, 3, 60),
(2, 4, 1, 100),
(3, 5, 2, 50),
(3, 6, 2, 50),
(4, 7, 1, 70),
(4, 8, 2, 80),
(5, 9, 3, 120),
(5, 10, 1, 60);

select * from OrderDetails;


--1) Create a new user named Order_Clerk with permission to insert new orders and update order details in the Orders and OrderDetails tables.

create login Order_Clerk with password = 'admin';

create user Order_Clerk for login Order_Clerk;

grant insert on dbo.Orders to Order_Clerk;
grant update on dbo.OrderDetails to Order_Clerk;
grant select on dbo.OrderDetails to Order_Clerk;
select * from Orders;
select * from Customers;
select * from OrderDetails;
insert into Customers values ('Waqas','Ali','waqas.ali@example.com','54678924793');



--2) Create a trigger named Update_Stock_Audit that logs any updates made to the InStockQuantity column of the Products table into a Stock_Update_Audit table.

create table Stock_Audit(
	Stock_Audit_Id int primary key identity,
	Stock_Audit_Info varchar(200)
);

create trigger Update_Stock_Audit
on Products after update
as
begin
declare @StockQuantity int
select @StockQuantity = InStockQuantity from inserted
select * from inserted
select * from deleted
insert into Stock_Audit values
('Update InStockQuantity Column in Products Table ' + CAST(@StockQuantity as varchar(150)))
end

select * from Products;

update Products set InStockQuantity = 20 where ProductID = 9;

select * from Stock_Audit;


--3) Write a SQL query that retrieves the FirstName, LastName, OrderDate, and TotalAmount of orders along with the customer details by joining the Customers and Orders tables.

select FirstName,LastName,OrderDate,TotalAmount
from Customers as c join Orders as o
on c.CustomerID = o.CustomerID;


--4) Write a SQL query that retrieves the ProductName, Quantity, and TotalPrice of products ordered in orders with a total amount greater than the average total amount of all orders.

select ProductName,Quantity,TotalAmount
from Products as p join OrderDetails as od
on p.ProductID = od.ProductID
join Orders as o on o.OrderID = od.OrderID;


--5) Create a stored procedure named GetOrdersByCustomer that takes a CustomerID as input and returns all orders placed by that customer along with their details.

select * from Orders;
select * from OrderDetails;

create procedure GetOrdersByCustomer
@CustomerID as int
as
begin
select OrderDate,TotalAmount,
ProductID,Quantity,UnitPrice
from Orders as o join OrderDetails as od
on o.OrderID = od.OrderID
where o.CustomerID = @CustomerID
end

EXEC GetOrdersByCustomer @CustomerID = 1;


--6) Write a SQL query to create a view named OrderSummary that displays the OrderID, OrderDate, CustomerID, and TotalAmount from the Orders table.

select * from Orders;

create view vW_OrderSummary
as
select OrderID,OrderDate,CustomerID,TotalAmount
from Orders;

select * from  vW_OrderSummary;


--7) Create a view named ProductInventory that shows the ProductName and InStockQuantity from the Products table.

create view vW_ProductInventory
as
select ProductName,InStockQuantity from Products;

select * from vW_ProductInventory;

--8) Write a SQL query that joins the OrderSummary view with the Customers table to retrieve the customer's first name and last name along with their order details.


select OrderID,OrderDate,TotalAmount,c.FirstName,c.LastName from vW_OrderSummary as v join
Customers as c on v.CustomerID = c.CustomerID;