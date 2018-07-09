 --1
DECLARE		@a  char = 'a',
            @b varchar(4) = '����',
            @c datetime,
			@d time,
			@e int,
			@f smallint,
			@w tinyint,
			@q numeric(12,5);    
			
set @c = getdate();  
set @d = sysdatetime();
use Sav_MyBase
set @e = (SELECT SUM(GOODS.����������_��_������) FROM GOODS);
set @f = (select max(ORDERS.����������_������) from ORDERS);
set @w = (select min(GOODS.����) from GOODS);

PRINT 'int: ' + STR(@e);
PRINT 'smalint: ' + STR(@f);
PRINT 'tinyint: ' + STR(@w);
PRINT 'nimeric: ' + STR(@q);

select @a as a,
	   @b as b,
	   @c as c,
	   @d as d


--2
use SAV_UNIVER

select * from AUDITORIUM

DECLARE @com_capacity int= (select sum(AUDITORIUM.AUDITORIUM_CAPACITY) from AUDITORIUM),
		@count int,
		@avr_capacity real,
		@count_small int,
		@percent float(4)
If @com_capacity>200
begin
SELECT @count = (select count(*) from AUDITORIUM),
       @avr_capacity = (select cast(AVG(AUDITORIUM.AUDITORIUM_CAPACITY ) as numeric(8,3)) from AUDITORIUM)                                                                               
SET @count_small = (select COUNT(*) from AUDITORIUM where AUDITORIUM.AUDITORIUM_CAPACITY < @avr_capacity)
SET @percent = cast (@count_small as float(4)) / CAST( @count as float(4))*100
                                                                                 
SELECT @com_capacity   '����� �����������',  @count   '����������',  @avr_capacity   '������� �����������',
 @count_small   '���������� ��������� ������ �������', @percent   '%'
End
else print cast(@com_capacity as char(10))

--3
print '����� ������������ �����: '+ str(@@rowcount); 
print '������ SQL Server: '+ cast (@@VERSION as char(30) ); 
print '��������� ������������� ��������, ����������� �������� �������� ���-��������'+ str(@@SPID );
print '��� ��������� ������: '+ str(@@ERROR  );
print '��� SQL Server: '+ cast(@@SERVERNAME as char(30));
print '������� ����������� ����������: '+ str(@@TRANCOUNT  );
print '�������� ���������� ���������� ����� ��������������� ������: '+ str(@@FETCH_STATUS  );
print '������� ����������� ������� �����-����: '+ str(@@NESTLEVEL  );

--4
declare @z real,
		@t real = 0.8,
		@x real =6.0;
begin
if(@t > @x) set @z =  power(sin(@t),2)
if(@t < @x) set @z =  4*(@t+@x)
if(@t = @x) set @z = 1- exp(@x-2) 
end

declare @str nvarchar(30) = '������ ���� M���������';
set @str = replace(@str,  '����', '�.')
set @str= replace(@str,  'M���������', '�.')
print @str

use SAV_UNIVER
declare @stud table 
				( IDSTUDENT int primary key not null,
				  STUD_NAME nvarchar(100) null,
				  BDAY date null,
				  AGE int null
				);

insert @stud select STUDENT.IDSTUDENT, STUDENT.[NAME], STUDENT.BDAY, 
			datediff(yy,
			cast(BDAY as date),
			getdate()			
			)
			from STUDENT
			  where month(cast(STUDENT.BDAY as date)) = '5'
select * from @stud

use SAV_UNIVER
declare @day int;
declare  @exam table 
				( SUBJECT_NAME char(10) not null,
				  PDATE date null
				);

insert @exam select PROGRESS.SUBJECTS, PROGRESS.PDATE
			from PROGRESS
			group by PROGRESS.SUBJECTS, PROGRESS.PDATE
			having PROGRESS.SUBJECTS  = '����'

set @day = (select day(PDATE) from @exam);

print '���� ����� �������� �� ����: ' + str(@day)


--5
declare @r int  = (select count(*)  from STUDENT);
if(@r > 30) print '������� ������ ���������'
else print '�������!'

--6
use SAV_UNIVER

select  *
from 
(select
case PROGRESS.NOTE
when 10 then '�����������'
when 9 then '�������'
when 8 then '������'
else '����� ���� � �����'
end  [��������� ������], count (*) [����������]
from PROGRESS
group by
case PROGRESS.NOTE
when 10 then '�����������'
when 9 then '�������'
when 8 then '������'
else '����� ���� � �����'
end) t
order by 
case [��������� ������]
when '�����������' THEN 0
WHEN '�������' then 1
when '������' then 2
else 3
end


--7
CREATE table  #TEMP_TABLE1
 (   TIND int,  
	 TFOOD varchar(50),
	 TCOUNT int );

DECLARE @i int=0; 
WHILE @i<10
  begin 
  INSERT #TEMP_TABLE1(TIND, TFOOD, TCOUNT) 
              values(@i, '������� �'+cast(@i as varchar) , floor(300*rand()))
  SET @i=@i+1;
  end

  select * from #TEMP_TABLE1

  --8
  DECLARE @y int = 0
     print @y+1
     print @y+2 
     RETURN
         print @y+3

--9
use SAV_UNIVER

begin try
delete PULPIT where PULPIT.PULPIT = '����'; -- ��������� FK
end try
begin catch
	print  '����� ������: ' + convert(varchar, error_number());
	print  '��������� :  ' + error_message() ;
	print  '������ : ' +convert(char,error_line());
	if ERROR_PROCEDURE() is not null
		print '��� ��������� : ' +  error_procedure();
	else 
		print 'null';
	print '������� ����������� ������ : ' + convert(char, ERROR_SEVERITY());
	print '����� ������ : ' + convert(char, ERROR_STATE());
end catch

--10
CREATE TABLE #ProductSummary
(ProdId INT IDENTITY,
ProdName NVARCHAR(20),
Price MONEY)
 
INSERT INTO #ProductSummary
VALUES ('Nokia 8', 18000),
        ('iPhone 8', 56000)
 
SELECT * FROM #ProductSummary

--11
CREATE TABLE ##OrderInfo
(Product CHAR(10), TotalCount INT)
 
use Sav_MyBase
INSERT INTO ##OrderInfo
SELECT ORDERS.������������, SUM(ORDERS.����������_������)
FROM ORDERS
GROUP BY ORDERS.������������
 
SELECT * FROM ##OrderInfo