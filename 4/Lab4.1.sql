
use master  

create database Sav_MyBase
on primary
( 
	name = N'Sav_MyBase_mdf', 
	filename = N'E:\Unversity\БД\4\myBase\Sav_MyBase_mdf.mdf'	
),

filegroup F1
(
	name = N'GOODS', 
	filename = N'E:\Unversity\БД\4\myBase\GOODS.ndf'
),
(
	name = N'BUYER', 
	filename = N'E:\Unversity\БД\4\myBase\BUYER.ndf'
),
(
	name = N'ORDERS', 
	filename = N'E:\Unversity\БД\4\myBase\ORDERS.ndf'
)
log on
( 
	name = N'MyBase_log',
	filename = N'E:\Unversity\БД\4\myBase\MyBase_log.ldf',
	maxsize = UNLIMITED
) 

use Sav_MyBase
create table GOODS
(
	наименование char(10) primary key not null,
	описание varchar(50) default '???',
	цена money,
	количество_на_складе int not null	 
)
create table BUYER
(
	покупатель char(20) primary key not null,
	телефон  varchar(13)  null,
	адрес nvarchar(50) default 'no information',
)

create table ORDERS
(
	id int primary key not null,
	наименование char(10) foreign key (наименование) references GOODS  not null,
	покупатель char(20) foreign key (покупатель)  references BUYER not null,
	дата_заказа date ,
	количество_товара int null
) 

---------------------------------------
drop database Sav_MyBase
---------------------------------------
---------------------------------------
drop table GOODS
drop table BUYER
drop table ORDERS
-------------------------------------
-------------------------------------

insert into GOODS  (наименование, описание, цена, количество_на_складе)     
	values ('кружка', '250 мл', 12, 60), 
		   ('тарелка', null , 9, 100), 
		   ('графин', '550 мл', 22, 10), 
		   ('ваза', 'Цветы', 30, 42), 
		   ('зеркало', 'для ваной', 41, 35), 
		   ('бокал', '200 мл', 7, 80); 
 	
insert into BUYER  (покупатель, телефон, адрес)
    values  ('Элема', '+375298574568','ул. Тростенецкая 5/12'),
			('Столовая №104', '+375298774568','ул. Народная 26/2'),
		    ('Столовая №29', '+37529674568','ул. Пономаренко 35'),
			('Славянская', '+375298234568','ул. Солнечная 6'),
		    ('Хлеб Соль', '+375298574753','ул. Железнодорожная 33');         

insert into  ORDERS  (id,наименование, покупатель, дата_заказа, количество_товара) 
	values  (5689,    'тарелка', 'Элема',  '12.02.2018', 3),
            (5690,    'ваза', 'Столовая №104',  '2018-01-22', 5),
            (5691,    'зеркало', 'Славянская',  '2018-02-10', 9),
            (5692,    'графин', 'Хлеб Соль',  '2018-03-18', 1);		                  

