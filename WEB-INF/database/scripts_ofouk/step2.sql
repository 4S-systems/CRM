-- insert diff clients from clients_m
insert into client 
value
select 
('1' || CLIENT_CODE),('1' || CLIENT_CODE),CLIENT_NAME,'ذكر',
'أعزب','UL','UL','0',CLIENT_ADDRESS,EMAIL,
1,1,(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) yy,
PERSONAL_IDENTIFICATION_NO,sysdate,'30-40','UL',nvl(CLIEN_JOB,'UL'),0,0,'on',CLIENT_CODE,
CLIENT_NATIONALITY,'UL',nvl(BIRTH_DATE,sysdate),'11',sysdate
from CLIENTS_M  where CLIENTS_M.CLIENT_CODE not in (SELECT SUBSTR(CLIENT_NO, 2) FROM CLIENT);

