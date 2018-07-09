drop database SAV_UNIVER

use master  
go
create database SAV_UNIVER
on primary
( 
	name = N'SAV_UNIVER_mdf', 
	filename = N'E:\Unversity\��\4\SAV_UNIVER_mdf.mdf',
	size = 5120Kb,
	maxsize = 10240kb,  
	filegrowth = 1024Kb --���������� ������� 
),
(
	name = N'FACULTY', 
	filename = N'E:\Unversity\��\4\FACULTY.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
(
	name = N'AUDITORIUM_TYPE', 
	filename = N'E:\Unversity\��\4\AUDITORIUM_TYPE.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
(
	name = N'PROFESSION', 
	filename = N'E:\Unversity\��\4\PROFESSION.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
filegroup G1
(
	name = N'PULPIT', 
	filename = N'E:\Unversity\��\4\PULPIT.ndf',
	size = 10240Kb,
	maxsize = 15360kb, 
	filegrowth = 1024kb
),
(
	name = N'SUBJECT', 
	filename = N'E:\Unversity\��\4\SUBJECT.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
(
	name = N'GROUPS', 
	filename = N'E:\Unversity\��\4\GROUPS.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
(
	name = N'TEACHER', 
	filename = N'E:\Unversity\��\4\TEACHER.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
filegroup G2
(
	name = N'AUDITORIUM', 
	filename = N'E:\Unversity\��\4\AUDITORIUM.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 1024kb
)
log on
( 
	name = N'UNIVER_log',
	filename = N'E:\Unversity\��\4\UNIVER.ldf',
	size = 5120kb,
	maxsize = UNLIMITED,
	filegrowth = 1024kb
) 

use SAV_UNIVER
create table FACULTY
(
	FACULTY char(10) primary key not null,
	FACULTY_NAME varchar(50) default '???'
)
create table PROFESSION
(
	PROFESSION char(20) primary key not null,
	FACULTY char(10) foreign key (FACULTY)  references FACULTY not null,
	PROFESSION_NAME varchar(100) null,
	QUALIFICATION varchar(50) null
)

create table PULPIT
(
	PULPIT char(20) primary key not null,
	PULPIT_NAME varchar(100) null,
	FACULTY char(10) foreign key (FACULTY)  references FACULTY not null
) 

create table TEACHER 
(
	TEACHER char(10) primary key not null,
	TEACHER_NAME varchar(100) null,
	GENDER char(1) check (GENDER in('�', '�')),
	PULPIT char(20) foreign key (PULPIT)  references PULPIT not null
)

create table SUBJECTS
(
	SUBJECTS char(10) primary key not null,
	SUBJECTS_NAME varchar(100) unique null,
	PULPIT char(20) foreign key (PULPIT)  references PULPIT not null	
)

create table AUDITORIUM_TYPE
(
	AUDITORIUM_TYPE char(10) primary key not null,
	AUDITORIUM_TYPENAME varchar(30) null
)

create table AUDITORIUM
(
	AUDITORIUM char(20) primary key not null,
	AUDITORIUM_TYPE  char(10) foreign key(AUDITORIUM_TYPE) references AUDITORIUM_TYPE not null,
	AUDITORIUM_CAPACITY int default 1 check (AUDITORIUM_CAPACITY between 1 and 300),
	AUDITORIUM_NAME varchar(50) null
)
create table GROUPS
(
	IDGROUPS int primary key not null,
	FACULTY char(10) foreign key (FACULTY) references FACULTY not null,
	PROFESSION char(20) foreign key (PROFESSION) references PROFESSION not null, 
	YEAR_FIRST smallint check(YEAR_FIRST < 2020),
	COURSE as convert(smallint, YEAR(GetDate()))-YEAR_FIRST
)

create table STUDENT
(
	IDSTUDENT int primary key identity(1000,1),
	IDGROUPS int foreign key (IDGROUPS) references GROUPS not null,
	NAME nvarchar(100),
	BDAY date,
	STAMP timestamp,
	INFO xml default null,
	FOTO varbinary(max) default null
)

create table PROGRESS
(
	SUBJECTS char(10) foreign key (SUBJECTS) references SUBJECTS,  
	IDSTUDENT int foreign key (IDSTUDENT) references STUDENT, 
	PDATE date,   
	NOTE int check (NOTE between 1 and 10)
)

--drop database SAV_UNIVER
---------------------------------------
---------------------------------------

--drop table STUDENT
--drop table GROUPS
--drop table SUBJECTS
--drop table TEACHER
--drop table PULPIT
--drop table PROFESSION
--drop table FACULTY
--drop table AUDITORIUM 
--drop table AUDITORIUM_TYPE  

-------------------------------------
-------------------------------------
insert into AUDITORIUM_TYPE (AUDITORIUM_TYPE, AUDITORIUM_TYPENAME )        
	values ('��', '����������'), 
	       ('��-�','������������ �����'), 
		   ('��-�', '���������� � ���. ����������'),
		   ('��-X', '���������� �����������'),
		   ('��-��', '����. ������������ �����')
 
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
	values  ('206-1', '206-1','��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) 
	values  ('301-1',   '301-1', '��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('236-1',   '236-1', '��', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
	values  ('313-1',   '313-1', '��-�', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
	values  ('324-1',   '324-1', '��-�', 50);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('413-1',   '413-1', '��-�', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY ) 
	values  ('423-1',   '423-1', '��-�', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )     
	values  ('408-2',   '408-2', '��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('103-4',   '103-4', '��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('105-4',   '105-4', '��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('107-4',   '107-4', '��', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('110-4',   '110-4', '��', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )     
	values  ('111-4',   '111-4', '��', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('114-4',   '114-4', '��-�', 90 );
	
insert into FACULTY   (FACULTY,   FACULTY_NAME )
    values  ('����', '����������� ���� � ����������'),
			('����', '���������� ���������� � �������'),
		    ('���', '����������������� ���������'),
			('���', '���������-������������� ���������'),
		    ('����', '���������� � ������� ������ ��������������'),
		    ('���', '���������� ������������ �������'),
			('��', '��������� �������������� ����������');

 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
    values    ('����',  '1-40 01 02',   '�������������� ������� � ����������', '�������-�����������-�������������' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
    values    ('����',  '1-47 01 01', '������������ ����', '��������-��������' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
    values    ('����',  '1-36 06 01',  '��������������� ������������ � ��-����� ��������� ����������', '�������-��������������' );                     
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
	values    ('����',  '1-36 01 08',    '��������������� � ������������ ��-����� �� �������������� ����������', '�������-�������' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
	values    ('����',  '1-36 07 01',  '������ � �������� ���������� ����������� � ����������� ������������ ����������', '�������-�������' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-75 01 01',      '������ ���������', '������� ������� ���������' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-75 02 01',   '������-�������� �������������', '����-��� ������-��������� �������������' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-89 02 02',     '������ � ������������������', '�����-����� � ����� �������' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-25 01 07',  '��������� � ���������� �� �����������', '���������-��������' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-25 01 08',    '������������� ����, ������ � �����', '���������' );                      
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('����',  '1-36 05 01',   '������ � ������������ ������� ���-������', '�������-�������' );
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)
   values    ('����',  '1-46 01 01',  '�������������� ����', '�������-��������' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-48 01 02',  '���������� ���������� ������������ �������, ���������� � �������', '�������-�����-��������' );                
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)
   values    ('���',  '1-48 01 05', '���������� ���������� ����������� ���������', '�������-�����-��������' ); 
 insert into PROFESSION(FACULTY, PROFESSION,    PROFESSION_NAME, QUALIFICATION)  
   values    ('���',  '1-54 01 03', '������-���������� ������ � ������� �������� �������� ���������', '������� �� ������������' ); 


insert into PULPIT
  values  ('����', '�������������� ������ � ���������� ','����'  )
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY )
values  ('������','���������������� ������������ � ������ ��������� �����-����� ', '����'  )
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY )
  values  ('��', '����������� ���������','����'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
   values  ('���', '�����������-������������ ���������', '����'  )            
insert into PULPIT   (PULPIT,  PULPIT_NAME,FACULTY )
   values  ('��', '��������������� �����������','����'  )                              
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
    values  ('��', '�����������','���')          
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
  values  ('��', '������������','���')    
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('��', '��������������','���')           
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
  values  ('�����', '���������� � ����������������','���')                
insert into PULPIT   (PULPIT,  PULPIT_NAME,FACULTY)
   values  ('����', '������ ������� � ������������','���') 
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('���', '������� � ������������������','���')              
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('������','������������ �������������� � ������-��������� �����-��������','���')          
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('��', '���������� ����', '����')                          
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('�����','������ ����� � ���������� �������������','����')  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  ('���','���������� �������������������� �����������', '����')   
insert into PULPIT   (PULPIT,PULPIT_NAME, FACULTY)
	values  ('�����','���������� � ������� ������� �� ���������','����')    
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
	values  ('��', '������������ �����','���') 
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
	values  ('��������','���������� ���������������� ������� � ����������� ��-�������� ����������','���')
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
	values  ('���','���������� ����������� ���������','���')             
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
	values  ('�������','���������� �������������� ������� � ����� ���������� ���������� ','����') 
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
	values  ('��������','�����, ���������� ����������������� ����������� � ����-������ ����������� �������',  '����')  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
    values  ('�������','����� � ��������� ���������� � ���������� �����-������', '����')               
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
    values  ('�����','��������� � ��������� ���������� �����������','����')                                               
insert into PULPIT   (PULPIT,    PULPIT_NAME,FACULTY)
	values  ('����',    '������������� ������ � ����������','���')   
insert into PULPIT   (PULPIT,    PULPIT_NAME, FACULTY)
	values  ('����',   '����������� � ��������� ������������������','���')   
insert into PULPIT   (PULPIT,    PULPIT_NAME,FACULTY)
   values  ('������', '����������, �������������� �����, ������� � ������', '���')     
             

insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
	values  ('����',    '������ �������� �������������', '�',  '����'),
            ('�����',    '�������� ��������� ��������', '�', '����'),
            ('�����',    '���������� ������� ����������', '�', '����'),
            ('�����',    '�������� ������ ��������', '�', '����'),
            ('���',     '����� ��������� ����������', '�', '����'),
			('���',     '��������� ����� ��������', '�', '����'),
			('���',     '����� ������� ��������', '�', '����'),
			('���',     '����� ������� �������������',  '�', '����'),
			('���',     '����� ����� �������������',  '�',   '����'),
			('������',   '���������� ��������� �������������', '�','������'),
			('���',     '��������� ������� �����������', '�', '������'),
			('������',   '����������� ��������� ��������', '�', '����'),
			('����',   '������� ��������� ����������', '�', '����'),
			('����',   '������ ������ ��������', '�', '��'),
			('����', '������� ������ ����������',  '�',  '������'),
			('���',     '���������� ������� ��������', '�', '������'),
			('������',   '���������� �������� ��������', '�', '��'),
			('���',      '��������� ���� �������������', '�', '��'),
			('���',   '������ ������ ���������� ', '�', '��'),
			('�����',   '��������� �������� ���������', '�', '�����'),
			('������',   '���������� �������� ����������', '�', '��'),
			('�����',   '�������� ������ ����������', '�', '��'),
			('���',   '����� ������ ��������', '�', '�����'),
			('����',   '������ ������� ���������',  '�', '�������');                     

insert into SUBJECTS(SUBJECTS, SUBJECTS_NAME, PULPIT )
	values ('����',   '������� ���������� ������ ������','����'),
		   ('��',     '���� ������','����'), 
		   ('���',    '�������������� ����������','����'),
		   ('����',  '������ �������������� � ����������������','����'),
		   ('��',     '������������� ������ � ������������ ��������','����'),
		   ('���',    '���������������� ������� ����������','����'),
		   ('����',  '������������� ������ ��������� ����������', '����'),
		   ('���',     '�������������� �������������� ������','����'),
		   ('��',      '������������ ��������� ','����'), 
		   ('�����',   '��������. ������, �������� � �������� �����', '������'), 
		   ('���',     '������������ �������������� �������', '����'),
		   ('���',     '����������� ��������. ������������', '������'),
		   ('��',   '���������� ����������', '����'), 
		   ('��',   '�������������� ����������������','����'), 
		   ('����', '���������� ������ ���',  '����'),
		   ('���',  '��������-��������������� ����������������', '����'), 
		   ('��', '��������� ������������������','����'),
		   ('��', '������������� ������','����'), 
		   ('������OO','�������� ������ ������ � ���� � ���. ������.','��'),
		   ('�������','������ ������-��������� � ������������� ���������',  '������'),
		   ('��', '���������� �������� ','��'),
		   ('��',    '�����������', '�����'),
		   ('��',    '������������ �����', '��'),
		   ('���',    '���������� ��������� �������','��������'),
		   ('���',    '������ ��������� ����','��'),
		   ('����',   '���������� � ������������ �������������', '�����'),
		   ('����',   '���������� ���������� �������� ���������� ','�������'),
		   ('���',    '���������� ������������','��������')                                                                                                                                                           

insert into GROUPS   (IDGROUPS, FACULTY,  PROFESSION, YEAR_FIRST )
         values (1,'����','1-40 01 02', 2013), 
                (2,'����','1-40 01 02', 2012),
                (3,'����','1-40 01 02', 2011),
                (4,'����','1-40 01 02', 2010),
                (5,'����','1-47 01 01', 2013),
                (6,'����','1-47 01 01', 2012),
                (7,'����','1-47 01 01', 2011),
                (8,'����','1-36 06 01', 2010),
                (9,'����','1-36 06 01', 2013),
                (10,'����','1-36 06 01', 2012),
                (11,'����','1-36 06 01', 2011),
                (12,'����','1-36 01 08', 2013),                                                 
                (13,'����','1-36 01 08', 2012),
                (14,'����','1-36 07 01', 2011),
                (15,'����','1-36 07 01', 2010),
                (16,'���','1-48 01 02', 2012), 
                (17,'���','1-48 01 02', 2011),
                (18,'���','1-48 01 05', 2013),
                (19,'���','1-54 01 03', 2012),
                (20,'���','1-75 01 01', 2013),      
                (21,'���','1-75 02 01', 2012),
                (22,'���','1-75 02 01', 2011),
                (23,'���','1-89 02 02', 2012),
                (24,'���','1-89 02 02', 2011),  
                (25,'����','1-36 05 01', 2013),
                (26,'����','1-36 05 01', 2012),
                (27,'����','1-46 01 01', 2012),
                (28,'���','1-25 01 07', 2013), 
                (29,'���','1-25 01 07', 2012),     
                (30,'���','1-25 01 07', 2010),
                (31,'���','1-25 01 08', 2013),
                (32,'���','1-25 01 08', 2012)       


insert into STUDENT(IDGROUPS, NAME, BDAY)
    values (1, '���������� ��������� �������������','11.03.1995'),        
           (1, '������ ��������� �������',    '07.12.1995'),
           (1, '������ �������� ����������',  '12.10.1995'),
           (1, '��������� ����� �����������', '09.11.1995'),
           (1, '��������� ����� ���������',   '04.07.1995'),
           (1, '����� ��������� ���������',   '08.01.1995'),
           (1, '����� ����� ��������',        '02.08.1995'),       
		   (2, '����� ������� ��������',         '12.07.1994'),
           (2, '������� �������� ����������',    '06.03.1994'),
           (2, '�������� ����� �����������',     '09.11.1994'),
           (2, '������� ����� ���������',        '04.10.1994'),
           (2, '��������� ��������� ����������', '08.01.1994'),
           (3, '������� ������ ���������',       '02.08.1993'),
           (3, '������� ��� ����������',         '07.12.1993'),
           (3, '������� ����� �����������',      '02.12.1993'),
           (3, '���������� ������� ������������','09.11.1993'),
           (3, '������ ����� ���������',         '04.07.1993'),
           (4, '������� ������ �����������',     '08.03.1992'),
           (4, '������� ����� �������������',    '02.06.1992'),
           (4, '�������� ����� �����������',     '11.12.1992'),
           (4, '�������� ������� �������������', '11.05.1992'),
           (4, '����������� ������� ��������',   '09.11.1992'),
           (4, '�������� ������� ����������',    '01.11.1992'),
           (5, '�������� ����� ������������',    '08.07.1995'),
           (5, '������ ������� ����������',      '02.11.1995'),
           (5, '������ ��������� �����������',   '07.05.1995'),
           (5, '�������� ������ ����������',     '04.06.1995'),
           (5, '����� ������� ����������',       '09.09.1995'),
           (5, '����� ��������� ���������',      '04.08.1995'),
           (6, '���������� ����� ����������',    '08.11.1994'),
           (6, '�������� ������ ��������',       '02.03.1994'),
           (6, '���������� ����� ����������',    '04.06.1994'),
           (6, '��������� ���������� ���������', '09.11.1994'),
           (6, '����� ��������� �������',        '04.07.1994'),
           (7, '����������� ����� ������������', '03.01.1993'),
           (7, '������� ���� ��������',          '12.09.1993'),
           (7, '��������� ������ ��������',      '12.06.1993'),
           (7, '���������� ��������� ����������','09.02.1993'),
           (7, '������� ������ ���������',       '04.07.1993'),
           (8, '������ ������� ���������',       '08.01.1992'),
           (8, '��������� ����� ����������',     '12.05.1992'),
           (8, '�������� ����� ����������',      '08.11.1992'),
           (8, '������� ������� ���������',      '12.03.1992'),
           (8, '����� �������� ���������',       '10.01.1992'),
           (8, '����� ���� ��������',            '12.07.1992'),
           (9, '�������� ����� �������������',   '10.08.1995'),
           (9, '���������� ������ ��������',     '02.05.1995'),
           (9, '������ ������� �������������',   '08.01.1995'),
           (9, '��������� ��������� ��������',   '11.09.1995'),
           (9, '������ ������� ��������',        '08.04.1995'),
           (9, '������� ������� �������������',  '09.06.1995'),
           (10, '������ ������� ������������',   '08.01.1994'),
           (10, '������ ������ ����������',      '11.09.1994'),
           (10, '����� ���� �������������',      '06.04.1994'),
           (10, '������� ������ ����������',     '12.08.1994'),
           (10, '���������� ������ ���������',   '05.01.1994'),
           (10, '������ ����� ����������',       '11.02.1994'),
		   (11, '��������� ��������� ����������','07.11.1993'),
           (11, '������ ������� ����������',     '04.06.1993'),
           (11, '������� ����� ����������',      '10.12.1993'),
           (11, '������� ������ ����������',     '04.07.1993'),
           (11, '������� ����� ���������',       '08.01.1993'),
           (11, '����� ������� ����������',      '02.09.1993'),
           (12, '���� ������ �����������',       '11.12.1995'),
           (12, '������� ���� �������������',    '10.06.1995'),
           (12, '��������� ���� ���������',      '09.08.1995'),
           (12, '����� ����� ���������',         '04.07.1995'),
           (12, '��������� ������ ����������',   '08.03.1995'),
           (12, '����� ����� ��������',          '12.09.1995'),
           (13, '������ ����� ������������',     '08.10.1994'),
           (13, '���������� ����� ����������',   '10.02.1994'),
           (13, '�������� ������� �������������','11.11.1994'),
           (13, '���������� ����� ����������',   '10.02.1994'),
           (13, '����������� ����� ��������',    '12.01.1994'),
           (14, '�������� ������� �������������','11.09.1993'),
           (14, '������ �������� ����������',    '01.12.1993'),
           (14, '���� ������� ����������',       '09.06.1993'),
           (14, '�������� ���������� ����������','05.01.1993'),
           (14, '����������� ����� ����������',  '01.07.1993'),
           (15, '������� ��������� ���������',   '07.04.1992'),
           (15, '������ �������� ���������',     '10.12.1992'),
           (15, '��������� ����� ����������',    '05.05.1992'),
           (15, '���������� ����� ������������', '11.01.1992'),
           (15, '�������� ����� ����������',     '04.06.1992'),
           (16, '����� ����� ����������',        '08.01.1994'),
           (16, '��������� ��������� ���������', '07.02.1994'),
           (16, '������ ������ �����������',     '12.06.1994'),
           (16, '������� ����� ��������',        '03.07.1994'),
           (16, '������ ������ ���������',       '04.07.1994'),
           (17, '������� ��������� ����������',  '08.11.1993'),
           (17, '������ ����� ����������',       '02.04.1993'),
           (17, '������ ���� ��������',          '03.06.1993'),
           (17, '������� ������ ���������',      '05.11.1993'),
           (17, '������ ������ �������������',   '03.07.1993'),
           (18, '��������� ����� ��������',      '08.01.1995'),
           (18, '���������� ��������� ���������','06.09.1995'),
           (18, '�������� ��������� ����������', '08.03.1995'),
           (18, '��������� ����� ��������',      '07.08.1995'),
           (18, '�������� ����� ����������',     '08.01.1995'),
           (18, '���������� ���� ���������',     '02.05.1995'),
           (19, '����� ������� ����������',      '08.06.1994'),
           (19, '��������� ����� ����������',    '08.07.1994'),
           (19, '���������� ����� ����������',   '03.10.1994'),
           (19, '���������� ����� ����������',   '02.10.1994'),
           (19, '��������� ���� ����������',     '01.10.1994'),
           (20, '�������� �������� ����������',  '07.03.1995'),
           (20, '��������� ������� ��������',    '03.09.1995'),
           (20, '�������� ����� ��������',       '07.04.1995'),
           (20, '������� ����� ���������',       '08.06.1995')

insert into PROGRESS (SUBJECTS,IDSTUDENT,PDATE, NOTE)
    values ('����', 1000,  '01.10.2013',6),
           ('����', 1001,  '01.10.2013',8),
           ('����', 1002,  '01.10.2013',7),
           ('����', 1003,  '01.10.2013',5),
           ('����', 1005,  '01.10.2013',4),
		   ('����', 1014,  '01.12.2013',5),
           ('����', 1015,  '01.12.2013',9),
           ('����', 1016,  '01.12.2013',5),
           ('����', 1017,  '01.12.2013',4),
		   ('��',   1018,  '06.5.2013',4),
           ('��',   1019,  '06.05.2013',7),
           ('��',   1020,  '06.05.2013',7),
           ('��',   1021,  '06.05.2013',9),
           ('��',   1022,  '06.05.2013',5),
           ('��',   1023,  '06.05.2013',6),
		   ('��',   1064,  '01.1.2013',6),
           ('��',   1065,  '01.1.2013',4),
           ('��',   1066,  '01.1.2013',9),
           ('��',   1067,  '01.1.2013',5),
           ('��',   1068,  '01.1.2013',8),
           ('��',   1069,  '01.1.2013',4),
		   ('��',   1055,  '01.1.2013',7),
           ('��',   1056,  '01.1.2013',8),
           ('��',   1057,  '01.1.2013',9),
           ('��',   1058,  '01.1.2013',4),
           ('��',   1059,  '01.1.2013',5)