use SAV_UNIVER


--1-- ����� ������� ����������
-- ���������� ����������, ���� ����������� ���� �� ��������� ����������: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- ������� ���������� ������������ �� ��� ���, ���� �� ����� �������� COMMIT ��� ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
drop table TAB;          
 
declare @c int, @flag char = 'r';
SET IMPLICIT_TRANSACTIONS ON 
	create table TAB(K int );                       
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print '���������� ����� � ������� TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  
		else rollback;          
SET IMPLICIT_TRANSACTIONS OFF   
if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print '������� TAB ����';  
else print '������� TAB ���'

--2-- �������� ����������� ����� ����������
-- BEGIN TRANSACTION -> COMMIT TRAN ��� ROLLBACK TRAN
-- ����� ���������� ����� ���������� ���������� ������� � �������� ����� (������������ ��� ������� ����������)
-- ����������� ����������: ������� ���������� �� ����� ������������� � �� ��������: ��������� ��������� ��, 
-- ���������� � ����������, ���� ���������� ���, ���� �� ���������� �� ����. � �� ��� �������� ����������� 
-- � ������� ��������� ������, ������������ �������� �����������, �� ����������������� ��������� ��
begin try        
	begin tran                 -- ������  ����� ����������
		insert FACULTY values ('��', '��������� ������ ����');
	    insert FACULTY values ('���', '��������� print-���������� � �����������������');
	commit tran;               -- �������� ����������
end try
begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then '������������ '
		else '����������� ������: '+  error_message()  
	end;
	if @@trancount > 0 rollback tran; -- ���� �������� ������ ����, �� ���������� �� ��������� 	  
end catch;

select * from FACULTY;
delete from FACULTY where FACULTY.FACULTY = '���'



--3-- �������� SAVETRAN
-- ���� ���������� ������� �� ���������� ����������� ������ ���������� T-SQL, �� ����� ���� ����������� 
-- �������� SAVE TRANSACTION, ����������� ����������� ����� ����������
declare @point varchar(32); 
begin try
	begin tran                            
		set @point = 'p1'; 
		save tran @point;  -- ����������� ����� p1

		insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) values
							  (20,'���������', '1997-08-02', NULL, NULL),
							  (20,'����������', '1997-08-06', NULL, NULL),
							  (20,'���������', '1997-08-01', NULL, NULL),
							  (20,'�����', '1997-08-03', NULL, NULL);    

		set @point = 'p2'; 
		save tran @point; -- ����������� ����� p2 (������������, ������� ��-�������)
		insert STUDENT(IDSTUDENT, IDGROUPS, NAME, BDAY, INFO, FOTO) values (1007,20, '������ �������', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try
begin catch
	print '������: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then '������������ ��������' 
		else '����������� ������: '+ error_message()  
	end; 
  --  if @@trancount > 0 
	begin
	   print '����������� �����: '+ @point;
	   rollback tran @point; -- ����� � ��������� ����������� �����
	   commit tran; -- �������� ���������, ����������� �� ����������� ����� 
	end;     
end catch;

select * from STUDENT where IDGROUPS=20; 
delete STUDENT where IDGROUPS=20; 



--4. ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� READ UNCOMMITED, 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED (�� ���������). 
--�������� A ������ ���������������, ��� ������� READ UNCOMMITED ��������� ����������������, 
--��������������� � ��������� ������. 


------A----------
use SAV_UNIVER
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1----------
select @@SPID, 'insert FACULTY' '���������', *
from FACULTY WHERE FACULTY = '��K';
select @@SPID, 'update PULPIT' '���������', *
from PULPIT WHERE FACULTY = '��K';
commit;
-----t2----------
-----B-----------
use SAV_UNIVER
begin transaction
select @@SPID
insert FACULTY VALUES ('��K','�������������� ����������');
update PULPIT set FACULTY = '��K' WHERE PULPIT = '����'
-----t1----------
-----t2----------
ROLLBACK;




--5. ����������� ��� �����-���: A � B  
--�������� A ������������ ����� ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--�������� A ������ ���������������, ��� ������� READ COMMITED �� ��������� ����������������� ������, 
--�� ��� ���� ��������  ��������������� � ��������� ������. 

-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = '��';
-----t1-------
-----t2-------
select 'update PULPIT' '���������', count(*)
from PULPIT where FACULTY = '��';
commit;
------B----
begin transaction
------t1-----
update PULPIT set FACULTY = '��' where PULPIT = '������';
commit;

------t2------

--6. ����������� ��� �����-���: A � B 
--�������� A ������������ ����� ����� ���������� � ������� ��������������� REPEATABLE READ. 
--���-����� B � ����� ���������� � ������� ��������������� READ COMMITED. 
--------A---------
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = '������';
--------t1---------
--------t2---------
select case
    when TEACHER = '���' THEN 'insert TEACHER'
	else ' '
	end '���������', TEACHER
FROM TEACHER WHERE PULPIT = '������';
commit;
--- B ---	
begin transaction 	  
--- t1 --------------------
insert TEACHER values ('���', '������ ���� ��������', '�', '������');
commit; 
--- t2 --------------------

select * from TEACHER 
delete  from TEACHER where TEACHER = '���'

--7. ����������� ��� �����-���: A � B  
-- ����� ���������� � ������� ��������������� SNAPSHOT. 
   use master;
	alter database SAV_UNIVER set allow_snapshot_isolation on
	-- A ---
	use SAV_UNIVER
    set transaction isolation level SNAPSHOT 
	begin transaction 
	select TEACHER from TEACHER where PULPIT = '������';	
	-------------------------- t1 ------------------ 	
      --    delete TEACHER where TEACHER = '���';  
         insert TEACHER values ('���', '������ ������ ���������', '�', '������');
          update TEACHER set TEACHER = '���' where TEACHER = '����';
		  waitfor delay '00:00:10'
	-------------------------- t2 -----------------
	select TEACHER from TEACHER  where PULPIT = '������';
	commit; 	
	--- B ---
	begin transaction 	  
	-------------------------- t1 --------------------
		--  delete TEACHER where TEACHER = '���1';  
          insert TEACHER values ('���', '������ ���� ��������', '�', '������');
          update TEACHER set TEACHER = '����' where TEACHER = '���';
          commit; 
	-------------------------- t2 --------------------


--8. ����������� ��� �����-���: A � B �� ������� ���� ������ X_BSTU. 
-- ���������� � ������� ��������������� SERIALIZABLE. 

use SAV_UNIVER
      -- A ---
          set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = '���';  
       --   insert TEACHER values ('���a�', '������a� ������ ���������', '�', '��');
          update TEACHER set TEACHER = '�����' where TEACHER = '���';
          select TEACHER from TEACHER  where PULPIT = '��';
	-------------------------- t1 -----------------
	begin tran
	 select TEACHER from TEACHER  where PULPIT = '��';
	-------------------------- t2 ------------------ 
	commit; 	
	--- B ---	
	begin transaction 	  
	delete TEACHER where TEACHER = '���';  
          update TEACHER set TEACHER = '����' where TEACHER = '������'   
          select TEACHER from TEACHER  where PULPIT = '��';
          -------------------------- t1 --------------------
          commit; 
           select TEACHER from TEACHER  where PULPIT = '��';
      -------------------------- t2 --------------------

--9-- ��������� ����������
-- ����������, ������������� � ������ ������ ����������, ���������� ���������. 
-- �������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
-- �������� ROLLBACK ������� ���������� �������� ��������������� �������� ���������� ����������; 
-- �������� ROLLBACK ��������� ���������� ��������� �� ���-����� ������� � ���������� ����������, 
-- � ����� ��������� ��� ����������; 
-- ������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT. 

use SAV_UNIVER
begin tran
	insert FACULTY values ('��!', '�������������� ����������')
	begin tran
		update FACULTY set FACULTY_NAME = '����' where FACULTY.FACULTY='��'
	commit
if(@@TRANCOUNT > 0)
	rollback
else
commit

delete FACULTY where FACULTY.FACULTY='��!'
select * from FACULTY 



use Sav_MyBase

--1
begin transaction
    update ORDERS
	   set ORDERS.id = 1
	   where ORDERS.id= 5690

	if (@@ERROR <> 0)
	    rollback

	update GOODS
	    set ���� = 45
		where ���� = 7

	if (@@ERROR <> 0)
	rollback
commit

select * from GOODS
select * from ORDERS

--2
begin transaction
    insert into  GOODS
	    values ('������', '��������', 89, 400);
	save transaction a;

	    insert into  GOODS
	    values ('������', '22,5 ��', 12, 40);
	save transaction b;

	rollback transaction a;

commit transaction;

select * from GOODS

--3
use  Sav_MyBase
BEGIN TRAN
INSERT ORDERS
VALUES (6895, '������', '����������', '2018.06.15', 4)
   BEGIN TRAN 
   INSERT ORDERS
VALUES (5689, '�������', '�������� �104', '2018.07.15', 7)
   BEGIN TRAN 
	 INSERT ORDERS
	VALUES (6898, '����', '�����', '2018.06.25', 4)
commit
--ROLLBACK TRAN

delete ORDERS where ORDERS.id = 6895 or ORDERS.id = 6896 or ORDERS.id = 6898

SELECT * FROM ORDERS