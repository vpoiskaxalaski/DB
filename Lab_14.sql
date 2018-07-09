use SAV_UNIVER
go

--1
CREATE procedure PSUBJECT
as begin
DECLARE @n int = (SELECT count(*) from SUBJECTS);
SELECT SUBJECTS [���], SUBJECTS_NAME [����������], PULPIT [�������] from SUBJECTS;
return @n;
end;

DECLARE @k int;
EXEC @k = PSUBJECT; -- ����� ��������� 
print '���������� ���������: ' + cast(@k as varchar(3));
go

--2
ALTER procedure PSUBJECT
 @p varchar(20),
 @c nvarchar(2) output
as begin
SELECT * from SUBJECTS where SUBJECTS = @p;
set @c = cast(@@rowcount as nvarchar(2));
end;

DECLARE @k1 int, @k2 nvarchar(2);
EXEC @k1 = PSUBJECT @p = '����', @c = @k2 output;
print '���������� ���������: ' + @k2;
go

--3
ALTER procedure PSUBJECT
 @p varchar(20)
as begin
SELECT * from SUBJECTS where SUBJECTS = @p;
end;

CREATE table #SUBJECTs
(
	���_�������� varchar(20),
	��������_�������� varchar(100),
	������� varchar(20)
);
INSERT #SUBJECTs EXEC PSUBJECT @p = '���';
INSERT #SUBJECTs EXEC PSUBJECT @p = '����';
SELECT * from #SUBJECTs;
go

drop table #SUBJECTs

--4
go
CREATE procedure PAUDITORIUM_INSERT
  @a char(20),
  @n varchar(50), 
  @c int = 0,
  @t char(10)
as begin 
begin try
INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
	values(@a, @n, @c, @t);
	--values(433-1, '��', 433-1, 100);
return 1;
end try
begin catch
print '����� ������: ' + cast(error_number() as varchar(6));
print '���������: ' + error_message();
print '�������: ' + cast(error_severity() as varchar(6));
print '�����: ' + cast(error_state() as varchar(8));
print '����� ������: ' + cast(error_line() as varchar(8));
if error_procedure() is not null   
print '��� ���������: ' + error_procedure();
return -1;
end catch;
end;

DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '110-4', @n = '��        ', @c = 30, @t = '110-4'; 
print '��� ������: ' + cast(@rc as varchar(3));
go
delete AUDITORIUM where AUDITORIUM='110-4';
drop procedure PAUDITORIUM_INSERT

--5
go
CREATE procedure SUBJECT_REPORT
	@p char(10) 
as begin
DECLARE @rc int = 0;
begin try
DECLARE @sb char(10), @r varchar(100) = '';
DECLARE sbj CURSOR for 
	SELECT SUBJECTS from SUBJECTS where PULPIT = @p;
if not exists(SELECT SUBJECTS from SUBJECTS where PULPIT = @p)
	raiserror('������', 11, 1);
else 
OPEN sbj;
fetch sbj into @sb;
print '��������: ';
while @@fetch_status = 0
begin
set @r = rtrim(@sb) + ', ' + @r;  
set @rc = @rc + 1;
fetch sbj into @sb;
end
print @r;
CLOSE sbj;
return @rc;
end try
begin catch
print '������ � ����������' 
if error_procedure() is not null   
print '��� ���������: ' + error_procedure();
return @rc;
end catch;
end;


DECLARE @k2 int;  
EXEC @k2 = SUBJECT_REPORT @p ='����';  
print '���������� ���������: ' + cast(@k2 as varchar(3));
go

drop procedure SUBJECT_REPORT

--6
go
CREATE procedure PAUDITORIUM_INSERTX
 @a char(20),
  @n varchar(50),
   @c int = 0,
    @t char(10),
	 @tn varchar(50)
as begin
DECLARE @rc int = 1;
begin try
set transaction isolation level serializable;          
begin tran
INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
	values(@n, @tn);
EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
commit tran;
return @rc;
end try
begin catch
print '����� ������: ' + cast(error_number() as varchar(6));
print '���������: ' + error_message();
print '�������: ' + cast(error_severity() as varchar(6));
print '�����: ' + cast(error_state() as varchar(8));
print '����� ������: ' + cast(error_line() as varchar(8));
if error_procedure() is not  null   
print '��� ���������: ' + error_procedure(); 
if @@trancount > 0 rollback tran ; 
return -1;
end catch;
end;


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '632-3', @n = '��', @c = 85, @t = '632-3', @tn = '���.'; 
print '��� ������: ' + cast(@k3 as varchar(3));

delete AUDITORIUM where AUDITORIUM='623-3';  
go


use Sav_MyBase

--1
go
CREATE PROC my_proc1
  @t char(10),
  @p int
AS
UPDATE GOODS SET ����������_��_������ = @p
  WHERE ������������=@t

EXEC my_proc1 @t='����', @p=45

--2
go
CREATE PROC my_proc2
  @s MONEY OUTPUT
AS
SELECT @s=Sum(GOODS.����*ORDERS.����������_������)
  FROM GOODS INNER JOIN ORDERS
  ON GOODS.������������=ORDERS.������������
  where ORDERS.���������� = '�����'

DECLARE @st MONEY
EXEC my_proc2 @st OUTPUT
SELECT @st


--3
go
CREATE procedure my_proc3
as begin
DECLARE @n int = (SELECT count(*) from GOODS);
SELECT  ������������[�����], �������� [��������] from GOODS;
return @n;
end;

DECLARE @k int;
EXEC @k = my_proc3; -- ����� ��������� 
print '���������� ���������: ' + cast(@k as varchar(3));
go