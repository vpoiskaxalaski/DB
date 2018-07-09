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
               values(floor(20000*RAND()), REPLICATE('строка', 10));
  if(@i % 100=0)
	print @i;     
  set @i=@i+1;
  end;

  go
SELECT * from #EXPLRE where TIND between 1500 and 2000 order by TIND 

--Оператор CHECKPOINT языка T-SQL позволяет записать образы страниц из буферного кэша в файлы БД.
-- Сразу после выполнения этого оператора все образы страниц, расположенные в буферном кэше сервера,
-- и соответствующие им оригинальные страницы в файлах БД совпадают.
checkpoint;
--Сразу после выполнения этого оператора буферный кэш не содержит никаких образов страниц,
-- и поэтому следующая DML-операция приведет в физическому чтению страниц из файлов БД.
 DBCC DROPCLEANBUFFERS;  

CREATE clustered index #EXPLRE_CL on #EXPLRE(TIND asc) -- уменьшает стоимость

use tempdb
exec SP_HELPINDEX #EXPLRE

use SAV_UNIVER
DROP table #EXPLRE

--3
CREATE table #EX
  ( TKEY int, CC int identity(1,1),TF varchar(100));

set nocount on;           
  DECLARE @i int = 0;
  while   @i < 20000       -- добавление в таблицу 20000 строк
  begin
  INSERT #EX(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 10));
  set @i = @i+1; 
  end;
  go

  SELECT count(*)[количество строк] from #EX;
  SELECT * from #EX

CREATE index #EX_NONCLU on #EX(TKEY, CC)
DROP index  #EX.#EX_NONCLU  

SELECT * from #EX where TKEY > 1500 and CC < 4500;  
SELECT * from #EX order by TKEY, CC

SELECT * from #EX where TKEY = 556 and CC > 3 --если зафиксировать,то индексир поиск

--4
--Индекс покрытия запроса позволяет включить в состав индексной строки значения 
--одного или нескольких неиндексируемых столбцов. 
CREATE index #EX_TKEY_X on #EX(TKEY) INCLUDE (CC)  -- значение столбца СС включается в индекс EX_TKEY_X

SELECT CC from #EX where TKEY>15000 -- время выполнения увеличилось
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
-- получение информации о степени фрагментации индекса
use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)] 
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), 
  OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
  JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id 
  where name is not null;

-- изначально фрагментация 0%

-- уровень фрагментации превысит 98%
INSERT top(10000) #EX(TKEY, TF) select TKEY, TF from #EX;

-- два способа убрать фрагментацию
-- реорганизация выполняется быстро, но после нее фрагментация будет убрана только на самом нижнем уровне
ALTER index #EX_TKEY on #EX reorganize; -- стала 25%
-- перестройка затрагивает все узлы дерева, поэтому  после ее выполнения степень фрагментации равна нулю
ALTER index #EX_TKEY on #EX rebuild with (online = off); -- стала 1.5%

drop index #EX_TKEY on #EX

--7
--уровнем фрагментации можно в некоторой степени управлять, если при создании или 
--изменении индекса использовать параметры FILLFACTOR и PAD_INDEX. Параметр FILLFACTOR 
--указывает процент заполнения индексных страниц нижнего уровня.
CREATE index #EX_TKEY1 on #EX(TKEY)with (fillfactor = 65);
--сначала фрагментация 1%
INSERT top(50)percent into #EX(TKEY, TF) select TKEY, TF  from #EX; -- стала 8.4%
use tempdb
SELECT name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
FROM sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'), OBJECT_ID(N'#EX'), NULL, NULL, NULL) ss
       JOIN sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id  
       where name is not null;

--8
CREATE table #EX2 (TKEY int, CC int identity(1,1),TF varchar(100));
set nocount on;           
declare @i int = 0;
while   @i < 10000
begin
  INSERT #EX2(TKEY, TF) values(floor(30000*RAND()), replicate('строка ', 3));
  set @i = @i+1; 
end;
select * from #EX2
  
  -- осуществляется построчно с регистрацией каждой операции удаления в журнале транзакции.
delete from #EX2; -- стоимость - 0.43
  -- удаляет все строки одномоментно, а в журнале регистрируется только одна операция. 
truncate table #EX2; -- стоимость - 0

drop table #EX2

--9 СТОИМОСТЬ ВЫПОЛНЕНИЯ ЗАПРОСА К ПРЕДСТАВЛЕНИЮ

use SAV_UNIVER

go
CREATE VIEW [Количество кафедр] as select FACULTY.FACULTY_NAME [Факультет], count(*) [Количество]
from dbo.FACULTY join dbo.PULPIT
on FACULTY.FACULTY = PULPIT.FACULTY
group by FACULTY.FACULTY_NAME;
go
select * from [Количество кафедр]
drop view [Количество кафедр]