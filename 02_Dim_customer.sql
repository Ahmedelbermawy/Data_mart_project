USE DM_AdventureWorksDW2012
GO 

CREATE TABLE Dim_customer
(
customer_key INT NOT NULL  IDENTITY (1,1),
customer_id INT NOT NULL, 
customer_name NVARCHAR(150),
address1 NVARCHAR(100),
address2 NVARCHAR(100),
city NVARCHAR(30),
phone NVARCHAR(25),
 -- birth_date date,
 -- marital_status char(10),
 -- gender char(1),
 -- yearly_income money,
 -- education varchar(50),
 source_system_code TINYINT NOT NULL,
 START_dATE DATETIME NOT NULL default (GETDATE()),
 END_DATE DATETIME NULL,
 is_current TINYINT NOT NULL default(1),

 CONSTRAINT PK_Dim_customer PRIMARY KEY CLUSTERED (customer_key)
)

-- Create Foreign Keys

ALTER TABLE fact_sales
ADD CONSTRAINT Fk_fact_sales_dim_customer FOREIGN KEY (customer_key)
REFERENCES Dim_customer(customer_key)

-- Insert unknown record

SET IDENTITY_INSERT Dim_customer ON

INSERT INTO Dim_customer(customer_key,customer_id,customer_name,address1,address2,city,phone,
source_system_code,START_DATE,END_DATE,is_current)

VALUES(0,0,'Unknown','Unknown','Unknown','Unknown', 'Unknown', 0,'1900-01-01', NULL, 1 )

SET IDENTITY_INSERT Dim_customer OFF

-- Create Indexes

CREATE INDEX Dim_customer_customer_id
  ON Dim_customer(customer_id)

CREATE INDEX Dim_customer_city
  ON Dim_customer(city)