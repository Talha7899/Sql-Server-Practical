insert into Orders(CustomerID,OrderDate,TotalAmount)
values(11,'2024-02-11',300);

update OrderDetails set Quantity = 4,UnitPrice = 70
where OrderDetailID = 3;

select * from OrderDetails;