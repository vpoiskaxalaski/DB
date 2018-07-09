use SAV_UNIVER

--1
exec sp_helpindex "AUDITORIUM"
exec sp_helpindex "AUDITORIUM_TYPE"
exec sp_helpindex "FACULTY"
exec sp_helpindex "GROUPS"
exec sp_helpindex "PROFESSION"
exec sp_helpindex "PROGRESS"
exec sp_helpindex "PULPIT"
exec sp_helpindex "STUDENT"
exec sp_helpindex "SUBJECTS"
exec sp_helpindex "TEACHER"

--2
CREATE table #EXPLRE
(   
 TIND int,  
 TFIELD varchar(100) 
);

set nocount on;      
DECLARE @i int=0; 
while @i<10000
  begin 
  INSERT #EXPLRE(TIND, TFIELD) 
               values(floor(20000*RAND()), REPLICATE('������', 10));
  if(@i % 100=0)
	print @i;     
  set @i=@i+1;
  end;

  go
SELECT * from #EXPLRE where TIND between 1500 and 2000 order by TIND 

--�������� CHECKPOINT ����� T-SQL ��������� �������� ������ ������� �� ��������� ���� � ����� ��.
-- ����� ����� ���������� ����� ��������� ��� ������ �������, ������������� � �������� ���� �������,
-- � ��������������� �� ������������ �������� � ������ �� ���������.
checkpoint;
--����� ����� ���������� ����� ��������� �������� ��� �� �������� ������� ������� �������,
-- � ������� ��������� DML-�������� �������� � ����������� ������ ������� �� ������ ��.
 DBCC DROPCLEANBUFFERS;  

CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc) -- ��������� ���������

use tempdb
exec SP_HELPINDEX #EXPLRE

use SAV_UNIVER
DROP table #EXPLRE

--3
CREATE table #EX
  ( TKEY int, CC int identity(1,1),TF varchar(100));

set nocount on;           
  DECLARE @i int = 0;
  while   @i < 20000       -- ���������� � ������� 20000 �����
  begin
  INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 10));
  set @i = @i+1; 
  end;
  go

  SELECT count(*)[���������� �����] from #EX;
  SELECT * from #EX

CREATE index #EX_NONCLU on #EX(TKEY, CC)
DROP index  #EX.#EX_NONCLU  

SELECT * from #EX where TKEY > 1500 and CC < 4500;  
SELECT * from #EX order by TKEY, CC

SELECT * from #EX where TKEY = 556 and CC > 3 --���� �������������,�� �������� �����

--4
--������ �������� ������� ��������� �������� � ������ ��������� ������ �������� 
--������ ��� ���������� ��������������� ��������. 
CREATE index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)  -- �������� ������� �� ���������� � ������ EX_TKEY_X

SELECT CC from #EX where TKEY>15000 -- ����� ���������� �����������
use tempdb
exec SP_HELPINDEX #EX
use SAV_UNIVER
drop index #EX_NONCLU on #EX
drop index #EX_TKEY_X on #EX

--5
SELECT TKEY from #EX where TKEY between 5000 and 19999; 
SELECT TKEY from #EX where TKEY>15000 and  TKEY < 20000;  
SELECT TKEY from #EX where TKEY=17000; 
SELECT TKEY from #EX where TKEY < 4000;

CREATE index #EX_WHERE on #EX(TKEY) where (TKEY>=15000 and TKEY < 20000);  

drop index #EX_WHERE on #EX

--6
CREATE index #EX_TKEY on #EX(TKEY); 
-- ��������� ���������� � ������� ������������ �������
use tempdb
SELECT name [������], avg_fragmentation_in_percent [������������ (%)] 
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
  OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
  JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
  where name is not null;

-- ���������� ������������ 0%

-- ������� ������������ �������� 98%
INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

-- ��� ������� ������ ������������
-- ������������� ����������� ������, �� ����� ��� ������������ ����� ������ ������ �� ����� ������ ������
ALTER index #EX_TKEY on #EX reorganize; -- ����� 25%
-- ����������� ����������� ��� ���� ������, �������  ����� �� ���������� ������� ������������ ����� ����
ALTER index #EX_TKEY on #EX rebuild with (online = off); -- ����� 1.5%

drop index #EX_TKEY on #EX

--7
--������� ������������ ����� � ��������� ������� ���������, ���� ��� �������� ��� 
--��������� ������� ������������ ��������� FILLFACTOR � PAD_INDEX. �������� FILLFACTOR 
--��������� ������� ���������� ��������� ������� ������� ������.
CREATE index #EX_TKEY1 on #EX(TKEY)with (fillfactor = 65);
--������� ������������ 1%
INSERT top(50)percent into #EX(TKEY, TF) select TKEY, TF  from #EX; -- ����� 8.4%
use tempdb
SELECT name [������], avg_fragmentation_in_percent [������������ (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
       JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
       where name is not null;

--8
CREATE table #EX2 (TKEY int, CC int identity(1,1),TF varchar(100));
set nocount on;           
declare @i int = 0;
while   @i < 10000
begin
  INSERT #EX2(TKEY, TF) values(floor(30000*RAND()), replicate('������ ', 3));
  set @i = @i+1; 
end;
select * from #EX2
  
  -- �������������� ��������� � ������������ ������ �������� �������� � ������� ����������.
delete from #EX2; -- ��������� - 0.43
  -- ������� ��� ������ ������������, � � ������� �������������� ������ ���� ��������. 
truncate table #EX2; -- ��������� - 0

drop table #EX2

--9 ��������� ���������� ������� � �������������

use SAV_UNIVER

go
CREATE VIEW [���������� ������] as select FACULTY.FACULTY_NAME [���������], count(*) [����������]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
select * from [���������� ������]
drop view [���������� ������]