use SAV_UNIVER;

--1 ��������� ������� �������� ���������� ��������� �� ��������� ����������
go
create function COUNT_STUDENTS(@faculty nvarchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from STUDENT join GROUPS
    on STUDENT.IDGROUPS = GROUPS.IDGROUPS
	join FACULTY
	    on GROUPS.FACULTY = FACULTY.FACULTY
		    where FACULTY.FACULTY = @faculty);
return @rc;
end;
go
declare @n int = dbo.COUNT_STUDENTS('����');
print '���������� ���������: ' + cast(@n as varchar(4));

go
alter function COUNT_STUDENTS(@faculty varchar(20) = null, @prof varchar(20) = '1-40 01 02') returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(IDSTUDENT) from FACULTY inner join GROUPS
	on FACULTY.FACULTY = GROUPS.FACULTY
	inner join STUDENT
		on GROUPS.IDGROUPS = STUDENT.IDGROUPS
			where FACULTY.FACULTY = @faculty and GROUPS.PROFESSION = @prof);
return @rc;
end;


go
declare @n int = dbo.COUNT_STUDENTS('����', '1-40 01 02');
print '���������� ���������: ' + cast(@n as varchar(4));

--2. ����������� ��������� ������� � ������ FSUBJECTS, ����������� �������� � ������ @p
-- ���� VAR-CHAR(20), �������� �������� ������ ��� ������� (������� SUBJECT.PULPIT). 
go
create function FSUBJECTS(@p varchar(20)) returns varchar(300)
as begin
declare @sb varchar(10), @s varchar(100) = '';
declare sbj cursor local static
    for select distinct SUBJECTS from SUBJECTS 
	    where PULPIT like @p;
open sbj;
fetch sbj into @sb;
while @@FETCH_STATUS = 0
begin
set @s = @s + RTRIM(@sb) + ', ';
fetch sbj into @sb;
end;
return @s
end;

go 
select distinct PULPIT, dbo.FSUBJECTS(PULPIT)[����������] from SUBJECTS;


--3
go
create function FFACPUL(@f varchar(20), @p varchar(20)) returns table
as return
select FACULTY.FACULTY, PULPIT.PULPIT from FACULTY left outer join PULPIT
  on FACULTY.FACULTY = PULPIT.FACULTY
   where FACULTY.FACULTY = ISNULL(@f, FACULTY.FACULTY) and --������ ��������, �� ������ null
    PULPIT.PULPIT = ISNULL(@p, PULPIT.PULPIT);

go
select * from dbo.FFACPUL(null, null);
select * from dbo.FFACPUL('����', null);
select * from dbo.FFACPUL(null, '����');
select * from dbo.FFACPUL('����', '����');

--4. �� ������� ���� ������� ��������, ��������������� ������ ��������� ������� FCTEACHER.
-- ������� ��������� ���� ��������, �������� ��� �������. ������� ���������� ���������� ��������������
-- �� �������� ���������� �������. ���� �������� ����� NULL, �� ������������ ����� ���������� ���������-�����. 
go
create function FCTEACHER(@p varchar(20)) returns int
as begin
declare @rc int = (select count(TEACHER) from TEACHER where PULPIT = ISNULL(@p, PULPIT));
return @rc;
end;

go 
select PULPIT, dbo.FCTEACHER(PULPIT)[���������� ��������������] from TEACHER;
select dbo.FCTEACHER(null)[����� ���������� ��������������];

--6
go
create function COUNT_PULPIT(@f varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(PULPIT) from PULPIT where FACULTY = @f);
return @rc;
end;

-- DROP FUNCTION COUNT_PULPIT

go
create function COUNT_GROUP(@f varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(IDGROUPS) from GROUPS where FACULTY like @f);
return @rc;
end;


-- DROP FUNCTION COUNT_GROUP


go
create function COUNT_PROFESSION(@f varchar(20)) returns int
as begin
declare @rc int = 0;
set @rc = (select count(PROFESSION) from PROFESSION where FACULTY like @f);
return @rc;
end;


-- DROP FUNCTION COUNT_PROFESSION


go
create function FACULTY_REPORT(@c int) 
returns @fr table([���������] varchar(50), [���������� ������] int, [���������� �����]  int, [���������� ���������] int, [���������� ��������������] int)
as begin
declare cc cursor static for select FACULTY from FACULTY where dbo.COUNT_STUDENTS(FACULTY,default)> @c; 
declare @f varchar(30);
open cc;  
fetch cc into @f;
while @@fetch_status = 0
begin
insert @fr values(@f, dbo.COUNT_PULPIT(@f), dbo.COUNT_GROUP(@f), dbo.COUNT_STUDENTS(@f,default), dbo.COUNT_PROFESSION(@f)); 
fetch cc into @f;  
end;   
return; 
end;
-- DROP FUNCTION FACULTY_REPORT


go
select * from dbo.FACULTY_REPORT(0);



use Sav_MyBase

--1
go
create function COUNT_TOV(@tov int) returns int
as begin
declare @rc int = 0;
set @rc = (
SELECT count(������������) from GOODS
     where GOODS.����������_��_������ > @tov);
return @rc;
end;

go
declare @n int = dbo.COUNT_TOV(40);
print  cast(@n as varchar(4));

--2
go
create function F1(@p char(10)) returns int
as begin
declare @rc int = (select count(����������) from ORDERS where ���������� = ISNULL(@p, ����������));
return @rc;
end;

go 
select ����������, dbo.F1(����������)[���������� �������] from ORDERS;
select dbo.F1(null)[����� ���������� �������];

--3
go
create function F3() returns int
as begin
declare @b money
select @b = sum(GOODS.����) from GOODS
return @b
end;

go
declare @n int = dbo.F3();
print '������: ' + cast(@n as varchar(4));

