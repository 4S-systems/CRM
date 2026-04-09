# FROM OFOUK

select '1' || CLIENT_CODE as SYS_ID,'1' || CLIENT_CODE as CLIENT_NO,CLIENT_NAME as NAME , 'UL' as GENDER ,'UL' as MATIRAL_STATUS 
,'UL' as MOBILE ,'UL' as PHONE ,1000 as SALARY ,'UL' as ADDRESS ,'UL' as EMAIL ,1 as ISACTIVE , 1 as CREATED_BY , 
(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) as CLIENTNOBYDATE , 
'UL' as CLIENTSSN , sysdate as CREATION_TIME , '30-40' as AGE_GROUP,'UL' as PARTNER, 'UL' as JOB,0 as OPTION1,0 as OPTION2,'on' as OPTION3,
CLIENT_CODE as CODE ,'UL' as NATIONALITY ,'UL' as REGION , sysdate as BIRTH_DATE , 11 as CURRENT_STATUS , '19-JUL-14 03.04.50.000000000 PM' as CURRENT_STATUS_SINCE
from ofouk_units where '1' || CLIENT_CODE not in (select CLIENT_NO from client);

# FROM RAWBA

select '2' || CLIENT_CODE as SYS_ID,'2' || CLIENT_CODE as CLIENT_NO,CLIENT_NAME as NAME , 'UL' as GENDER ,'UL' as MATIRAL_STATUS 
,'UL' as MOBILE ,'UL' as PHONE ,1000 as SALARY ,'UL' as ADDRESS ,'UL' as EMAIL ,1 as ISACTIVE , 1 as CREATED_BY , 
(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) as CLIENTNOBYDATE , 
'UL' as CLIENTSSN , sysdate as CREATION_TIME , '30-40' as AGE_GROUP,'UL' as PARTNER, 'UL' as JOB,0 as OPTION1,0 as OPTION2,'on' as OPTION3,
CLIENT_CODE as CODE ,'UL' as NATIONALITY ,'UL' as REGION , sysdate as BIRTH_DATE , 11 as CURRENT_STATUS , '19-JUL-14 03.04.50.000000000 PM' as CURRENT_STATUS_SINCE
from rabwa_units where '2' || CLIENT_CODE not in (select CLIENT_NO from client);


# Regency
insert into client value select '300' || FORM_NO as SYS_ID,'300' || FORM_NO as CLIENT_NO,CLIENT_NAME as NAME , 'UL' as GENDER ,'UL' as MATIRAL_STATUS 
,'UL' as MOBILE ,'UL' as PHONE ,1000 as SALARY ,'UL' as ADDRESS ,'UL' as EMAIL ,1 as ISACTIVE , 1 as CREATED_BY , 
(select EXTRACT(MONTH FROM sysdate) from dual )|| '/' || (select EXTRACT(year FROM sysdate) from dual) as CLIENTNOBYDATE , 
'UL' as CLIENTSSN , sysdate as CREATION_TIME , '30-40' as AGE_GROUP,'UL' as PARTNER, 'UL' as JOB,0 as OPTION1,0 as OPTION2,'on' as OPTION3,
FORM_NO as CODE ,'UL' as NATIONALITY ,'UL' as REGION , sysdate as BIRTH_DATE , 11 as CURRENT_STATUS , '19-JUL-14 03.04.50.000000000 PM' as CURRENT_STATUS_SINCE
from REGENCY_UNITS;