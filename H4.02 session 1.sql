-- SESSION 1
-- EXECUTE INCLUDING LAST 'GO'

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'TestDB')
BEGIN
  CREATE DATABASE SQLServerInternals
END

set nocount on
use TestDB
go

-- CLEANUP OF PREVIOUS RUNS
if exists(select * from sys.procedures p join sys.schemas s on p.schema_id = s.schema_id 
          where s.name = 'dbo' and p.name = 'ResetData') drop proc dbo.ResetData;
if exists(select * from sys.tables t join sys.schemas s on t.schema_id = s.schema_id 
          where s.name = 'dbo' and t.name = 'Orders') drop table dbo.Orders;

if exists(select * from sys.tables t join sys.schemas s on t.schema_id = s.schema_id 
          where s.name = 'dbo' and t.name = 'Customers') drop table dbo.Customers;
go

create table dbo.Customers
(
    CustomerId int not null,
	constraint PK_Customers
	primary key(CustomerId)
);

go

create proc dbo.ResetData
as
begin
    begin tran
        delete from dbo.Customers;
        insert into dbo.Customers(CustomerId) values(1),(2),(3); -- 3 customers
    commit
end;
go

exec dbo.ResetData;
go

-- NOW EXECUTE select * from customers in another session
-- THEN EXECUTE the next line

insert into dbo.Customers(CustomerId) values(4),(5); -- 2 new customers



