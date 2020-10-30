--Sample databse for a University Survey Application
--CS5332: Project Phase 2
--Author: Ryan Galloway
--Fall 2020


set termout on
set feedback on
prompt Building Survey Database. Please wait......
--set termout off
--set feedback off

--formating for sql plus to make commandline more readable
--when querying
set linesize 300
set pagesize 30
set pause on

--clean up old tables if left in DB
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


PURGE RECYCLEBIN;

--Only 4 tuples exists for this table: 5 is infeasible to my design
--These are the roles available for assignment
create table Roles (
    role_id NUMBER(2) PRIMARY KEY,
    role_description VARCHAR(12)
);

insert into Roles values (1, 'Admin');
insert into Roles values (2, 'Student');
insert into Roles values (3, 'Faculty');
insert into Roles values (4, 'Guest');

--Store information about the user
create table Users (
    user_id         NUMBER(6) PRIMARY KEY,
    user_name       VARCHAR(50),
    name            VARCHAR(35),
    email           VARCHAR(100),
    dob             DATE,
    role_id         NUMBER(2) NOT NULL REFERENCES Roles(role_id),
    gender          CHAR(1) CONSTRAINT valid_gender CHECK (gender IN ('M', 'F')),
    ethnicity       VARCHAR(16) CONSTRAINT valid_ethnicity 
                    CHECK (ethnicity IN ('White', 'Latino', 'American Indian', 'African American', 'Other Pacific Islander', 'Asian')),
    diabled_status  CHAR(1) CONSTRAINT valid_disabled_status CHECK(diabled_status IN ('Y', 'N')),
    veteran_status  CHAR(1) CONSTRAINT valid_veteran_status CHECK(veteran_status IN ('Y', 'N'))
);

insert into Users values (1, 'catlover99', 'Valeri Marie Jones', 'vm123@txstate.edu', TO_DATE ('1999-04-10', 'yyyy/mm/dd'), 2, 'F', 'African American', 'N', 'N');
insert into Users values (2, 'DBHero', 'Ryan J. Galloway', 'rjg111@txstate.edu', TO_DATE ('1980-04-01', 'yyyy/mm/dd'), 1, 'M', 'White', 'Y', 'Y');
insert into Users values (3, 'DRMetsis', 'Vangelis Metsis', 'vm3080@txstate.edu', TO_DATE ('1978-03-01','yyyy/mm/dd'), 3, 'M', 'White', 'N', 'N');
insert into Users values (4, 'DRMOriuchi', 'Mayumi Moriuchi', 'mm123@txstate.edu', TO_DATE ('1990-01-01','yyyy/mm/dd'), 3, 'F', 'Asian', 'N', 'N');
insert into Users values (5, 'bobcat21', 'Phillip Cahhooney', 'pac19@txstate.edu', TO_DATE ('2000-08-22', 'yyyy/mm/dd'), 2, 'M', 'White', 'N', 'N');
insert into Users (user_id, role_id) values (6, 4);
insert into Users values (7, 'MrMeeSeeks', 'Tom Avonaco', 'vm123@txstate.edu', TO_DATE('2002/03/29', 'yyyy/mm/dd'), 2, 'M', 'American Indian', 'Y', 'N');
insert into Users values (8, 'DRNgu', 'Anne Ngu', 'an44@txstate.edu', NULL, 3, 'F', NUll, 'N', 'N');

--This table stores the types of surveys available and whether the type is public or private
--New templates can be created in this table
create table Survey_Type(
    survey_type_id  NUMBER(6) PRIMARY KEY,
    survey_type     VARCHAR(40),
    university_only CHAR(1) CONSTRAINT check_Uni_Only CHECK(university_only IN ('1', '0'))
);

insert into Survey_Type values (1,'Course Evaluation Survey', '1');
insert into Survey_Type values (2,'Custom Survey', '0');
insert into Survey_Type values (3,'Campus Climate Survey', '1');
insert into Survey_Type values (4,'Computer Science Research Survey', '1');
insert into Survey_Type values (5,'Computer Science Seminar Survey', '1');

--The following tables: College, Department, Course, and Course_Section
--are used in reporting for specific types of surveys, i.e. course evaluation
--in which the section, teach, department, and college are linked to a 
--particular course evaluation survey

create table College(
    college_id      NUMBER(2) PRIMARY KEY,
    college_name    VARCHAR(45)
);

insert into College values (1, 'Science and Engineering');
insert into College values (2, 'Liberal Arts');
insert into College values (3, 'Applied Arts');
insert into College values (4, 'Business Administration');
insert into College values (5, 'Education');

create table Department(
    department_id   NUMBER(2) PRIMARY KEY,
    college_id      NUMBER(2) NOT NULL REFERENCES College(college_id),
    department_name VARCHAR(45)
);

insert into Department values (1, 1, 'Computer Science');
insert into Department values (2, 2, 'World Languages and Literature');
insert into Department values (3, 1, 'Biology');
insert into Department values (4, 1, 'Engineering Technology');
insert into Department values (5, 1, 'Mathematics');

create table Course(
    course_id       NUMBER(3) PRIMARY KEY,
    course_name     VARCHAR(45),
    department_id   NUMBER(2) NOT NULL REFERENCES Department(department_id)
);

insert into Course values (1, 'Algorithm Design and Analysis', 1);
insert into Course values (2, 'Japanese I', 2);
insert into Course values (3, 'Advanced Database Theory and Design', 1);
insert into Course values (4, 'Data Structures', 1);
insert into Course values (5, 'Introduction to Database Systems', 1);


create table Course_Section(
    course_section_id NUMBER(3) PRIMARY KEY,
    course_id         NUMBER(3) NOT NULL REFERENCES Course(course_id),
    user_id           NUMBER(6) NOT NULL REFERENCES Users(user_id),
    section_num       NUMBER(3) 
);

insert into Course_Section values (1, 1, 3, 101);
insert into Course_Section values (2, 1, 3, 102);
insert into Course_Section values (3, 2, 4, 201);
insert into Course_Section values (4, 2, 4, 202);
insert into Course_Section values (5, 3, 7, 303);
insert into Course_Section values (6, 3, 7, 304);

--Used for survey creation and storing start and end dates/times
create table Survey(
    survey_id           NUMBER(6) PRIMARY KEY,
    survey_type_id      NUMBER(6) NOT NULL REFERENCES Survey_Type(survey_type_id),
    user_id             NUMBER(6) NOT NULL REFERENCES Users(user_id),
    course_section_id   Number(3) REFERENCES Course_Section(course_section_id),
    starting_date          DATE,
    ending_date            DATE
);

insert into Survey values (1, 2, 1, NULL, TO_DATE('2020/10/31 21:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/11/10 21:00:00', 'yyyy/mm/dd hh24:mi:ss'));
insert into Survey values (2, 3, 1, NULL, TO_DATE('2020/10/29 22:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/11/3 23:30:00', 'yyyy/mm/dd hh24:mi:ss'));
insert into Survey values (3, 3, 1, NULL, TO_DATE('2020/10/31 21:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/11/10 21:00:00', 'yyyy/mm/dd hh24:mi:ss'));
insert into Survey values (4, 2, 1, NULL, TO_DATE('2020/10/31 21:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/11/10 21:00:00', 'yyyy/mm/dd hh24:mi:ss'));
insert into Survey values (5, 1, 1, 1, TO_DATE('2020/11/30 18:00:00', 'yyyy/mm/dd hh24:mi:ss'), TO_DATE('2020/12/12 18:00:00', 'yyyy/mm/dd hh24:mi:ss'));

--This table stores the response types available to the surveys.
create table Response_Type (
    response_type_id NUMBER (2) PRIMARY KEY,
    response_type    VARCHAR (20)
);

insert into Response_Type values (1, 'Yes/No');
insert into Response_Type values (2, 'Agreement Scale');
insert into Response_Type values (3, 'Poor Scale');
insert into Response_Type values (4, 'Single Textbox');
insert into Response_Type values (5, 'Rating');
insert into Response_Type values (6, 'True/False');

--Stores information about the question to include
--the actual text for the question created by 
--the survey creator
create table Question (
    question_id      NUMBER(8) PRIMARY KEY,
    question_text    VARCHAR(200),
    survey_id        NUMBER(6) NOT NULL REFERENCES Survey(survey_id),
    response_type_id NUMERIC(6) NOT NULL REFERENCES Response_Type(response_type_id)
);

insert into Question values (1, 'What is your favorite food?', 1, 4);
insert into Question values (2, 'How do you feel about this statement: Oranges are a delicious healthy snack?', 1, 2);
insert into Question values (3, 'Do you feel safe at the University?', 3, 6);
insert into Question values (4, 'The University administration listens to concerns you raise.', 3, 6);
insert into Question values (5, 'The hours of operation for the dining hall are convienent.', 3, 6);
insert into Question values (6, 'The number of tutors in the labs are sufficent when help is needed.', 3, 6);
insert into Question values (7, 'The dorms are generally clean and fullfill your living needs.', 3, 6);
insert into Question values (8, 'How do you feel your eating habits are?', 1, 3);

--This table stores the actual text displayed to the user as an option for a particular response type.
--This is what is used to track responses in the response table without repeating the options unnecessarily.
create table Response_Option (
    response_option_id   NUMBER(4) PRIMARY KEY,
    response_type_id     NUMBER(2) NOT NULL REFERENCES Response_Type(response_type_id),
    response_option_text VARCHAR(20)
);

insert into Response_Option values (1, 1, 'Yes');
insert into Response_Option values (2, 1, 'No');
insert into Response_Option values (3, 2, 'Strongly Agree');
insert into Response_Option values (4, 2, 'Somewhat Agree');
insert into Response_Option values (5, 2, 'Neutral');
insert into Response_Option values (6, 2, 'Somewhat Disgree');
insert into Response_Option values (7, 2, 'Strongly Disagree');
insert into Response_Option values (8, 3, 'Excellent');
insert into Response_Option values (9, 3, 'Good');
insert into Response_Option values (10, 3, 'Average');
insert into Response_Option values (11, 3, 'Poor');
insert into Response_Option values (12, 3, 'Very Poor');
insert into Response_Option values (13, 4, 'Enter your Response:');
insert into Response_Option values (14, 5, '1');
insert into Response_Option values (15, 5, '2');
insert into Response_Option values (16, 5, '3');
insert into Response_Option values (17, 5, '4');
insert into Response_Option values (18, 5, '5');
insert into Response_Option values (19, 5, '6');
insert into Response_Option values (20, 6, 'True');
insert into Response_Option values (21, 6, 'False');

--Stores the responses given to the surveys
create table Response (
    response_id         NUMBER(6) PRIMARY KEY,
    survey_id           NUMBER(6) NOT NULL REFERENCES Survey(survey_id),
    question_id         NUMBER(8) NOT NULL REFERENCES Question(question_id),
    response_option_id  NUMBER(4) NOT NULL REFERENCES Response_Option(response_option_id),
    user_id             NUMBER(6) NOT NULL REFERENCES Users(user_id),
    --This field is used to store text box responses for the single text box 
    --response option
    response_text       VARCHAR(100)
);

--responses to question 1 (qid 1) for Survey 1
insert into Response values (1, 1, 1, 13, 3,'Zuccnni');
insert into Response values (2, 1, 1, 13, 7, 'Pizza');

--responses to question 2 (qid 2) for Survey 1
insert into Response values (3, 1, 2, 3, 4, NULL);
insert into Response values (4, 1, 2, 4, 7, NULL);

--responses to question 1 (qid 3) for Survey 3
insert into Response values (5, 3, 3, 20, 1, NULL);
insert into Response values (6, 3, 3, 21, 2, NULL);
insert into Response values (7, 3, 3, 21, 3, NULL);
insert into Response values (8, 3, 3, 20, 4, NULL);
insert into Response values (9, 3, 3, 20, 5, NULL);
insert into Response values (10, 3, 3, 20, 7, NULL);
insert into Response values (11, 3, 3, 20, 8, NULL);
--Responses to question 2 (qid 4) for Survey 3
insert into Response values (12, 3, 4, 21, 1, NULL);
insert into Response values (13, 3, 4, 20, 2, NULL);
insert into Response values (14, 3, 4, 20, 3, NULL);
insert into Response values (15, 3, 4, 20, 4, NULL);
insert into Response values (16, 3, 4, 21, 5, NULL);
insert into Response values (17, 3, 4, 20, 7, NULL);
insert into Response values (18, 3, 4, 20, 8, NULL);
--Response to question 3(qid 5) from survey 3
insert into Response values (19, 3, 5, 20, 1, NULL);
insert into Response values (20, 3, 5, 21, 2, NULL);
insert into Response values (21, 3, 5, 21, 3, NULL);
insert into Response values (22, 3, 5, 21, 4, NULL);
insert into Response values (23, 3, 5, 21, 5, NULL);
insert into Response values (24, 3, 5, 20, 7, NULL);
insert into Response values (25, 3, 5, 20, 8, NULL);
--Response to question 3 (qid 8) from survey 1

insert into Response values (26, 1, 8, 11, 6, NULL);

--Responses to question 4 (qid 6)  from  Survey 3
insert into Response values (27, 3, 6, 20, 1, NULL);
insert into Response values (28, 3, 6, 20, 2, NULL);
insert into Response values (29, 3, 6, 20, 3, NULL);
insert into Response values (30, 3, 6, 20, 4, NULL);
insert into Response values (31, 3, 6, 21, 5, NULL);
insert into Response values (32, 3, 6, 20, 7, NULL);
insert into Response values (33, 3, 6, 20, 8, NULL);

--More responses to question 2 (qid 2) for survey 1
insert into Response values (34, 1, 2, 3, 1, NULL);
insert into Response values (35, 1, 2, 5, 2, NULL);
insert into Response values (36, 1, 2, 4, 3, NULL);
insert into Response values (37, 1, 2, 4, 5, NULL);
insert into Response values (38, 1, 2, 4, 6, NULL);
insert into Response values (39, 1, 2, 7, 8, NULL);

--Responses to question 5 (qid 7) from Survey 3
insert into Response values (40, 3, 7, 21, 1, NULL);
insert into Response values (41, 3, 7, 20, 2, NULL);
insert into Response values (42, 3, 7, 20, 3, NULL);
insert into Response values (43, 3, 7, 21, 4, NULL);
insert into Response values (44, 3, 7, 21, 5, NULL);
insert into Response values (45, 3, 7, 20, 7, NULL);
insert into Response values (46, 3, 7, 20, 8, NULL);


--set termout on
--set feedback on
prompt Querying the number of true responses for Question 5, in Survey 3. Press enter......

SELECT question_id, survey_id, response_option_id, COUNT(response_option_ID) AS TrueCount
FROM response
GROUP BY question_id, survey_id, response_option_id 
HAVING question_id = 5 AND survey_id = 3 AND response_option_id = 20;
