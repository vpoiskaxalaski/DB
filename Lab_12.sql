use SAV_UNIVER

--1

DECLARE Subs CURSOR for SELECT SUBJECTS.SUBJECTS from SUBJECTS where SUBJECTS.PULPIT='ИСиТ'; 

DECLARE @sub char(4), @str char(100)=' '; 
OPEN Subs;  
	fetch  Subs into @sub; -- считывает строку из рез. набора и продвигает указатель на след. строку.   
	print   'Дисциплины на кафедре ИСиТ:';   
	while @@fetch_status = 0 -- считывание вып. успешно (1 если конец набора, 2 если строки не существует)                                    
    begin 
		set @str = rtrim(@sub)+', '+@str; -- удаляет все завершающие пробелы        
         fetch  Subs into @sub; 
    end;   
    print @str;        
CLOSE  Subs;

deallocate Subs; 


--2 локальный от глобального

DECLARE Puls CURSOR LOCAL for SELECT PULPIT, FACULTY from PULPIT;

DECLARE @pul nvarchar(10), @fac nvarchar(4);      
OPEN Puls; 	  
	fetch  Puls into @pul, @fac; 	
    print rtrim(@pul)+' на факультете  '+ @fac; 
go
DECLARE @pul nvarchar(10), @fac nvarchar(4); 
	fetch  Puls into @pul, @fac; 	
	print rtrim(@pul)+' на факультете  '+ @fac;   
go
DECLARE Puls CURSOR GLOBAL for SELECT PULPIT, FACULTY from PULPIT;

DECLARE @pul1 nvarchar(10), @fac1 nvarchar(4);      
OPEN Puls;	  
	fetch  Puls into @pul1, @fac1; 	
    print rtrim(@pul1)+' на факультете  '+ @fac1; 
go
	DECLARE @pul2 nvarchar(10), @fac2 nvarchar(4);       	
	fetch  Puls into @pul2, @fac2; 	
    print rtrim(@pul2)+' на факультете  '+ @fac2;   
CLOSE Puls;

deallocate Puls;
 

--3 статический от глобального

DECLARE @name char(50);  
DECLARE Studs CURSOR LOCAL STATIC for SELECT NAME from STUDENT where IDGROUPS = 21;	   	
OPEN Studs;
print 'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
UPDATE STUDENT set IDGROUPS =20 where IDGROUPS=21;
delete STUDENT where IDGROUPS=20;
fetch  Studs into @name;     
while @@fetch_status = 0                                    
begin 
   print @name + ' ';      
   fetch Studs into @name; 
end;          
CLOSE  Studs;

DECLARE @name1 char(50);  
DECLARE Studs CURSOR LOCAL DYNAMIC for SELECT NAME from STUDENT where IDGROUPS = 20;	   	
OPEN Studs;
print 'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5));
insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) 
	   values (20,'Юля', '1997-08-02', NULL, NULL),
			  (20,'Александра', '1997-08-06', NULL, NULL);  
insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) 
	   values (20,'Катя', '1997-08-01', NULL, NULL),
			  (20,'Елена', '1997-08-03', NULL, NULL);
UPDATE STUDENT set IDGROUPS =21 where IDGROUPS=20;   
fetch  Studs into @name1;     
while @@fetch_status = 0                                    
begin 
   print @name1 + ' ';      
   fetch Studs into @name1; 
end;          
CLOSE  Studs;
DEALLOCATE Studs;

--4-- SCROLL, АТРИБУТЫ
DECLARE  @t int, @rn char(50);  
DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUPS = 1 
OPEN ScrollCur;
	fetch First from ScrollCur into  @t, @rn;                 
	print 'первая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from ScrollCur into  @t, @rn;                 
	print 'следующая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  ScrollCur into @t, @rn;       
	print 'последняя строка: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from ScrollCur into  @t, @rn;                 
	print 'предпоследняя строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from ScrollCur into  @t, @rn;    -- от начала             
	print 'вторая строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from ScrollCur into  @t, @rn;    -- от текущей          
	print 'третья строка: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE ScrollCur;


--5 current of
DECLARE @name2 nvarchar(20);  

-- удаляется первая строка в STUDENT, а студент из след. строки становится студентом 19 группы
DECLARE UpdateCur CURSOR LOCAL DYNAMIC for SELECT NAME from STUDENT where IDGROUPS=18 FOR UPDATE; 
OPEN UpdateCur;  
    fetch  UpdateCur into @name2;
	print @name2;  
    delete STUDENT where CURRENT OF UpdateCur;	
    fetch  UpdateCur into @name2; 
    UPDATE STUDENT set IDGROUPS=IDGROUPS+1 where CURRENT OF UpdateCur;
	print @name2;
CLOSE UpdateCur;


--6 удалить студентов,оценки которых ниже 4
DECLARE @name3 nvarchar(20), @n int;  

DECLARE Cur1 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT 
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5

OPEN Cur1;  
    fetch  Cur1 into @name3, @n;  
	while @@fetch_status = 0
	begin 		
		delete PROGRESS where CURRENT OF Cur1;	
		fetch  Cur1 into @name3, @n;  
	end
CLOSE Cur1;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where NOTE<5
insert into PROGRESS (SUBJECTS,IDSTUDENT,PDATE, NOTE)
    values 
           ('ОАиП', 1005,  '01.10.2013',4),
           ('СУБД', 1017,  '01.12.2013',4),
		   ('КГ',   1018,  '06.5.2013',4),
           ('ОХ',   1065,  '01.1.2013',4),
           ('ОХ',   1069,  '01.1.2013',4),
           ('ЭТ',   1058,  '01.1.2013',4)


-- увелиичть оценку на еденицу

DECLARE @name4 char(20), @n3 int;  

DECLARE Cur2 CURSOR LOCAL for 
SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
		where PROGRESS.IDSTUDENT=1000
OPEN Cur2;  
    fetch  Cur2 into @name4, @n3; 
    UPDATE PROGRESS set NOTE=NOTE+1 where CURRENT OF Cur2;
CLOSE Cur2;

SELECT NAME, NOTE from PROGRESS join STUDENT
	on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT 
		where PROGRESS.IDSTUDENT=1000



use Sav_MyBase

--1
DECLARE @nam nvarchar(20);  

DECLARE UpdatCur CURSOR LOCAL DYNAMIC for SELECT GOODS.наименование from GOODS where GOODS.количество_на_складе=42 FOR UPDATE; 
OPEN UpdatCur;  
    fetch  UpdatCur into @nam;
	print @nam;  
    update GOODS set цена = 5  where CURRENT OF UpdatCur;	
CLOSE UpdatCur;


--2
DECLARE @company varchar( 50),
        @adress varchar( 50),
		@message varchar(256);
DECLARE crs_clients cursor local
   for SELECT BUYER.покупатель, BUYER.адрес
    from BUYER
	  where покупатель like 'С%'
	   order by BUYER.покупатель
print 'Список заказчиков';
OPEN crs_clients;
fetch next from crs_clients
   into @company, @adress;
while @@FETCH_STATUS = 0
  begin
    SELECT @message = 'Компания ' + @company + ' ' +
	                  'адрес ' + @adress;
	print @message;

	fetch next from crs_clients
	   into @company, @adress;
   end;
CLOSE crs_clients;
deallocate crs_clients;
