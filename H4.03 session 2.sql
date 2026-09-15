-- SESSION 2 (blocked session)
-- step 2
select @@spid as session_id
go
use Northwind
go
select customerid, companyname
from customers
where customerid = 'PARIS'

