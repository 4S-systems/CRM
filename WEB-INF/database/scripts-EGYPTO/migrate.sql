select distinct num from new_client where project = 'Phase 3';

insert into PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) 
select TEMP_SEQ.nextval, num, 'UL', SYSDATE, 1, 'UL', '23', 'RES-UNIT', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 0 from new_client where project = 'Phase 3';

insert into issue_status select TEMP_SEQ.nextval, '8', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', project_id, 'Housing_Units', 'o', '1' from project where LOCATION_TYPE ='RES-UNIT';

select count(*), name from new_client group by name;

insert into client (SYS_ID, CLIENT_NO, NAME, GENDER, MATIRAL_STATUS, MOBILE, PHONE, SALARY, ADDRESS, EMAIL, ISACTIVE, CREATED_BY,
  CLIENTNOBYDATE, CLIENTSSN, CREATION_TIME, AGE_GROUP, PARTNER, JOB, OPTION1, OPTION2, OPTION3, CODE, NATIONALITY, REGION, BIRTH_DATE,
  CURRENT_STATUS, CURRENT_STATUS_SINCE, DESCRIPTION, BRANCH, INTER_PHONE) 
  select TEMP_SEQ.nextval, TEMP_SEQ.nextval, NAME , 'UL', 'UL', MOBILE , PHONE , 1000, 'UL' , EMAIL , 1, 1, (select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) as CLIENTNOBYDATE, 
'UL', sysdate, '30-40', 'UL', 'UL', 0, 0, 'on', 'UL', 'UL', 'UL', sysdate, 11, sysdate, DESCRIPTION || chr(10) || 'Comment: ' || created_by,'UL', 'UL'
from new_Client;

update client set code = client_no;

update client set CREATED_BY = '1458260036819';

insert into issue_status select TEMP_SEQ.nextval, '11', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', sys_id, 'client', 'o', '1' from client where sys_id not in (select BUSINESS_OBJ_ID from issue_status where OBJECT_TYPE = 'client');

insert into issue_status select TEMP_SEQ.nextval, '12', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', sys_id, 'client', 'o', '1' from client where sys_id not in (select BUSINESS_OBJ_ID from issue_status where OBJECT_TYPE = 'client');



UPDATE (
SELECT C.PHONE CLIENT_PHONE, C.MOBILE CLIENT_MOBILE, C.INTER_PHONE CLIENT_INTER_PHONE, NC.PHONE NEW_PHONE, NC.MOBILE NEW_MOBILE, NC.EMAIL NEW_INTER_PHONE, c.name client_name, nc.name FROM CLIENT C left JOIN NEW_CLIENT NC ON C.NAME = NC.NAME
where nc.phone is not null
)
   SET CLIENT_PHONE = NEW_PHONE,
       CLIENT_MOBILE = NEW_MOBILE,
       CLIENT_INTER_PHONE = NEW_INTER_PHONE;

Insert into CLIENT_CAMPAIGN select TEMP_SEQ.nextval,sys_id,'1407136832901',null,null,'Campaign','1458260036819',sysdate from client where current_status = '12' and sys_id not in (select client_id from client_campaign);

Insert into CLIENT_PROJECTS select TEMP_SEQ.nextval,c.sys_id,p.project_id,'1458260036819',sysdate,'purche','29','0','UL','UL','UL',p.project_name,'Ras Sudr Phase 4',null,null,null,null,null,null from new_client nc left join client c on C.NAME = NC.NAME left join project p on NC.NUM = P.PROJECT_NAME;

update issue_status set STATUS_NAME = '10' where BUSINESS_OBJ_ID in (select P.PROJECT_ID from new_client nc left join project p on NC.NUM = p.project_name);