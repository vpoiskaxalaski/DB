use Sav_MyBase;

select ORDERS.������������, GOODS.�������� 
from ORDERS
join GOODS on ORDERS.������������ = GOODS.������������

select ORDERS.������������, ORDERS.����������, BUYER.�������
from ORDERS
left outer join BUYER on ORDERS.���������� = BUYER.����������

select GOODS.������������,
case
when (ORDERS.����������_������ = 5) then '����' 
when (ORDERS.����������_������ = 1) then '����'
end ����������_������
from ORDERS
full outer join GOODS on ORDERS.������������ =  GOODS.������������;

select ORDERS.������������, ORDERS.����������, BUYER.�������
from ORDERS
cross join BUYER 