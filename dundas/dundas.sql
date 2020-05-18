#create tables
Create Table Products (
 ProductID INTEGER PRIMARY KEY,
 Name VARCHAR(10),
 UnitPrice Integer
);

Create Table SalesPerson(
	PersonID Integer PRIMARY KEY,
	Name varchar(30),
	City varchar(30)
);

Create Table Customers(
	CustomerID Integer Primary Key, 
	Company varchar(50),
	City varchar(30)
);

Create Table Orders(
	OrderID Integer Primary Key, 
	CustomerID Integer,
	PersonID Integer, 
	ProductID Integer, 
	Quantity Integer,
	Discount Decimal(10,2)
);

#add data
insert into Products(ProductID, Name, UnitPrice)
values 
("1","Chart","999"),
("2","Gauge","599"),
("3","Map","599");

insert into SalesPerson(PersonID, Name, City)
values 
("101","Andy","Toronto"),
("102","Bob","Montreal"),
("103","Matthew","Vancouver");

insert into Customers (CustomerID, Company, City)
values
("10089","IBM","Toronto"),
("24535","Johnsons","Toronto"),
("33555","Goodies","Montreal");

insert into Orders (OrderID, CustomerID, PersonID, ProductID, Quantity, Discount)
values
("1","75353","103","2","5",""),
("2","24535","102","1","20","0.05"),
("3","10089","101","3","3",""),
("4","10089","101","1","55","0.2"),
("5","33555","101","1","2","");

# query that shows the total sales amount by each sales person for each product.
Select O.PersonID,S.Name 'Salesperson Name', O.ProductID,P.Name 'Product Name',
SUM(O.Quantity)'# of Units', (P.UnitPrice*SUM(O.Quantity)) 'Sales Amount',
(P.UnitPrice - (P.UnitPrice * O.Discount/100))*Sum(O.Quantity)'Real sales amount with discount'
From Orders O 
inner join Products P on O.ProductID = P.ProductID
inner join SalesPerson S on O.PersonID = S.PersonID
Group by O.PersonID,S.Name, O.ProductID, P.Name,P.UnitPrice, O.Discount;

#query that shows all the products ordered by IBM, including number of units and total sales amount.
Select O.CustomerID, C.Company, O.ProductID, P.Name 'Product Name', 
SUM(O.Quantity)'# of units', (P.UnitPrice*SUM(O.Quantity))'Sales Amount',
(P.UnitPrice - (P.UnitPrice * O.Discount/100))*Sum(O.Quantity)'Real sales amount with discount'
From Orders O 
inner join Products P on O.ProductID = P.ProductID
inner join SalesPerson S on O.PersonID = S.PersonID
inner join Customers C on C.CustomerID = O.CustomerID
Where O.CustomerID = 10089
Group by O.CustomerID, C.Company, P.UnitPrice,O.ProductID, P.Name, O.Discount
Order by ProductID ASC;

