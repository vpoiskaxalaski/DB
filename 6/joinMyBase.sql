use Sav_MyBase;

select ORDERS.наименование, GOODS.описание 
from ORDERS
join GOODS on ORDERS.наименование = GOODS.наименование

select ORDERS.наименование, ORDERS.покупатель, BUYER.телефон
from ORDERS
left outer join BUYER on ORDERS.покупатель = BUYER.покупатель

select GOODS.наименование,
case
when (ORDERS.количество_товара = 5) then 'пять' 
when (ORDERS.количество_товара = 1) then 'один'
end количество_товара
from ORDERS
full outer join GOODS on ORDERS.наименование =  GOODS.наименование;

select ORDERS.наименование, ORDERS.покупатель, BUYER.телефон
from ORDERS
cross join BUYER 