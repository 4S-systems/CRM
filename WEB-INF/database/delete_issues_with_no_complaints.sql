delete from issue where ID not in (select ISSUE_ID from client_complaints);
