set termout on
set feedback on
prompt Deleting Survey Database. Please wait......
set termout off
set feedback off

drop table Roles cascade constraint;
drop table Users cascade constraint;
drop table Survey_Type cascade constraint;
drop table College cascade constraint;
drop table Department cascade constraint;
drop table Course cascade constraint;
drop table Course_Section cascade constraint;
drop table Survey cascade constraint;
drop table Response_Type cascade constraint;
drop table Question cascade constraint;
drop table Response_Option cascade constraint;
drop table Response cascade constraint;

set termout on
set feedback on
PURGE RECYCLEBIN;
prompt SUrvey database deleted......
