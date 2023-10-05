USE DM_AdventureWorksDW2012
GO 

CREATE TABLE Dim_territory
(
territory_key INT NOT NULL IDENTITY(1,1),
territory_id INT NOT NULL,
territory_name NVARCHAR(50),
territory_country NVARCHAR(400),
territory_group NVARCHAR(50),
source_system_code TINYINT NOT NULL,
start_date DATETIME NOT NULL default (GETDATE()),
end_date DATETIME,
is_current TINYINT NOT NULL default(1),

CONSTRAINT PK_Dim_territory PRIMARY KEY CLUSTERED (territory_key)

)

-- Insert unknown record
SET IDENTITY_INSERT Dim_territory ON

INSERT INTO Dim_territory(territory_key,territory_id,territory_name,territory_country,
territory_group,source_system_code,start_date,end_date,is_current)

VALUES (0,0,'unknown','unknown','unknown',0,'1900-01-01',NULL,1)
SET IDENTITY_INSERT Dim_territory OFF 

-- create foreign key

ALTER TABLE Fact_sales
ADD CONSTRAINT FK_Fact_sales_Dim_territory FOREIGN KEY(territory_key)
REFERENCES Dim_territory(territory_key)


--create indexes

CREATE INDEX Dim_territory_terrtory_id
ON Dim_territory(territory_id)







