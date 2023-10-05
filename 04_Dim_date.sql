USE DM_AdventureWorksDW2012
GO 

CREATE TABLE Dim_date 
(
date_key INT NOT NULL,
full_date DATE NOT NULL,
calendar_year INT NOT NULL,
calender_quarter INT NOT NULL,
calender_month_num INT NOT NULL,
calender_month_name NVARCHAR(15)NOT NULL,

CONSTRAINT Pk_Dim_date PRIMARY KEY CLUSTERED(date_key)

)

--create forginkey 
ALTER TABLE Fact_sales
ADD CONSTRAINT Fk_Dim_date_fact_sales FOREIGN KEY (date_key) 
REFERENCES Dim_date(order_date_key)