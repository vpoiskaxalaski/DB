use Sav_MyBase

select GOODS.������������, ORDERS.����_������
from GOODS, ORDERS
where GOODS.������������= ORDERS.������������ and
ORDERS.����������_������ in (select ORDERS.����������_������ FROM ORDERS
WHERE ORDERS.����������_������ >=5)

select GOODS.������������, ORDERS.����_������
from ORDERS
join GOODS on GOODS.������������= ORDERS.������������ and
ORDERS.����������_������ in (select ORDERS.����������_������ FROM ORDERS
WHERE ORDERS.����������_������ >=5)

select ORDERS.������������, ORDERS.����������, ORDERS.����������_������
from ORDERS
where  ����������_������ = (select top (1)  ����������_������ from ORDERS
order by ����������_������ desc)

 SELECT  GOODS.������������  from GOODS
 Where not exists  (select * from ORDERS
 Where  GOODS.������������ = ORDERS.������������)



