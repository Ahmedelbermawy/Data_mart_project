USE AdventureWorks2012
GO 
-------------Dim_product----------------------
---source Data flow 
select 
productid as product_id,
Name AS product_name,
color,
ReorderPoint AS reorder_point,
StandardCost AS standard_cost,
ProductSubcategoryID,
ProductModelID
FROM production.product 
---------
---source Data flow 
SELECT pm.ProductModelID,pm.Name AS model_name,pd.Description AS product_description
FROM production.ProductModel pm LEFT JOIN production.productmodelproductDescriptionculture AS pdi
ON pm.ProductModelID = pdi.ProductModelID LEFT JOIN production.ProductDescription pd 
ON pdi.ProductDescriptionID = pd.ProductDescriptionID
WHERE pdi.CultureID='en'OR pdi.CultureID IS NULL 
UNION ALL 
SELECT NULL,NULL,NULL
------------------
SELECT ps.ProductCategoryID,
ps.Name AS Product_Subcategory,
pc.name AS product_category
FROM production.ProductSubcategory ps
LEFT JOIN production.productcategory AS pc 
ON ps.ProductCategoryID = pc.ProductCategoryID
union ALL 
SELECT NULL,NULL,NULL
-----------finshed----------------------
------------TEst Dim product ----------------
SELECT count (* )
FROM Dim_product

SELECT product_key,product_key % 10 
FROM dim_product

--delete 10% of recordes in dim_product 
DELETE from Dim_product
WHERE product_key %10=6 

--update product color
UPDATE Dim_product 
SET color ='Dark-Green'
WHERE product_key % 10=3

--update recorder_point by adding 10% to original value 
UPDATE Dim_product 
SET recoder_point =ROUND(recoder_point *1.1,0)
WHERE product_key %10=4

-------------------Dim_customer---------------------------------------------------
---source Data flow 
select Customerid as customer_id,personID
from sales.Customer
where personID is not null 
union all 
SELECT null,NULL
--------vlookup-----
SELECT 
P.businessEntityid AS personid,
CAST((ISNULL(P.firstname,'')+' '+ISNULL(P.Middlename,'')+' '+ISNULL(P.lastname,'')) AS NVARCHAR(150)) AS customer_name,
a2.addressline1 AS address1,
a2.addressline2 AS address2,
a2.city,
pp.phonenumber AS phone 
FROM person.Person p LEFT JOIN person.BusinessEntityAddress bea
ON bea.BusinessEntityID=P.BusinessEntityID
AND bea.AddressTypeID=2
LEFT JOIN person.Address AS a2
ON bea.AddressID = a2.AddressID
LEFT JOIN person.PersonPhone pp
ON p.BusinessEntityID = pp.BusinessEntityID
---------------------------test dim customer--------------------------
-- delete ~10% of records in dim_customer 
DELETE FROM Dim_customer 
WHERE  customer_id % 50 = 2

-- update city for ~10% in dim_customer 
UPDATE dim_customer 
SET    city = 'cairo' 
WHERE  city = 'paris'; 

-- update phone number 
UPDATE dim_customer 
SET    phone = Substring(phone, 10, 3) 
               + Substring(phone, 4, 5) 
			   + Substring(phone, 9, 1) 
               + Substring(phone, 1, 3) 
WHERE  Len(phone) = 12 
       AND LEFT(phone, 3) BETWEEN '101' AND '125'

-- updated records - type 2 
SELECT customer_id, 
       Count(*) 
FROM   dim_customer 
GROUP  BY customer_id 
HAVING Count(*) > 1 

SELECT * 
FROM   dim_customer 
WHERE  customer_id = 11036
----------------Dim territory -----------------------------
CREATE TABLE lookup_country 
  ( 
     country_id INT NOT NULL IDENTITY(1, 1), 
     counttry_name  NVARCHAR(50) NOT NULL, 
     country_code   NVARCHAR(2) NOT NULL, 
     country_region NVARCHAR(50) 
  ) 
INSERT INTO lookup_country (counttry_name, country_code, country_region) 
VALUES  ('United States', 'US', 'North America'), ('Canada', 'CA', 'North America'),('France', 'FR', 'Europe'), 
('Germany', 'DE', 'Europe'),('Australia', 'AU', 'Pacific'),('United Kingdom', 'GB', 'Europe')
----------------
--insert DATA flow
SELECT
	TerritoryID AS territory_id,
	Name AS territory_name,
	CountryRegionCode AS country_code
FROM Sales.SalesTerritory
---
SELECT
	[country_id],
	[counttry_name] AS territory_country,
	[country_code],
	[country_region] AS territory_group
FROM [lookup_country]
------------------fact_sales------------------
--insert data flow
SELECT
	SalesOrderID,
	SalesOrderNumber,
	CONVERT(date, OrderDate) AS OrderDate,
	CustomerID,
	TerritoryID,
	TaxAmt,
	Freight
FROM Sales.SalesOrderHeader
WHERE OnlineOrderFlag = 1
ORDER BY SalesOrderID
-------------
SELECT
	SalesOrderID,
	SalesOrderDetailID,
	OrderQty,
	ProductID,
	UnitPrice,
	UnitPriceDiscount,
	LineTotal
FROM sales.SalesOrderDetail
ORDER BY SalesOrderID

--------------------lkp s----------------
SELECT
	customer_key,
	customer_id
FROM dim_customer
WHERE is_current = 1

SELECT
	product_key,
	product_id,
	standard_cost
FROM dim_product
WHERE is_current = 1

SELECT
	territory_key,
	territory_id
FROM dim_territory
WHERE is_current = 1

SELECT
	date_key AS order_date_key,
	full_date
FROM dim_date
