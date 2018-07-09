use SAV_UNIVER

--1

DECLARE Subs CURSOR for SELECT SUBJECTS.SUBJECTS from SUBJECTS where SUBJECTS.PULPIT='����'; 

DECLARE @sub char(4), @str char(100)=' '; 
OPEN Subs;  
	fetch  Subs into @sub; -- ��������� ������ �� ���. ������ � ���������� ��������� �� ����. ������.   
	print   '���������� �� ������� ����:';   
	while @@fetch_status = 0 -- ���������� ���. ������� (1 ���� ����� ������, 2 ���� ������ �� ����������)                                    
    begin 
		set @str = rtrim(@sub)+', '+@str; -- ������� ��� ����������� �������        
         fetch  Subs into @sub; 
    end;   
    print @str;        
CLOSE  Subs;

deallocate Subs; 


--2 ��������� �� �����������

DECLARE Puls CURSOR LOCAL for SELECT PULPIT, FACULTY from PULPIT;

DECLARE @pul nvarchar(10), @fac nvarchar(4);      
OPEN Puls; 	  
	fetch  Puls into @pul, @fac; 	
    print rtrim(@pul)+' �� ����������  '+ @fac; 
go
DECLARE @pul nvarchar(10), @fac nvarchar(4); 
	fetch  Puls into @pul, @fac; 	
	print rtrim(@pul)+' �� ����������  '+ @fac;   
go
DECLARE Puls CURSOR GLOBAL for SELECT PULPIT, FACULTY from PULPIT;

DECLARE @pul1 nvarchar(10), @fac1 nvarchar(4);      
OPEN Puls;	  
	fetch  Puls into @pul1, @fac1; 	
    print rtrim(@pul1)+' �� ����������  '+ @fac1; 
go
	DECLARE @pul2 nvarchar(10), @fac2 nvarchar(4);       	
	fetch  Puls into @pul2, @fac2; 	
    print rtrim(@pul2)+' �� ����������  '+ @fac2;   
CLOSE Puls;

deallocate Puls;
 

--3 ����������� �� �����������

DECLARE @name char(50);  
DECLARE Studs CURSOR LOCAL STATIC for SELECT NAME from STUDENT where IDGROUPS = 21;	   	
OPEN Studs;
print '���������� ����� : '+cast(@@CURSOR_ROWS as varchar(5)); 
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
print '���������� ����� : '+cast(@@CURSOR_ROWS as varchar(5));
insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) 
	   values (20,'���', '1997-08-02', NULL, NULL),
			  (20,'����������', '1997-08-06', NULL, NULL);  
insert STUDENT(IDGROUPS, NAME, BDAY, INFO, FOTO) 
	   values (20,'����', '1997-08-01', NULL, NULL),
			  (20,'�����', '1997-08-03', NULL, NULL);
UPDATE STUDENT set IDGROUPS =21 where IDGROUPS=20;   
fetch  Studs into @name1;     
while @@fetch_status = 0                                    
begin 
   print @name1 + ' ';      
   fetch Studs into @name1; 
end;          
CLOSE  Studs;
DEALLOCATE Studs;

--4-- SCROLL, ��������
DECLARE  @t int, @rn char(50);  
DECLARE ScrollCur CURSOR LOCAL DYNAMIC SCROLL for 
		SELECT row_number() over (order by NAME), NAME from STUDENT where IDGROUPS = 1 
OPEN ScrollCur;
	fetch First from ScrollCur into  @t, @rn;                 
	print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);
	fetch NEXT from ScrollCur into  @t, @rn;                 
	print '��������� ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);      
	fetch LAST from  ScrollCur into @t, @rn;       
	print '��������� ������: ' +  cast(@t as varchar(3))+ ' '+rtrim(@rn);   
	fetch PRIOR from ScrollCur into  @t, @rn;                 
	print '������������� ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch ABSOLUTE 2 from ScrollCur into  @t, @rn;    -- �� ������             
	print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn); 
	fetch RELATIVE 1 from ScrollCur into  @t, @rn;    -- �� �������          
	print '������ ������: ' + cast(@t as varchar(3))+ ' ' + rtrim(@rn);         
CLOSE ScrollCur;


--5 current of
DECLARE @name2 nvarchar(20);  

-- ��������� ������ ������ � STUDENT, � ������� �� ����. ������ ���������� ��������� 19 ������
DECLARE UpdateCur CURSOR LOCAL DYNAMIC for SELECT NAME from STUDENT where IDGROUPS=18 FOR UPDATE; 
OPEN UpdateCur;  
    fetch  UpdateCur into @name2;
	print @name2;  
    delete STUDENT where CURRENT OF UpdateCur;	
    fetch  UpdateCur into @name2; 
    UPDATE STUDENT set IDGROUPS=IDGROUPS+1 where CURRENT OF UpdateCur;
	print @name2;
CLOSE UpdateCur;


--6 ������� ���������,������ ������� ���� 4
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
           ('����', 1005,  '01.10.2013',4),
           ('����', 1017,  '01.12.2013',4),
		   ('��',   1018,  '06.5.2013',4),
           ('��',   1065,  '01.1.2013',4),
           ('��',   1069,  '01.1.2013',4),
           ('��',   1058,  '01.1.2013',4)


-- ��������� ������ �� �������

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

DECLARE UpdatCur CURSOR LOCAL DYNAMIC for SELECT GOODS.������������ from GOODS where GOODS.����������_��_������=42 FOR UPDATE; 
OPEN UpdatCur;  
    fetch  UpdatCur into @nam;
	print @nam;  
    update GOODS set ���� = 5  where CURRENT OF UpdatCur;	
CLOSE UpdatCur;


--2
DECLARE @company varchar( 50),
        @adress varchar( 50),
		@message varchar(256);
DECLARE crs_clients cursor local
   for SELECT BUYER.����������, BUYER.�����
    from BUYER
	  where ���������� like '�%'
	   order by BUYER.����������
print '������ ����������';
OPEN crs_clients;
fetch next from crs_clients
   into @company, @adress;
while @@FETCH_STATUS = 0
  begin
    SELECT @message = '�������� ' + @company + ' ' +
	                  '����� ' + @adress;
	print @message;

	fetch next from crs_clients
	   into @company, @adress;
   end;
CLOSE crs_clients;
deallocate crs_clients;
