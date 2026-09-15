-- SESSION 1 (blocking session)
-- step 1
select @@spid as session_id
go
use Northwind
go
begin tran

delete from customers 
where customerid = 'PARIS'

-- step 4
rollback
