use Sav_MyBase

--1
select  max(ORDERS.[количество_товара])  [максимальное кол-во],
		min(ORDERS.[количество_товара])  [минимальное кол-во],
		count(ORDERS.[количество_товара])  [общее кол-во ],
		sum(ORDERS.[количество_товара])  [сумарное кол-во],
		avg(ORDERS.[количество_товара])  [среднее кол-во]
from ORDERS
--2
SELECT  *		
from 
(select ORDERS.наименование,
count(ORDERS.наименование) [кол-во]
from ORDERS
group by ORDERS.наименование) T1
order by 
case
when T1.[кол-во] >= 5  then 1
else 2
end

--3
select ORDERS.покупатель, 
			sum(GOODS.цена * ORDERS.количество_товара) [средняя цена]
from ORDERS
join GOODS on ORDERS.наименование = GOODS.наименование
group by ORDERS.покупатель

--4
select ORDERS.покупатель, ORDERS.дата_заказа,
			sum(GOODS.цена * ORDERS.количество_товара) [средняя цена]
from ORDERS
join GOODS on ORDERS.наименование = GOODS.наименование
group by rollup( ORDERS.покупатель, ORDERS.дата_заказа)

--5
select ORDERS.покупатель, ORDERS.дата_заказа,
			sum(GOODS.цена * ORDERS.количество_товара) [средняя цена]
from ORDERS
join GOODS on ORDERS.наименование = GOODS.наименование
group by cube( ORDERS.покупатель, ORDERS.дата_заказа)

--6
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.дата_заказа = '2018-02-12'
union
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.дата_заказа = '2018-01-22'

--7
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.дата_заказа = '2018-02-12'
intersect
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.дата_заказа = '2018-01-22'


--8
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.дата_заказа = '2018-02-12'
except
select ORDERS.наименование, ORDERS.дата_заказа
from ORDERS
group by ORDERS.дата_заказа, ORDERS.наименование
having  ORDERS.наименование = 'зеркало'
