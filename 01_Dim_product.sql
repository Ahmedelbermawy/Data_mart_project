USE DM_AdventureWorksDW2012
GO 

CREATE TABLE Dim_product 
(
product_key INT NOT NULL IDENTITY(1,1), -- Surrogate key 
product_id INT NOT NULL , --alternate key, business key ,natural key 
product_name NVARCHAR(50),
product_description NVARCHAR(500),
product_subcategory NVARCHAR(50),
product_category NVARCHAR(50),
color NVARCHAR(15),
model_name NVARCHAR(50),
recoder_point SMALLINT,
standard_cost MONEY,

--Metadata

source_system_code TINYINT NOT NULL,

--SCD

start_date DATETIME NOT NULL DEFAULT(GETDATE()),
end_date DATETIME,
is_current tinyint NOT NULL DEFAULT (1),

CONSTRAINT pk_Dim_product PRIMARY KEY CLUSTERED (product_key)
)

--insert unknown record

SET IDENTITY_INSERT Dim_product ON

INSERT INTO Dim_product (product_key,product_id,product_name,product_description,
product_subcategory,product_category,color,model_name,recoder_point,standard_cost,
source_system_code,start_date,end_date,is_current)
VALUES(0,0,'unknown','unknown','unknown','unknown',
'unknown','unknown',0,0,0,'1900-01-01',NULL,1)

SET IDENTITY_INSERT Dim_product OFF

--create forgin key 

ALTER TABLE Fact_sales 
ADD CONSTRAINT FK_Fact_Sales_Dim_product FOREIGN KEY (product_key) 
REFERENCES Dim_product(product_key)

--Create Indexes

CREATE INDEX Dim_product_product_id
ON Dim_product(product_id)

CREATE INDEX Dim_product_product_categorey 
ON Dim_product(product_category)


