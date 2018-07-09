drop database SAV_UNIVER

use master  
go
create database SAV_UNIVER
on primary
( 
	name = N'SAV_UNIVER_mdf', 
	filename = N'E:\Unversity\БД\4\SAV_UNIVER_mdf.mdf',
	size = 5120Kb,
	maxsize = 10240kb,  
	filegrowth = 1024Kb --приращение размера 
),
(
	name = N'FACULTY', 
	filename = N'E:\Unversity\БД\4\FACULTY.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
(
	name = N'AUDITORIUM_TYPE', 
	filename = N'E:\Unversity\БД\4\AUDITORIUM_TYPE.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
(
	name = N'PROFESSION', 
	filename = N'E:\Unversity\БД\4\PROFESSION.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 10%
),
filegroup G1
(
	name = N'PULPIT', 
	filename = N'E:\Unversity\БД\4\PULPIT.ndf',
	size = 10240Kb,
	maxsize = 15360kb, 
	filegrowth = 1024kb
),
(
	name = N'SUBJECT', 
	filename = N'E:\Unversity\БД\4\SUBJECT.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
(
	name = N'GROUPS', 
	filename = N'E:\Unversity\БД\4\GROUPS.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
(
	name = N'TEACHER', 
	filename = N'E:\Unversity\БД\4\TEACHER.ndf',
	size = 2048Kb,
	maxsize = 5120kb, 
	filegrowth = 1024kb
),
filegroup G2
(
	name = N'AUDITORIUM', 
	filename = N'E:\Unversity\БД\4\AUDITORIUM.ndf',
	size = 5120Kb,
	maxsize = 10240kb, 
	filegrowth = 1024kb
)
log on
( 
	name = N'UNIVER_log',
	filename = N'E:\Unversity\БД\4\UNIVER.ldf',
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
	GENDER char(1) check (GENDER in('м', 'ж')),
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
	values ('ЛК', 'Лекционная'), 
	       ('ЛБ-К','Компьютерный класс'), 
		   ('ЛК-К', 'Лекционная с уст. проектором'),
		   ('ЛБ-X', 'Химическая лаборатория'),
		   ('ЛБ-СК', 'Спец. компьютерный класс')
 
insert into  AUDITORIUM   (AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY)   
	values  ('206-1', '206-1','ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY) 
	values  ('301-1',   '301-1', 'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('236-1',   '236-1', 'ЛК', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
	values  ('313-1',   '313-1', 'ЛК-К', 60);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )  
	values  ('324-1',   '324-1', 'ЛК-К', 50);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('413-1',   '413-1', 'ЛБ-К', 15);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY ) 
	values  ('423-1',   '423-1', 'ЛБ-К', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )     
	values  ('408-2',   '408-2', 'ЛК', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('103-4',   '103-4', 'ЛК', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('105-4',   '105-4', 'ЛК', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('107-4',   '107-4', 'ЛК', 90);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )    
	values  ('110-4',   '110-4', 'ЛК', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )     
	values  ('111-4',   '111-4', 'ЛК', 30);
insert into  AUDITORIUM   (AUDITORIUM,   AUDITORIUM_NAME, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY )   
	values  ('114-4',   '114-4', 'ЛК-К', 90 );
	
insert into FACULTY   (FACULTY,   FACULTY_NAME )
    values  ('ИДиП', 'Издателькое дело и полиграфия'),
			('ХТиТ', 'Химическая технология и техника'),
		    ('ЛХФ', 'Лесохозяйственный факультет'),
			('ИЭФ', 'Инженерно-экономический факультет'),
		    ('ТТЛП', 'Технология и техника лесной промышленности'),
		    ('ТОВ', 'Технология органических веществ'),
			('ИТ', 'Факультет информационных технологий');

 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
    values    ('ИДиП',  '1-40 01 02',   'Информационные системы и технологии', 'инженер-программист-системотехник' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
    values    ('ИДиП',  '1-47 01 01', 'Издательское дело', 'редактор-технолог' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
    values    ('ИДиП',  '1-36 06 01',  'Полиграфическое оборудование и си-стемы обработки информации', 'инженер-электромеханик' );                     
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
	values    ('ХТиТ',  '1-36 01 08',    'Конструирование и производство из-делий из композиционных материалов', 'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
	values    ('ХТиТ',  '1-36 07 01',  'Машины и аппараты химических производств и предприятий строительных материалов', 'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
   values    ('ЛХФ',  '1-75 01 01',      'Лесное хозяйство', 'инженер лесного хозяйства' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
   values    ('ЛХФ',  '1-75 02 01',   'Садово-парковое строительство', 'инже-нер садово-паркового строительства' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('ЛХФ',  '1-89 02 02',     'Туризм и природопользование', 'специ-алист в сфере туризма' );
 insert into PROFESSION(FACULTY, PROFESSION, PROFESSION_NAME, QUALIFICATION)
   values    ('ИЭФ',  '1-25 01 07',  'Экономика и управление на предприятии', 'экономист-менеджер' );
 insert into PROFESSION(FACULTY, PROFESSION,  PROFESSION_NAME, QUALIFICATION)
   values    ('ИЭФ',  '1-25 01 08',    'Бухгалтерский учет, анализ и аудит', 'экономист' );                      
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('ТТЛП',  '1-36 05 01',   'Машины и оборудование лесного ком-плекса', 'инженер-механик' );
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)
   values    ('ТТЛП',  '1-46 01 01',  'Лесоинженерное дело', 'инженер-технолог' );
 insert into PROFESSION(FACULTY, PROFESSION,     PROFESSION_NAME, QUALIFICATION)
   values    ('ТОВ',  '1-48 01 02',  'Химическая технология органических веществ, материалов и изделий', 'инженер-химик-технолог' );                
 insert into PROFESSION(FACULTY, PROFESSION,   PROFESSION_NAME, QUALIFICATION)
   values    ('ТОВ',  '1-48 01 05', 'Химическая технология переработки древесины', 'инженер-химик-технолог' ); 
 insert into PROFESSION(FACULTY, PROFESSION,    PROFESSION_NAME, QUALIFICATION)  
   values    ('ТОВ',  '1-54 01 03', 'Физико-химические методы и приборы контроля качества продукции', 'инженер по сертификации' ); 


insert into PULPIT
  values  ('ИСиТ', 'Информационных систем и технологий ','ИДиП'  )
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY )
values  ('ПОиСОИ','Полиграфического оборудования и систем обработки инфор-мации ', 'ИДиП'  )
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY )
  values  ('БФ', 'Белорусской филологии','ИДиП'  )
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY )
   values  ('РИТ', 'Редакционно-издательских тенологий', 'ИДиП'  )            
insert into PULPIT   (PULPIT,  PULPIT_NAME,FACULTY )
   values  ('ПП', 'Полиграфических производств','ИДиП'  )                              
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
    values  ('ЛВ', 'Лесоводства','ЛХФ')          
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
  values  ('ОВ', 'Охотоведения','ЛХФ')    
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('ЛУ', 'Лесоустройства','ЛХФ')           
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
  values  ('ЛЗиДВ', 'Лесозащиты и древесиноведения','ЛХФ')                
insert into PULPIT   (PULPIT,  PULPIT_NAME,FACULTY)
   values  ('ЛКиП', 'Лесных культур и почвоведения','ЛХФ') 
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('ТиП', 'Туризма и природопользования','ЛХФ')              
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('ЛПиСПС','Ландшафтного проектирования и садово-паркового строи-тельства','ЛХФ')          
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('ТЛ', 'Транспорта леса', 'ТТЛП')                          
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
   values  ('ЛМиЛЗ','Лесных машин и технологии лесозаготовок','ТТЛП')  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
   values  ('ТДП','Технологий деревообрабатывающих производств', 'ТТЛП')   
insert into PULPIT   (PULPIT,PULPIT_NAME, FACULTY)
	values  ('ТиДИД','Технологии и дизайна изделий из древесины','ТТЛП')    
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
	values  ('ОХ', 'Органической химии','ТОВ') 
insert into PULPIT   (PULPIT,PULPIT_NAME,FACULTY)
	values  ('ТНХСиППМ','Технологии нефтехимического синтеза и переработки по-лимерных материалов','ТОВ')
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
	values  ('ХПД','Химической переработки древесины','ТОВ')             
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
	values  ('ТНВиОХТ','Технологии неорганических веществ и общей химической технологии ','ХТиТ') 
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
	values  ('ХТЭПиМЭЕ','Химии, технологии электрохимических производств и мате-риалов электронной техники',  'ХТиТ')  
insert into PULPIT   (PULPIT, PULPIT_NAME, FACULTY)
    values  ('МиАХиСП','Машин и аппаратов химических и силикатных произ-водств', 'ХТиТ')               
insert into PULPIT   (PULPIT, PULPIT_NAME,FACULTY)
    values  ('ПиАХП','Процессов и аппаратов химических производств','ХТиТ')                                               
insert into PULPIT   (PULPIT,    PULPIT_NAME,FACULTY)
	values  ('ЭТиМ',    'Экономической теории и маркетинга','ИЭФ')   
insert into PULPIT   (PULPIT,    PULPIT_NAME, FACULTY)
	values  ('МиЭП',   'Менеджмента и экономики природопользования','ИЭФ')   
insert into PULPIT   (PULPIT,    PULPIT_NAME,FACULTY)
   values  ('СБУАиА', 'Статистики, бухгалтерского учета, анализа и аудита', 'ИЭФ')     
             

insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
	values  ('СМЛВ',    'Смелов Владимир Владиславович', 'м',  'ИСиТ'),
            ('АКНВЧ',    'Акунович Станислав Иванович', 'м', 'ИСиТ'),
            ('КЛСНВ',    'Колесников Виталий Леонидович', 'м', 'ИСиТ'),
            ('БРКВЧ',    'Бракович Андрей Игоревич', 'м', 'ИСиТ'),
            ('ДТК',     'Дятко Александр Аркадьевич', 'м', 'ИСиТ'),
			('УРБ',     'Урбанович Павел Павлович', 'м', 'ИСиТ'),
			('ГРН',     'Гурин Николай Иванович', 'м', 'ИСиТ'),
			('ЖЛК',     'Жиляк Надежда Александровна',  'ж', 'ИСиТ'),
			('МРЗ',     'Мороз Елена Станиславовна',  'ж',   'ИСиТ'),
			('БРТШВЧ',   'Барташевич Святослав Александрович', 'м','ПОиСОИ'),
			('АРС',     'Арсентьев Виталий Арсентьевич', 'м', 'ПОиСОИ'),
			('БРНВСК',   'Барановский Станислав Иванович', 'м', 'ЭТиМ'),
			('НВРВ',   'Неверов Александр Васильевич', 'м', 'МиЭП'),
			('РВКЧ',   'Ровкач Андрей Иванович', 'м', 'ОВ'),
			('ДМДК', 'Демидко Марина Николаевна',  'ж',  'ЛПиСПС'),
			('БРГ',     'Бурганская Татьяна Минаевна', 'ж', 'ЛПиСПС'),
			('МШКВСК',   'Машковский Владимир Петрович', 'м', 'ЛУ'),
			('АТР',      'Атрощенко Олег Александрович', 'м', 'ЛУ'),
			('РЖК',   'Рожков Леонид Николаевич ', 'м', 'ЛВ'),
			('ЗВГЦВ',   'Звягинцев Вячеслав Борисович', 'м', 'ЛЗиДВ'),
			('БЗБРДВ',   'Безбородов Владимир Степанович', 'м', 'ОХ'),
			('НСКВЦ',   'Насковец Михаил Трофимович', 'м', 'ТЛ'),
			('МХВ',   'Мохов Сергей Петрович', 'м', 'ЛМиЛЗ'),
			('ЕЩНК',   'Ещенко Людмила Семеновна',  'ж', 'ТНВиОХТ');                     

insert into SUBJECTS(SUBJECTS, SUBJECTS_NAME, PULPIT )
	values ('СУБД',   'Системы управления базами данных','ИСиТ'),
		   ('БД',     'Базы данных','ИСиТ'), 
		   ('ИНФ',    'Информационные технологии','ИСиТ'),
		   ('ОАиП',  'Основы алгоритмизации и программирования','ИСиТ'),
		   ('ПЗ',     'Представление знаний в компьютерных системах','ИСиТ'),
		   ('ПСП',    'Программирование сетевых приложений','ИСиТ'),
		   ('МСОИ',  'Моделирование систем обработки информации', 'ИСиТ'),
		   ('ПИС',     'Проектирование информационных систем','ИСиТ'),
		   ('КГ',      'Компьютерная геометрия ','ИСиТ'), 
		   ('ПМАПЛ',   'Полиграф. машины, автоматы и поточные линии', 'ПОиСОИ'), 
		   ('КМС',     'Компьютерные мультимедийные системы', 'ИСиТ'),
		   ('ОПП',     'Организация полиграф. производства', 'ПОиСОИ'),
		   ('ДМ',   'Дискретная математика', 'ИСиТ'), 
		   ('МП',   'Математическое программирование','ИСиТ'), 
		   ('ЛЭВМ', 'Логические основы ЭВМ',  'ИСиТ'),
		   ('ООП',  'Объектно-ориентированное программирование', 'ИСиТ'), 
		   ('ЭП', 'Экономика природопользования','МиЭП'),
		   ('ЭТ', 'Экономическая теория','ЭТиМ'), 
		   ('БЛЗиПсOO','Биология лесных зверей и птиц с осн. охотов.','ОВ'),
		   ('ОСПиЛПХ','Основы садово-паркового и лесопаркового хозяйства',  'ЛПиСПС'),
		   ('ИГ', 'Инженерная геодезия ','ЛУ'),
		   ('ЛВ',    'Лесоводство', 'ЛЗиДВ'),
		   ('ОХ',    'Органическая химия', 'ОХ'),
		   ('ТРИ',    'Технология резиновых изделий','ТНХСиППМ'),
		   ('ВТЛ',    'Водный транспорт леса','ТЛ'),
		   ('ТиОЛ',   'Технология и оборудование лесозаготовок', 'ЛМиЛЗ'),
		   ('ТОПИ',   'Технология обогащения полезных ископаемых ','ТНВиОХТ'),
		   ('ПЭХ',    'Прикладная электрохимия','ХТЭПиМЭЕ')                                                                                                                                                           

insert into GROUPS   (IDGROUPS, FACULTY,  PROFESSION, YEAR_FIRST )
         values (1,'ИДиП','1-40 01 02', 2013), 
                (2,'ИДиП','1-40 01 02', 2012),
                (3,'ИДиП','1-40 01 02', 2011),
                (4,'ИДиП','1-40 01 02', 2010),
                (5,'ИДиП','1-47 01 01', 2013),
                (6,'ИДиП','1-47 01 01', 2012),
                (7,'ИДиП','1-47 01 01', 2011),
                (8,'ИДиП','1-36 06 01', 2010),
                (9,'ИДиП','1-36 06 01', 2013),
                (10,'ИДиП','1-36 06 01', 2012),
                (11,'ИДиП','1-36 06 01', 2011),
                (12,'ХТиТ','1-36 01 08', 2013),                                                 
                (13,'ХТиТ','1-36 01 08', 2012),
                (14,'ХТиТ','1-36 07 01', 2011),
                (15,'ХТиТ','1-36 07 01', 2010),
                (16,'ТОВ','1-48 01 02', 2012), 
                (17,'ТОВ','1-48 01 02', 2011),
                (18,'ТОВ','1-48 01 05', 2013),
                (19,'ТОВ','1-54 01 03', 2012),
                (20,'ЛХФ','1-75 01 01', 2013),      
                (21,'ЛХФ','1-75 02 01', 2012),
                (22,'ЛХФ','1-75 02 01', 2011),
                (23,'ЛХФ','1-89 02 02', 2012),
                (24,'ЛХФ','1-89 02 02', 2011),  
                (25,'ТТЛП','1-36 05 01', 2013),
                (26,'ТТЛП','1-36 05 01', 2012),
                (27,'ТТЛП','1-46 01 01', 2012),
                (28,'ИЭФ','1-25 01 07', 2013), 
                (29,'ИЭФ','1-25 01 07', 2012),     
                (30,'ИЭФ','1-25 01 07', 2010),
                (31,'ИЭФ','1-25 01 08', 2013),
                (32,'ИЭФ','1-25 01 08', 2012)       


insert into STUDENT(IDGROUPS, NAME, BDAY)
    values (1, 'Хартанович Екатерина Александровна','11.03.1995'),        
           (1, 'Горбач Елизавета Юрьевна',    '07.12.1995'),
           (1, 'Зыкова Кристина Дмитриевна',  '12.10.1995'),
           (1, 'Борисевич Ольга Анатольевна', '09.11.1995'),
           (1, 'Медведева Мария Андреевна',   '04.07.1995'),
           (1, 'Шенец Екатерина Сергеевна',   '08.01.1995'),
           (1, 'Шитик Алина Игоревна',        '02.08.1995'),       
		   (2, 'Силюк Валерия Ивановна',         '12.07.1994'),
           (2, 'Сергель Виолетта Николаевна',    '06.03.1994'),
           (2, 'Добродей Ольга Анатольевна',     '09.11.1994'),
           (2, 'Подоляк Мария Сергеевна',        '04.10.1994'),
           (2, 'Никитенко Екатерина Дмитриевна', '08.01.1994'),
           (3, 'Яцкевич Галина Иосифовна',       '02.08.1993'),
           (3, 'Осадчая Эла Васильевна',         '07.12.1993'),
           (3, 'Акулова Елена Геннадьевна',      '02.12.1993'),
           (3, 'Муковозчик Надежда Вячеславовна','09.11.1993'),
           (3, 'Войтко Елена Андреевна',         '04.07.1993'),
           (4, 'Плешкун Милана Анатольевна',     '08.03.1992'),
           (4, 'Буянова Мария Александровна',    '02.06.1992'),
           (4, 'Харченко Елена Геннадьевна',     '11.12.1992'),
           (4, 'Крученок Евгений Александрович', '11.05.1992'),
           (4, 'Бороховский Виталий Петрович',   '09.11.1992'),
           (4, 'Мацкевич Надежда Валерьевна',    '01.11.1992'),
           (5, 'Логинова Мария Вячеславовна',    '08.07.1995'),
           (5, 'Белько Наталья Николаевна',      '02.11.1995'),
           (5, 'Селило Екатерина Геннадьевна',   '07.05.1995'),
           (5, 'Свирский Михаил Марьянович',     '04.06.1995'),
           (5, 'Шамко Дмитрий Дмитриевич',       '09.09.1995'),
           (5, 'Дрозд Анастасия Андреевна',      '04.08.1995'),
           (6, 'Козловская Елена Евгеньевна',    '08.11.1994'),
           (6, 'Потапнин Кирилл Олегович',       '02.03.1994'),
           (6, 'Равковская Ольга Николаевна',    '04.06.1994'),
           (6, 'Ходоронок Александра Вадимовна', '09.11.1994'),
           (6, 'Рамук Владислав Юрьевич',        '04.07.1994'),
           (7, 'Неруганенок Мария Владимировна', '03.01.1993'),
           (7, 'Цыганок Анна Петровна',          '12.09.1993'),
           (7, 'Масилевич Оксана Игоревна',      '12.06.1993'),
           (7, 'Алексиевич Елизавета Викторовна','09.02.1993'),
           (7, 'Ватолин Максим Андреевич',       '04.07.1993'),
           (8, 'Синица Валерия Андреевна',       '08.01.1992'),
           (8, 'Кудряшова Алина Николаевна',     '12.05.1992'),
           (8, 'Мигулина Елена Леонидовна',      '08.11.1992'),
           (8, 'Шпиленя Алексей Сергеевич',      '12.03.1992'),
           (8, 'Ребко Светлана Сергеевна',       '10.01.1992'),
           (8, 'Ершов Юрий Олегович',            '12.07.1992'),
           (9, 'Астафьев Игорь Александрович',   '10.08.1995'),
           (9, 'Гайтюкевич Андрей Игоревич',     '02.05.1995'),
           (9, 'Рученя Наталья Александровна',   '08.01.1995'),
           (9, 'Тарасевич Анастасия Ивановна',   '11.09.1995'),
           (9, 'Скурат Наталья Ивановна',        '08.04.1995'),
           (9, 'Волосюк Николай Александрович',  '09.06.1995'),
           (10, 'Жоглин Николай Владимирович',   '08.01.1994'),
           (10, 'Санько Андрей Дмитриевич',      '11.09.1994'),
           (10, 'Пещур Анна Александровна',      '06.04.1994'),
           (10, 'Бучалис Никита Леонидович',     '12.08.1994'),
           (10, 'Трацевский Виктор Сергеевич',   '05.01.1994'),
           (10, 'Гамеза Денис Валерьевич',       '11.02.1994'),
		   (11, 'Лавренчук Владислав Николаевич','07.11.1993'),
           (11, 'Власик Евгения Викторовна',     '04.06.1993'),
           (11, 'Абрамов Денис Дмитриевич',      '10.12.1993'),
           (11, 'Оленчик Сергей Николаевич',     '04.07.1993'),
           (11, 'Савинко Павел Андреевич',       '08.01.1993'),
           (11, 'Бакун Алексей Викторович',      '02.09.1993'),
           (12, 'Бань Сергей Анатольевич',       '11.12.1995'),
           (12, 'Сечейко Илья Александрович',    '10.06.1995'),
           (12, 'Кузмичева Анна Андреевна',      '09.08.1995'),
           (12, 'Бурко Диана Францевна',         '04.07.1995'),
           (12, 'Даниленко Максим Васильевич',   '08.03.1995'),
           (12, 'Зизюк Ольга Олеговна',          '12.09.1995'),
           (13, 'Шарапо Мария Владимировна',     '08.10.1994'),
           (13, 'Касперович Вадим Викторович',   '10.02.1994'),
           (13, 'Чупрыгин Арсений Александрович','11.11.1994'),
           (13, 'Воеводская Ольга Леонидовна',   '10.02.1994'),
           (13, 'Метушевский Денис Игоревич',    '12.01.1994'),
           (14, 'Ловецкая Валерия Александровна','11.09.1993'),
           (14, 'Дворак Антонина Николаевна',    '01.12.1993'),
           (14, 'Щука Татьяна Николаевна',       '09.06.1993'),
           (14, 'Коблинец Александра Евгеньевна','05.01.1993'),
           (14, 'Фомичевская Елена Эрнестовна',  '01.07.1993'),
           (15, 'Бесараб Маргарита Вадимовна',   '07.04.1992'),
           (15, 'Бадуро Виктория Сергеевна',     '10.12.1992'),
           (15, 'Тарасенко Ольга Викторовна',    '05.05.1992'),
           (15, 'Афанасенко Ольга Владимировна', '11.01.1992'),
           (15, 'Чуйкевич Ирина Дмитриевна',     '04.06.1992'),
           (16, 'Брель Алеся Алексеевна',        '08.01.1994'),
           (16, 'Кузнецова Анастасия Андреевна', '07.02.1994'),
           (16, 'Томина Карина Геннадьевна',     '12.06.1994'),
           (16, 'Дуброва Павел Игоревич',        '03.07.1994'),
           (16, 'Шпаков Виктор Андреевич',       '04.07.1994'),
           (17, 'Шнейдер Анастасия Дмитриевна',  '08.11.1993'),
           (17, 'Шыгина Елена Викторовна',       '02.04.1993'),
           (17, 'Клюева Анна Ивановна',          '03.06.1993'),
           (17, 'Доморад Марина Андреевна',      '05.11.1993'),
           (17, 'Линчук Михаил Александрович',   '03.07.1993'),
           (18, 'Васильева Дарья Олеговна',      '08.01.1995'),
           (18, 'Щигельская Екатерина Андреевна','06.09.1995'),
           (18, 'Сазонова Екатерина Дмитриевна', '08.03.1995'),
           (18, 'Бакунович Алина Олеговна',      '07.08.1995'),
           (18, 'Тарасова Дарья Николаевна',     '08.01.1995'),
           (18, 'Матиевская Анна Сергеевна',     '02.05.1995'),
           (19, 'Урбан Наталья Евгеньевна',      '08.06.1994'),
           (19, 'Никитенко Диана Валерьевна',    '08.07.1994'),
           (19, 'Черканович Дарья Леонидовна',   '03.10.1994'),
           (19, 'Торговцева Елена Михайловна',   '02.10.1994'),
           (19, 'Прокопчук Юлия Васильевна',     '01.10.1994'),
           (20, 'Протосюк Вероника Николаевна',  '07.03.1995'),
           (20, 'Нагорский Алексей Олегович',    '03.09.1995'),
           (20, 'Архипова Янина Игоревна',       '07.04.1995'),
           (20, 'Воробей Елена Сергеевна',       '08.06.1995')

insert into PROGRESS (SUBJECTS,IDSTUDENT,PDATE, NOTE)
    values ('ОАиП', 1000,  '01.10.2013',6),
           ('ОАиП', 1001,  '01.10.2013',8),
           ('ОАиП', 1002,  '01.10.2013',7),
           ('ОАиП', 1003,  '01.10.2013',5),
           ('ОАиП', 1005,  '01.10.2013',4),
		   ('СУБД', 1014,  '01.12.2013',5),
           ('СУБД', 1015,  '01.12.2013',9),
           ('СУБД', 1016,  '01.12.2013',5),
           ('СУБД', 1017,  '01.12.2013',4),
		   ('КГ',   1018,  '06.5.2013',4),
           ('КГ',   1019,  '06.05.2013',7),
           ('КГ',   1020,  '06.05.2013',7),
           ('КГ',   1021,  '06.05.2013',9),
           ('КГ',   1022,  '06.05.2013',5),
           ('КГ',   1023,  '06.05.2013',6),
		   ('ОХ',   1064,  '01.1.2013',6),
           ('ОХ',   1065,  '01.1.2013',4),
           ('ОХ',   1066,  '01.1.2013',9),
           ('ОХ',   1067,  '01.1.2013',5),
           ('ОХ',   1068,  '01.1.2013',8),
           ('ОХ',   1069,  '01.1.2013',4),
		   ('ЭТ',   1055,  '01.1.2013',7),
           ('ЭТ',   1056,  '01.1.2013',8),
           ('ЭТ',   1057,  '01.1.2013',9),
           ('ЭТ',   1058,  '01.1.2013',4),
           ('ЭТ',   1059,  '01.1.2013',5)