
use master  

create database Sav_MyBase
on primary
( 
	name = N'Sav_MyBase_mdf', 
	filename = N'E:\Unversity\��\4\myBase\Sav_MyBase_mdf.mdf'	
),

filegroup F1
(
	name = N'GOODS', 
	filename = N'E:\Unversity\��\4\myBase\GOODS.ndf'
),
(
	name = N'BUYER', 
	filename = N'E:\Unversity\��\4\myBase\BUYER.ndf'
),
(
	name = N'ORDERS', 
	filename = N'E:\Unversity\��\4\myBase\ORDERS.ndf'
)
log on
( 
	name = N'MyBase_log',
	filename = N'E:\Unversity\��\4\myBase\MyBase_log.ldf',
	maxsize = UNLIMITED
) 

use Sav_MyBase
create table GOODS
(
	������������ char(10) primary key not null,
	�������� varchar(50) default '???',
	���� money,
	����������_��_������ int not null	 
)
create table BUYER
(
	���������� char(20) primary key not null,
	�������  varchar(13)  null,
	����� nvarchar(50) default 'no information',
)

create table ORDERS
(
	id int primary key not null,
	������������ char(10) foreign key (������������) references GOODS  not null,
	���������� char(20) foreign key (����������)  references BUYER not null,
	����_������ date ,
	����������_������ int null
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

insert into GOODS  (������������, ��������, ����, ����������_��_������)     
	values ('������', '250 ��', 12, 60), 
		   ('�������', null , 9, 100), 
		   ('������', '550 ��', 22, 10), 
		   ('����', '�����', 30, 42), 
		   ('�������', '��� �����', 41, 35), 
		   ('�����', '200 ��', 7, 80); 
 	
insert into BUYER  (����������, �������, �����)
    values  ('�����', '+375298574568','��. ������������ 5/12'),
			('�������� �104', '+375298774568','��. �������� 26/2'),
		    ('�������� �29', '+37529674568','��. ����������� 35'),
			('����������', '+375298234568','��. ��������� 6'),
		    ('���� ����', '+375298574753','��. ��������������� 33');         

insert into  ORDERS  (id,������������, ����������, ����_������, ����������_������) 
	values  (5689,    '�������', '�����',  '12.02.2018', 3),
            (5690,    '����', '�������� �104',  '2018-01-22', 5),
            (5691,    '�������', '����������',  '2018-02-10', 9),
            (5692,    '������', '���� ����',  '2018-03-18', 1);		                  

