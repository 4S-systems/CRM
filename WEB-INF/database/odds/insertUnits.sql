insert into project value select   unit_no || '-11' as project_id, unit_no || 'زايد ديونز كومبلكس 1' as project_name ,
'UL' as EQ_NO,to_date('10-NOV-14','DD-MON-RR') as creation_time,1 as created_by,'UL' as project_description ,'11' as main_proj_id
,'RES-UNIT' as location_type,1 as futile,'UL' as coordinate,'UL' as option_one,'UL' as option_two,'UL' as option_three,'0' as trnsprt_stn
,'0' is_mngmnt_stn,1 as integrated_id,1 as new_code,0 as projectflag
from odds where odds.STAGE ='اولى';

insert into issue_status select unit_no || '-11', '8', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', unit_no || '-11', 'Housing_Units', 'o', '1' from odds where odds.STAGE ='اولى';


insert into project value select  unit_no || '-12' as project_id, unit_no || 'زايد ديونز كومبلكس 2' as project_name ,
'UL' as EQ_NO,to_date('10-NOV-14','DD-MON-RR') as creation_time,1 as created_by,'UL' as project_description ,'12' as main_proj_id
,'RES-UNIT' as location_type,1 as futile,'UL' as coordinate,'UL' as option_one,'UL' as option_two,'UL' as option_three,'0' as trnsprt_stn
,'0' is_mngmnt_stn,1 as integrated_id,1 as new_code,0 as projectflag
from odds where odds.STAGE ='ثانية';

insert into issue_status select unit_no || '-12', '8', 'UL', 'UL', NULL, SYSDATE, 0, 'UL', 'UL', 'UL', unit_no || '-12', 'Housing_Units', 'o', '1' from odds where odds.STAGE ='ثانية';