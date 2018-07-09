use SAV_UNIVER;

--1)
SELECT  AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE
 From AUDITORIUM  Join AUDITORIUM_TYPE
 On  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.[AUDITORIUM_TYPE];

  --2)
  SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPE,  AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, 
   AUDITORIUM.AUDITORIUM  From  AUDITORIUM  Inner Join  AUDITORIUM_TYPE 
  On  AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE And  AUDITORIUM_TYPE.AUDITORIUM_TYPENAME  Like  '%���������%';

  --3)
  SELECT  AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE 
	  From  AUDITORIUM, AUDITORIUM_TYPE
Where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE; 

  SELECT  AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME 
	  From  AUDITORIUM, AUDITORIUM_TYPE
Where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE and AUDITORIUM_TYPE.AUDITORIUM_TYPENAME like '%���������%';  

--4)
select FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME, GROUPS.PROFESSION,
SUBJECTS.SUBJECTS_NAME, STUDENT.NAME,
case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end NOTE
from FACULTY inner join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
inner join SUBJECTS
on PULPIT.PULPIT = SUBJECTS.PULPIT
inner join GROUPS
on PULPIT.FACULTY = PULPIT.FACULTY
inner join STUDENT
on GROUPS.IDGROUPS = STUDENT.IDGROUPS
inner join PROGRESS
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
and PROGRESS.NOTE between 6 and 8
and PROGRESS.SUBJECTS = SUBJECTS.SUBJECTS
order by FACULTY.FACULTY asc,
PULPIT.PULPIT asc,
SUBJECTS.SUBJECTS_NAME asc,
STUDENT.NAME asc,
PROGRESS.NOTE desc;

--5)
select FACULTY.FACULTY_NAME, PULPIT.PULPIT_NAME, GROUPS.PROFESSION,
SUBJECTS.SUBJECTS_NAME, STUDENT.NAME,
case
when (PROGRESS.NOTE = 6) then '�����'
when (PROGRESS.NOTE = 7) then '����'
when (PROGRESS.NOTE = 8) then '������'
end NOTE
from FACULTY inner join PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
inner join SUBJECTS
on PULPIT.PULPIT = SUBJECTS.PULPIT
inner join GROUPS
on PULPIT.FACULTY = PULPIT.FACULTY
inner join STUDENT
on GROUPS.IDGROUPS = STUDENT.IDGROUPS
inner join PROGRESS
on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
and PROGRESS.NOTE between 6 and 8
and PROGRESS.SUBJECTS = SUBJECTS.SUBJECTS
ORDER BY ( Case when ( PROGRESS.NOTE = 7) then 1
				when (PROGRESS.NOTE = 8)  then 2 else 3 end);

--6)
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT;

--7)
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from TEACHER left outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT   

--8)
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from TEACHER right outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT  

--9)
--1
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT  

--2
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

--3
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from PULPIT inner join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT                                               

--10)

--1
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where PULPIT.PULPIT is not null
and TEACHER.PULPIT is null

--2
select PULPIT.PULPIT_NAME, isnull(TEACHER.TEACHER_NAME,'***')
from PULPIT full outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT
where PULPIT.PULPIT is null
and TEACHER.PULPIT is not null

--3
select PULPIT.PULPIT_NAME, TEACHER.TEACHER_NAME
from TEACHER full outer join PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT
where PULPIT.PULPIT is not null
and TEACHER.PULPIT is not null

--11)
select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM cross join AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE

