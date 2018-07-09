create database kr;
--1
create table AUD_TYPE(
Kod_AUD int primary key not null,
Name_AUD char(15))

create table AUD(
Kod_AUD int foreign key references AUD_TYPE(Kod_AUD),
Tip_AUD char(10) default '???',
Vmest_AUD int)

insert into AUD_TYPE values
(111, '121-2'),(112, '221-4'), (113, '151-1'),(114, '321-3'), (151, '421-2')

insert into AUD values
(112, 'лк', 500), (111, 'лб', 50), (151, 'лк', 250),(114, 'пз', 80)

select AUD.Kod_AUD, AUD.Tip_AUD , AUD.Vmest_AUD
from  AUD
join AUD_TYPE on AUD.Kod_AUD= AUD_TYPE.Kod_AUD

--2
select AUD.Tip_AUD,
		max(AUD.Vmest_AUD) [макс. вместимость],
		sum(AUD.Vmest_AUD) [сум. вместимость],
		count(AUD.Vmest_AUD) [кол-во аудиторий]
from AUD
join AUD_TYPE on AUD.Kod_AUD=AUD_TYPE.Kod_AUD
group by AUD.Tip_AUD