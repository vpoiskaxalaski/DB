use SAV_UNIVER


--1-- РЕЖИМ НЕЯВНОЙ ТРАНЗАКЦИИ
-- транзакция начинается, если выполняется один из следующих операторов: 
-- CREATE, DROP; ALTER TABLE; INSERT, DELETE, UPDATE, SELECT, TRUNCATE TABLE; OPEN, FETCH; GRANT; REVOKE 
-- неявная транзакция продолжается до тех пор, пока не будет выполнен COMMIT или ROLLBACK
set nocount on
if  exists (select * from  SYS.OBJECTS 
         where OBJECT_ID=object_id(N'DBO.TAB')) 
drop table TAB;          
 
declare @c int, @flag char = 'r';
SET IMPLICIT_TRANSACTIONS ON 
	create table TAB(K int );                       
	insert TAB values (1),(2),(3),(4),(5);
	set @c = (select count(*) from TAB);
	print 'количество строк в таблице TAB: ' + cast(@c as varchar(2));
	if @flag = 'c' commit  
		else rollback;          
SET IMPLICIT_TRANSACTIONS OFF   
if  exists (select * from  SYS.OBJECTS 
          where OBJECT_ID= object_id(N'DBO.TAB')) print 'таблица TAB есть';  
else print 'таблицы TAB нет'

--2-- СВОЙСТВО АТОМАРНОСТИ ЯВНОЙ ТРАНЗАКЦИИ
-- BEGIN TRANSACTION -> COMMIT TRAN или ROLLBACK TRAN
-- после завершения явной транзакции происходит возврат в исходный режим (автофиксации или неявной транзакции)
-- атомарность транзакции: никакая транзакция не будет зафиксирована в БД частично: операторы изменения БД, 
-- включенные в транзакцию, либо выполнятся все, либо не выполнится ни один. В БД это свойство реализуется 
-- с помощью механизма отката, позволяющего отменить выполненные, но незафиксированные изменения БД
begin try        
	begin tran                 -- начало  явной транзакции
		insert FACULTY values ('ДФ', 'Факультет других наук');
	    insert FACULTY values ('ПиМ', 'Факультет print-технологий и медиакоммуникаций');
	commit tran;               -- фиксация транзакции
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%FACULTY_PK%', error_message()) > 0 then 'дублирование '
		else 'неизвестная ошибка: '+  error_message()  
	end;
	if @@trancount > 0 rollback tran; -- если значение больше нуля, то транзакция не завершена 	  
end catch;

select * from FACULTY;
delete from FACULTY where FACULTY.FACULTY = 'ПиМ'



--3-- ОПЕРАТОР SAVETRAN
-- если транзакция состоит из нескольких независимых блоков операторов T-SQL, то может быть использован 
-- оператор SAVE TRANSACTION, формирующий контрольную точку транзакции
declare @point varchar(32); 
begin try
	begin tran                            
		set @point = 'p1'; 
		save tran @point;  -- контрольная точка p1

		insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) values
							  (20,'Екатерина', '1997-08-02', NULL, NULL),
							  (20,'Александра', '1997-08-06', NULL, NULL),
							  (20,'Елизавета', '1997-08-01', NULL, NULL),
							  (20,'Ольга', '1997-08-03', NULL, NULL);    

		set @point = 'p2'; 
		save tran @point; -- контрольная точка p2 (перезаписали, назвали по-другому)
		insert STUDENT(IDSTUDENT, IDGROUPS, NAME, BDAY, INFO, FOTO) values (1007,20, 'Особый студент', '1997-08-02', NULL, NULL); 
	commit tran;                                              
end try
begin catch
	print 'ошибка: '+ case 
		when error_number() = 2627 and patindex('%STUDENT_PK%', error_message()) > 0 then 'дублирование студента' 
		else 'неизвестная ошибка: '+ error_message()  
	end; 
  --  if @@trancount > 0 
	begin
	   print 'контрольная точка: '+ @point;
	   rollback tran @point; -- откат к последней контрольной точке
	   commit tran; -- фиксация изменений, выполненных до контрольной точки 
	end;     
end catch;

select * from STUDENT where IDGROUPS=20; 
delete STUDENT where IDGROUPS=20; 



--4. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ UNCOMMITED, 
--сценарий B – явную транзакцию с уровнем изолированности READ COMMITED (по умолчанию). 
--Сценарий A должен демонстрировать, что уровень READ UNCOMMITED допускает неподтвержденное, 
--неповторяющееся и фантомное чтение. 


------A----------
use SAV_UNIVER
set transaction isolation level READ UNCOMMITTED
begin transaction
-----t1----------
select @@SPID, 'insert FACULTY' 'результат', *
from FACULTY WHERE FACULTY = 'ИТK';
select @@SPID, 'update PULPIT' 'результат', *
from PULPIT WHERE FACULTY = 'ИТK';
commit;
-----t2----------
-----B-----------
use SAV_UNIVER
begin transaction
select @@SPID
insert FACULTY VALUES ('ИТK','Информационных технологий');
update PULPIT set FACULTY = 'ИТK' WHERE PULPIT = 'ИСиТ'
-----t1----------
-----t2----------
ROLLBACK;




--5. Разработать два сцена-рия: A и B  
--Сценарий A представляет собой явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--Сценарий A должен демонстрировать, что уровень READ COMMITED не допускает неподтвержденного чтения, 
--но при этом возможно  неповторяющееся и фантомное чтение. 

-----A--------
set transaction isolation level READ COMMITTED
begin transaction
select count(*) from PULPIT
where FACULTY = 'ИТ';
-----t1-------
-----t2-------
select 'update PULPIT' 'результат', count(*)
from PULPIT where FACULTY = 'ИТ';
commit;
------B----
begin transaction
------t1-----
update PULPIT set FACULTY = 'ИТ' where PULPIT = 'ПОиСОИ';
commit;

------t2------

--6. Разработать два сцена-рия: A и B 
--Сценарий A представляет собой явную транзакцию с уровнем изолированности REPEATABLE READ. 
--Сце-нарий B – явную транзакцию с уровнем изолированности READ COMMITED. 
--------A---------
set transaction isolation level REPEATABLE READ
begin transaction
select TEACHER FROM TEACHER
WHERE PULPIT = 'ПОиСОИ';
--------t1---------
--------t2---------
select case
    when TEACHER = 'ПТР' THEN 'insert TEACHER'
	else ' '
	end 'результат', TEACHER
FROM TEACHER WHERE PULPIT = 'ПОиСОИ';
commit;
--- B ---	
begin transaction 	  
--- t1 --------------------
insert TEACHER values ('ПТР', 'Иванов Иван Иванович', 'м', 'ПОиСОИ');
commit; 
--- t2 --------------------

select * from TEACHER 
delete  from TEACHER where TEACHER = 'ПТР'

--7. Разработать два сцена-рия: A и B  
-- явную транзакцию с уровнем изолированности SNAPSHOT. 
   use master;
	alter database SAV_UNIVER set allow_snapshot_isolation on
	-- A ---
	use SAV_UNIVER
    set transaction isolation level SNAPSHOT 
	begin transaction 
	select TEACHER from TEACHER where PULPIT = 'ПОиСОИ';	
	-------------------------- t1 ------------------ 	
      --    delete TEACHER where TEACHER = 'ВВВ';  
         insert TEACHER values ('ВЕН', 'Петров Сергей Борисович', 'м', 'ПОиСОИ');
          update TEACHER set TEACHER = 'ШМК' where TEACHER = 'ШМКВ';
		  waitfor delay '00:00:10'
	-------------------------- t2 -----------------
	select TEACHER from TEACHER  where PULPIT = 'ПОиСОИ';
	commit; 	
	--- B ---
	begin transaction 	  
	-------------------------- t1 --------------------
		--  delete TEACHER where TEACHER = 'ВВВ1';  
          insert TEACHER values ('ПТР', 'Петров Петр Петрович', 'м', 'ПОиСОИ');
          update TEACHER set TEACHER = 'БРТГ' where TEACHER = 'БРТ';
          commit; 
	-------------------------- t2 --------------------


--8. Разработать два сцена-рия: A и B на примере базы данных X_BSTU. 
-- транзакцию с уровнем изолированности SERIALIZABLE. 

use SAV_UNIVER
      -- A ---
          set transaction isolation level SERIALIZABLE 
	begin transaction 
		  delete TEACHER where TEACHER = 'АРС';  
       --   insert TEACHER values ('ИВНaй', 'Ивановaф Сергей Борисович', 'м', 'ЛУ');
          update TEACHER set TEACHER = 'ШМКВй' where TEACHER = 'ШМК';
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t1 -----------------
	begin tran
	 select TEACHER from TEACHER  where PULPIT = 'ЛУ';
	-------------------------- t2 ------------------ 
	commit; 	
	--- B ---	
	begin transaction 	  
	delete TEACHER where TEACHER = 'АРС';  
          update TEACHER set TEACHER = 'ШМКВ' where TEACHER = 'МШКВСК'   
          select TEACHER from TEACHER  where PULPIT = 'ЛУ';
          -------------------------- t1 --------------------
          commit; 
           select TEACHER from TEACHER  where PULPIT = 'ЛУ';
      -------------------------- t2 --------------------

--9-- ВЛОЖЕННЫЕ ТРАНЗАКЦИИ
-- Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
-- оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
-- оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внутренней транзакции; 
-- оператор ROLLBACK вложенной транзакции действует на опе-рации внешней и внутренней транзакции, 
-- а также завершает обе транзакции; 
-- уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT. 

use SAV_UNIVER
begin tran
	insert FACULTY values ('ИТ!', 'Информационных технологий')
	begin tran
		update FACULTY set FACULTY_NAME = 'пгнп' where FACULTY.FACULTY='ДФ'
	commit
if(@@TRANCOUNT > 0)
	rollback
else
commit

delete FACULTY where FACULTY.FACULTY='ИТ!'
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
	    set цена = 45
		where цена = 7

	if (@@ERROR <> 0)
	rollback
commit

select * from GOODS
select * from ORDERS

--2
begin transaction
    insert into  GOODS
	    values ('сервиз', 'столовый', 89, 400);
	save transaction a;

	    insert into  GOODS
	    values ('крышка', '22,5 см', 12, 40);
	save transaction b;

	rollback transaction a;

commit transaction;

select * from GOODS

--3
use  Sav_MyBase
BEGIN TRAN
INSERT ORDERS
VALUES (6895, 'кружка', 'Славянская', '2018.06.15', 4)
   BEGIN TRAN 
   INSERT ORDERS
VALUES (5689, 'зеркало', 'Столовая №104', '2018.07.15', 7)
   BEGIN TRAN 
	 INSERT ORDERS
	VALUES (6898, 'ваза', 'Элема', '2018.06.25', 4)
commit
--ROLLBACK TRAN

delete ORDERS where ORDERS.id = 6895 or ORDERS.id = 6896 or ORDERS.id = 6898

SELECT * FROM ORDERS