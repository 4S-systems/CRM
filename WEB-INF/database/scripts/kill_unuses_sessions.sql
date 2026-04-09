SELECT 'ALTER SYSTEM KILL SESSION '''||sid||','||serial#||''' IMMEDIATE;' 
FROM v$session 
where username='elite' AND STATUS = 'INACTIVE'  order by PREV_EXEC_START;
