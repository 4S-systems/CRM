// dynamic data script

// projects and units

// campagins 

// delete in active users

// delete groups which have no user 




delete from ISSUE;
delete from ISSUE_DOCUMENT;
delete from ISSUE_DOCUMENT_DATA;
delete from ISSUE_STATUS WHERE OBJECT_TYPE <> 'User';
delete from CLIENT_COMPLAINTS;
delete from CLIENT_COMPLAINTS_SLA;
delete from CLIENT_COMPLAINTS_TYPE;
delete from DISTRIBUTION_LIST;
delete from MNTNBLE_UNIT_DOC;
delete from ALERT;
delete from appointment;

delete from COMMENTS;
delete from ARCH_DETAILS;
delete from BOOKMARK;
delete from CLIENT_EMAILS;
delete from CLIENT_INCENTIVE;
delete from CLIENT_PROJECTS;
delete from CLIENT_RATING;
delete from client_campaign;
delete from CLIENT_SEASONS;
delete from ISSUE_DEPENDENCE;
delete from ISSUE_PROJECT;
delete from LOGGER;
delete from RESERVATION;
delete from UNIT_PRICE;
delete from WITHDRAW;
delete from channels;
delete from channels_users;
delete from project where location_type='UNIT-MODEL';
delete from project where location_type='RES-UNIT';
delete from project where location_type='GRG-UNIT';
delete from client;
delete from document;
delete from LOGIN_HISTORY;

-- Delete Projects Data
delete from project where location_type='44';
delete from project_acc;
delete from project_price_history;

// campagins and channels

delete from campaign where CURRENT_STATUS != '20';
delete from record_season;
d season_type;
commit;


-- to delete some table starting with same prefix 'DMRS_', By yasser ibrahim
begin
     for trec in ( select table_name
                   from user_tables
                   where table_name like 'DMRS_%' )
     loop
         execute immediate 'drop table '||trec.table_name;
     end loop;
end;

-- to delete user id forign key from USER_BUSSINESS_OP
ALTER TABLE USER_BUSSINESS_OP DROP CONSTRAINT USER_ID;

CREATE BIGFILE TABLESPACE bigtbs_01
  DATAFILE 'bigtbs_f1.dat'
  SIZE 20M AUTOEXTEND ON;


# To delete new clients
delete from client where CLIENT_NO <> SYS_ID;

delete from client where CURRENT_STATUS <> '11' or CREATION_TIME > '15-Jun-2014';

# to run auto pilot mode
Insert into TRACKER_GROUP values ('1412756961849','Default Auto-Pilot','Default Auto-Pilot Group','1111111111111111111111111111111111111111111111111111111111111111111111111111111111','1',to_date('08-OCT-14','DD-MON-RR'),'manager_agenda.jsp');
Insert into USER_GROUP values ('Default Auto-Pilot','1412756961849','1403765000713','t.gafy','u1403765000713','123','1','1111111111111111111111111111111111111111111111111111111111111111111111111111111111',to_date('08-OCT-14','DD-MON-RR'),'manager_agenda.jsp','manager_agenda.jsp','tamer@metawee.net','1412758570815','UL','0','UL');


# To Delete non completed issue garabage collecor - orphaned issues 
DELETE FROM ISSUE WHERE ID NOT IN (SELECT ISSUE_ID FROM CLIENT_COMPLAINTS);