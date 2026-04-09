select URGENCY_ID from (select count(*) total, urgency_id from issue group by URGENCY_ID) where total > 1;

# select only new client duplication excluding companies
select URGENCY_ID from (select count(*) total, urgency_id from issue where id in (select ISSUE_ID FROM CLIENT_COMPLAINTS CC INNER JOIN CLIENT_COMPLAINTS_TYPE CT ON CC.ID = CT.ID WHERE CT.TYPE_TAG IN ('عميل جديد', 'Recycle Client', 'زيارة', 'Broker Client', 'أعادة توجيه')) group by URGENCY_ID) where total > 1 and URGENCY_ID not in (select SYS_ID from CLIENT WHERE AGE_GROUP = '100');


delete from issue where id not in (select issue_id from CLIENT_COMPLAINTS);

delete from issue where id in (select max(id) from issue where urgency_id in (select URGENCY_ID from (select count(*) total, urgency_id from issue group by URGENCY_ID) where total > 1) group by URGENCY_ID); 

# delete only new client duplication excluding companies
delete from issue where id in (select max(id) from issue where urgency_id in (select URGENCY_ID from (select count(*) total, urgency_id from issue where id in (select ISSUE_ID FROM CLIENT_COMPLAINTS CC INNER JOIN CLIENT_COMPLAINTS_TYPE CT ON CC.ID = CT.ID WHERE CT.TYPE_TAG IN ('عميل جديد', 'Recycle Client', 'زيارة', 'Broker Client', 'أعادة توجيه')) group by URGENCY_ID) where total > 1 and URGENCY_ID not in (select SYS_ID from CLIENT WHERE AGE_GROUP = '100')) group by URGENCY_ID); 

delete from CLIENT_COMPLAINTS where issue_id not in (select id from issue);

delete from DISTRIBUTION_LIST where client_com_id not in (select id from CLIENT_COMPLAINTS);

// remove comments for deleted clients 

delete from Appointment where client_id  not in (select SYS_ID from client inner join appointment on client.SYS_ID = Appointment.client_id)

# delete bulicated client project
delete FROM client_projects 
WHERE ID NOT IN
   (SELECT MAX(ID)
   FROM client_projects
   GROUP BY CLIENT_ID, PROJECT_ID)
