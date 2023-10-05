USE DM_AdventureWorksDW2012
GO 

CREATE TABLE Fact_sales
(
product_key INT NOT NULL,
customer_key INT NOT NULL,
territory_key INT NOT NULL,
order_date_key INT NOT NULL,
sales_order_id VARCHAR(50)NOT NULL,
line_number INT NOT NULL,
quantity INT,
unit_price MONEY,
unit_cost MONEY,
tax_amount MONEY,
freight MONEY,
extended_sales MONEY,
extenend_cost MONEY,
created_at DATETIME NOT NULL DEFAULT (GETDATE()),
CONSTRAINT Pk_fact_Sales PRIMARY KEY CLUSTERED (sales_order_id,line_number)
)

--Createforginkeys
ALTER TABLE Fact_sales 
ADD CONSTRAINT FK_Fact_Sales_Dim_product FOREIGN KEY (product_key) 
REFERENCES Dim_product(product_key)

ALTER TABLE fact_sales
ADD CONSTRAINT Fk_fact_sales_dim_customer FOREIGN KEY (customer_key)
REFERENCES Dim_customer(customer_key)

ALTER TABLE Fact_sales
ADD CONSTRAINT FK_Fact_sales_Dim_territory FOREIGN KEY(territory_key)
REFERENCES Dim_territory(territory_key)

ALTER TABLE Fact_sales
ADD CONSTRAINT Fk_Dim_date_fact_sales FOREIGN KEY (order_date_key) 
REFERENCES Dim_date(date_key)

--CREATE INDEXes

CREATE INDEX Fact_Sales_Dim_product
ON Fact_sales(product_key)

CREATE INDEX Fact_Sales_Dim_customer
ON Fact_sales(customer_key)

CREATE INDEX Fact_sales_Dim_territory
ON Fact_sales(territory_key)

CREATE INDEX Fact_sales_Dim_date
ON Fact_sales(order_date_key)