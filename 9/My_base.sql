USE Sav_MyBase

--1
CREATE VIEW ������
AS SELECT GOODS.������������, GOODS.����, GOODS.����������_��_������
FROM GOODS

insert into ������ 
values('fer2', 55, 8)

alter view ������
as select * from ������
where ������.[����] > 0 with check option

insert into GOODS 
values('fer3',null, -55, 81)


--2
CREATE VIEW ����������_������ 
AS SELECT GOODS.������������, count(ORDERS.������������) [���-�� ������]
FROM GOODS 
join ORDERS on GOODS.������������=ORDERS.������������
GROUP BY GOODS.������������

--3
CREATE VIEW �������
 AS  SELECT ORDERS.id, ORDERS.����������, ORDERS.������������
FROM ORDERS
WHERE ORDERS.���������� = '�����' WITH CHECK OPTION

INSERT ������� 
VALUES (2334, '�����', '����')

--4
CREATE VIEW �����_sort
 AS SELECT top(4) GOODS.������������, GOODS.��������
FROM GOODS
ORDER BY GOODS.������������

--6
ALTER VIEW ����������_������  with schemabinding
as SELECT GOODS.������������, count(ORDERS.������������) [���-�� ������]
FROM dbo.GOODS 
join dbo.ORDERS on GOODS.������������=ORDERS.������������
GROUP BY GOODS.������������