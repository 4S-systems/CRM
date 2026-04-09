-- clear project data from ofouk and rabwa
delete from project where PROJECTFLAG = '0';
delete from PROJECT where MAIN_PROJ_ID = '29';
delete from project where project_id in ('21', '22', '15', '19', '11', '12', '29', '25', '1406097595698', '1406097627119', '1406097709717');
delete from CLIENT_PROJECTS;