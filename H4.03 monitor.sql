-- MONITOR
-- step 3
-- All active requests to Lock Manager:
select resource_type,request_mode,request_type,
request_status,request_session_id 
from sys.dm_tran_locks;
-- last line shows 2nd session
-- is waiting for a shared lock

-- show session id that blocks session 2
select session_id, wait_duration_ms,blocking_session_id
from sys.dm_os_waiting_tasks where session_id > 50
and blocking_session_id is not null

-- show more information
select 	db_name(TL1.resource_database_id) as [DB Name]
	,TL1.request_session_id as [Session]
	,TL1.request_mode as [Mode]
	,TL1.request_status as [Status]
	,WT.wait_duration_ms as [Wait (ms)]
	,QueryInfo.sql							
from
	sys.dm_tran_locks TL1 with (nolock) 
		join sys.dm_tran_locks TL2 with (nolock) on
			TL1.resource_associated_entity_id =
				TL2.resource_associated_entity_id
		left outer join sys.dm_os_waiting_tasks WT with (nolock) on
			TL1.lock_owner_address = WT.resource_address and 
			TL1.request_status = 'WAIT'
	outer apply
	(
		select
			substring(
				S.text, 
				(er.statement_start_offset / 2) + 1,
				((
					case 
						er.statement_end_offset
					when -1 
						then datalength(S.text)
						else er.statement_end_offset
					end - er.statement_start_offset) / 2) + 1
			) as sql,
			qp.query_plan
		from 
			sys.dm_exec_requests er with (nolock)
				cross apply sys.dm_exec_sql_text(er.sql_handle) S
				cross apply sys.dm_exec_query_plan(er.plan_handle) qp
		where
			TL1.request_session_id = er.session_id
	)  QueryInfo
where
	TL1.request_status <> TL2.request_status and
	(
		TL1.resource_description = TL2.resource_description OR
		(TL1.resource_description is null and 
			TL2.resource_description is null)
	)
option (recompile);
go