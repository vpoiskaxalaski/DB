use Sav_MyBase

select GOODS.наименование, ORDERS.дата_заказа
from GOODS, ORDERS
where GOODS.наименование= ORDERS.наименование and
ORDERS.количество_товара in (select ORDERS.количество_товара FROM ORDERS
WHERE ORDERS.количество_товара >=5)

select GOODS.наименование, ORDERS.дата_заказа
from ORDERS
join GOODS on GOODS.наименование= ORDERS.наименование and
ORDERS.количество_товара in (select ORDERS.количество_товара FROM ORDERS
WHERE ORDERS.количество_товара >=5)

select ORDERS.наименование, ORDERS.покупатель, ORDERS.количество_товара
from ORDERS
where  количество_товара = (select top (1)  количество_товара from ORDERS
order by количество_товара desc)

 SELECT  GOODS.наименование  from GOODS
 Where not exists  (select * from ORDERS
 Where  GOODS.наименование = ORDERS.наименование)



