# for vnassif
# it was requested to promote viola nassif to manager - she was an employee under haitham lotfy
# also demote mohamad gamal and shady fouad to emplyees and put them under vila nassif
# steps
# update vnassif to be manager and change her interface and allocated a department for her

# delete second row in distribution list - which indicates she received tasks as employee

delete from distribution_list where RECEIP_ID = '1415375151758' and CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375151758');

# update first row to make her a direct recipent
update distribution_list set RECEIP_ID = '1415375151758' where CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375151758');

# update issue status to 2 so that tasks appear in incoming 
update issue_status set STATUS_NAME = '2' where end_date is null and BUSINESS_OBJ_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375151758');

# for shady fouad migrated its tasks via the user interace to a temporary manager (buffer variable) xyz 1415375225768 id 

# the following srip migrate tasks under this buffer manager to vnassif
update distribution_list set RECEIP_ID = '1415375151758' where CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375225768');

insert into distribution_list select CLIENT_COM_ID, '1415375151758', '1478958926007', sysdate, '1', null, '0', '0', 'UL', sys_id || '1', 'عميل جديد', ' ', null from distribution_list where CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375225768');

update CLIENT_COMPLAINTS set CURRENT_OWNER_ID = '1478958926007', current_owner = 's.fouad' where CURRENT_OWNER_ID = '1415375225768';

update issue_status set STATUS_NAME = '3' where end_date is null and BUSINESS_OBJ_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1478958926007');

# for mgamal do the sane for mgamal

update distribution_list set RECEIP_ID = '1415375151758' where CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375225768');

insert into distribution_list select CLIENT_COM_ID, '1415375151758', '1457765944750', sysdate, '1', null, '0', '0', 'UL', sys_id || '1', 'عميل جديد', ' ', null from distribution_list where CLIENT_COM_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1415375225768');

update CLIENT_COMPLAINTS set CURRENT_OWNER_ID = '1457765944750', current_owner = 'mgamal' where CURRENT_OWNER_ID = '1415375225768';

update issue_status set STATUS_NAME = '3' where end_date is null and BUSINESS_OBJ_ID in (select id from CLIENT_COMPLAINTS where CURRENT_OWNER_ID = '1457765944750');



# note to remove demoted employees from being manger and put only in sls-employees 
