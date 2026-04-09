insert into client 
value
select 
('1' || CLIENT_CODE),('1' || CLIENT_CODE),CLIENT_NAME,'ذكر',
'أعزب','UL','UL','0',CLIENT_ADDRESS,EMAIL,
1,1,(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) yy,
PERSONAL_IDENTIFICATION_NO,sysdate,'30-40','UL',nvl(CLIEN_JOB,'UL'),0,0,'on',CLIENT_CODE,
CLIENT_NATIONALITY,'UL',nvl(BIRTH_DATE,sysdate)
from ofouk_units.clients_m

# client dif
insert into client 
value
select 
('1' || CLIENT_CODE),('1' || CLIENT_CODE),CLIENT_NAME,'ذكر',
'أعزب','UL','UL','0',CLIENT_ADDRESS,EMAIL,
1,1,(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) yy,
PERSONAL_IDENTIFICATION_NO,sysdate,'30-40','UL',nvl(CLIEN_JOB,'UL'),0,0,'on',CLIENT_CODE,
CLIENT_NATIONALITY,'UL',nvl(BIRTH_DATE,sysdate)
from CLIENTS_M  where CLIENTS_M.CLIENT_CODE not in (SELECT SUBSTR(CLIENT_NO, 2) FROM CLIENT)

insert into client_status 
value
select 
('1' || CLIENT_CODE),'Old',('1' || CLIENT_CODE),'No Description',sysdate,null
from ofouk_units.clients_m


# By Ahmed

insert into PROJECT 
(PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG)
select unique ('1' || stage_code), stage_description, 'UL', SYSDATE, 1, stage_description, '1364111290870', '44', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 1
from CLIENTS_UNITS_VIEW;

update PROJECT set PROJECTFLAG = 1;

insert into PROJECT 
(PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG)
select unique ('1' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), (p.EQ_NO || '-B' || BUILDING_CODE || '-A' || UNIT_CODE ), 'UL', SYSDATE, 1, 'UL', ('1' || STAGE_CODE), 'RES-UNIT', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 0
from CLIENTS_UNITS_VIEW c left join PROJECT p on ('1' || c.STAGE_CODE) = p.PROJECT_ID;

insert into CLIENT_PROJECTS
select unique ('1' || FORM_NO), ('1' || CLIENT_CODE), ('1' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), '1', SYSDATE, 'interested', ('1' || STAGE_CODE), 1000, 'سنه', 'نقدى', 'None', (p.EQ_NO || '-B' || BUILDING_CODE || '-A' || UNIT_CODE ), p.PROJECT_NAME
from CLIENTS_UNITS_VIEW c left join PROJECT p on ('1' || c.STAGE_CODE) = p.PROJECT_ID

# 23-Jun-2014 Migration to correct Units name (run once)#
update PROJECT set project_name = 'PID' || main_proj_id || '-' || SUBSTR(project_name,instr(project_name,'-') + 1) where projectflag = '0';

update
    (select
        c.product_name as old_name,
        p.project_name as new_name
    from client_projects c
        inner join project p on
            p.project_id = c.project_id) up
set up.old_name = up.new_name;

# 25-Aug-2014 to insert status for old migrated units (Solid)
insert into issue_status 
select project_id, '10', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', project_id, 'Housing_Units', 'o', '1'
from project where LOCATION_TYPE in ('RES-UNIT', 'RES-APP') and PROJECT_ID not in 
(select BUSINESS_OBJ_ID from issue_status where OBJECT_TYPE = 'Housing_Units');

# 27-Sep-2014 update intersted to purche
update CLIENT_PROJECTS set PRODUCT_ID = 'purche';


# 28/9/2014 new Data Migration Script
# delte all units
delete from project where PROJECTFLAG = '0';

delete from PROJECT where MAIN_PROJ_ID = '29';
delete from project where project_id in ('21', '22', '15', '19', '11', '12', '29', '25', '1406097595698', '1406097627119', '1406097709717');

delete from CLIENT_PROJECTS;

ALTER TABLE CLIENT_PROJECTS ADD CONSTRAINT CLIENT_FK FOREIGN KEY (CLIENT_ID) REFERENCES CLIENT (SYS_ID) ON DELETE CASCADE ENABLE;

# 2 for RABWA_UNITS
insert into PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) select unique ('2' || stage_code), section_description || ' ' || stage_code, 'UL', SYSDATE, 1, section_description, '1364111290870', '44', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 1 from rabwa_clients_units_view;

insert into PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) select unique ('2' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), (P.PROJECT_NAME || ' ' || BUILDING_CODE || UNIT_CODE), 'UL', SYSDATE, 1, 'UL', ('2' || STAGE_CODE), 'RES-UNIT', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 0 from rabwa_clients_units_view c left join PROJECT p on ('2' || c.STAGE_CODE) = p.PROJECT_ID;

insert into CLIENT_PROJECTS select unique ('2' || FORM_NO), ('2' || CLIENT_CODE), ('2' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), '1', SYSDATE, 'purche', ('2' || STAGE_CODE), 1000, 'سنه', 'نقدى', 'None', (P.PROJECT_NAME || ' ' || BUILDING_CODE || UNIT_CODE), p.PROJECT_NAME from rabwa_clients_units_view c left join PROJECT p on ('2' || c.STAGE_CODE) = p.PROJECT_ID;

# 1 for OFOUK_UNITS
insert into PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) select unique ('1' || stage_code), stage_description, 'UL', SYSDATE, 1, stage_description, '1364111290870', '44', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 1 from ofouk_clients_units_view;
 
insert into PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) select unique ('1' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)) pid, (P.PROJECT_NAME || ' ' || BUILDING_CODE || UNIT_CODE) nm, 'UL', SYSDATE, 1, 'UL', ('1' || STAGE_CODE), 'RES-UNIT', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 0 from ofouk_clients_units_view c left join PROJECT p on ('1' || c.STAGE_CODE) = p.PROJECT_ID;

insert into CLIENT_PROJECTS select unique ('1' || FORM_NO), ('1' || CLIENT_CODE), ('1' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), '1', SYSDATE, 'purche', ('1' || STAGE_CODE), 1000, 'سنه', 'نقدى', 'None', (P.PROJECT_NAME || ' ' || BUILDING_CODE || UNIT_CODE), p.PROJECT_NAME from ofouk_clients_units_view c left join PROJECT p on ('1' || c.STAGE_CODE) = p.PROJECT_ID;


# 19/10/2014 fixing issue status problem
delete from client_projects where client_id not in (select sys_id from client);

insert into issue_status select project_id, '8', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', project_id, 'Housing_Units', 'o', '1' from project where LOCATION_TYPE in ('RES-UNIT', 'RES-APP') and PROJECT_ID not in (select BUSINESS_OBJ_ID from issue_status where OBJECT_TYPE = 'Housing_Units') and project_id not in (select project_id from client_projects) and projectflag = '0';

insert into issue_status select project_id, '10', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', project_id, 'Housing_Units', 'o', '1' from project where LOCATION_TYPE in ('RES-UNIT', 'RES-APP') and PROJECT_ID not in (select BUSINESS_OBJ_ID from issue_status where OBJECT_TYPE = 'Housing_Units');

# update project name
DELETE FROM PROJECT WHERE MAIN_PROJ_ID IN ('21', '22');
DELETE FROM CLIENT_PROJECTS where PRODUCT_CATEGORY_ID IN ('21', '22');
INSERT INTO PROJECT (PROJECT_ID, PROJECT_NAME, EQ_NO, CREATION_TIME, CREATED_BY, PROJECT_DESCRIPTION, MAIN_PROJ_ID, LOCATION_TYPE, FUTILE, COORDINATE, OPTION_ONE, OPTION_TWO, OPTION_THREE, IS_TRNSPRT_STN, IS_MNGMNT_STN, PROJECTFLAG) SELECT UNIQUE ('2' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), (P.PROJECT_NAME || ' ' || 'Villa ' ||  REGEXP_REPLACE(TRIM(UNIT_CODE), '\s*', '')), 'UL', SYSDATE, 1, 'UL', ('2' || STAGE_CODE), 'RES-UNIT', 1, 'UL', 'UL', 'UL', 'UL', 1, 1, 0 FROM RABWA_UNITS C LEFT JOIN PROJECT P ON ('2' || C.STAGE_CODE) = P.PROJECT_ID WHERE P.PROJECT_ID IN ('21', '22');
INSERT INTO CLIENT_PROJECTS SELECT UNIQUE ('2' || FORM_NO), ('2' || CLIENT_CODE), ('2' || TRIM(BUILDING_TYPE) || TRIM(BUILDING_CODE) || TRIM(UNIT_CODE)), '1', SYSDATE, 'purche', ('2' || STAGE_CODE), 1000, 'سنه', 'نقدى', 'None', ('Villa ' || P.PROJECT_NAME || ' ' || REGEXP_REPLACE(TRIM(UNIT_CODE), '\s*', '')), P.PROJECT_NAME FROM RABWA_UNITS C LEFT JOIN PROJECT P ON ('2' || C.STAGE_CODE) = P.PROJECT_ID WHERE P.PROJECT_ID IN ('21', '22');
UPDATE ISSUE_STATUS SET STATUS_NAME = '10' WHERE BUSINESS_OBJ_ID IN (SELECT PROJECT.PROJECT_ID FROM PROJECT WHERE PROJECT.MAIN_PROJ_ID IN ('21', '22'));


# fixing unit status problem
delete from issue_status where BUSINESS_OBJ_ID = '4102';

insert into issue_status values ('4102', '10', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', '4102', 'Housing_Units', 'o', '1');

select distinct I.BUSINESS_OBJ_ID from issue_status i left join (select count(*) coun, BUSINESS_OBJ_ID from issue_status where end_date is null group by BUSINESS_OBJ_ID) u on I.BUSINESS_OBJ_ID = u.BUSINESS_OBJ_ID where u.coun > 1 and i.end_date is null order by i.BUSINESS_OBJ_ID;