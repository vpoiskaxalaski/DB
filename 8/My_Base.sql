use Sav_MyBase

--1
select  max(ORDERS.[����������_������])  [������������ ���-��],
		min(ORDERS.[����������_������])  [����������� ���-��],
		count(ORDERS.[����������_������])  [����� ���-�� ],
		sum(ORDERS.[����������_������])  [�������� ���-��],
		avg(ORDERS.[����������_������])  [������� ���-��]
from ORDERS
--2
SELECT  *		
from 
(select ORDERS.������������,
count(ORDERS.������������) [���-��]
from ORDERS
group by ORDERS.������������) T1
order by 
case
when T1.[���-��] >= 5  then 1
else 2
end

--3
select ORDERS.����������, 
			sum(GOODS.���� * ORDERS.����������_������) [������� ����]
from ORDERS
join GOODS on ORDERS.������������ = GOODS.������������
group by ORDERS.����������

--4
select ORDERS.����������, ORDERS.����_������,
			sum(GOODS.���� * ORDERS.����������_������) [������� ����]
from ORDERS
join GOODS on ORDERS.������������ = GOODS.������������
group by rollup( ORDERS.����������, ORDERS.����_������)

--5
select ORDERS.����������, ORDERS.����_������,
			sum(GOODS.���� * ORDERS.����������_������) [������� ����]
from ORDERS
join GOODS on ORDERS.������������ = GOODS.������������
group by cube( ORDERS.����������, ORDERS.����_������)

--6
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.����_������ = '2018-02-12'
union
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.����_������ = '2018-01-22'

--7
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.����_������ = '2018-02-12'
intersect
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.����_������ = '2018-01-22'


--8
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.����_������ = '2018-02-12'
except
select ORDERS.������������, ORDERS.����_������
from ORDERS
group by ORDERS.����_������, ORDERS.������������
having  ORDERS.������������ = '�������'
