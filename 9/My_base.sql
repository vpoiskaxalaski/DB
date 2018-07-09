USE Sav_MyBase

--1
CREATE VIEW “овары
AS SELECT GOODS.наименование, GOODS.цена, GOODS.количество_на_складе
FROM GOODS

insert into “овары 
values('fer2', 55, 8)

alter view “овары
as select * from “овары
where “овары.[цена] > 0 with check option

insert into GOODS 
values('fer3',null, -55, 81)


--2
CREATE VIEW «аказанные_товары 
AS SELECT GOODS.наименование, count(ORDERS.наименование) [кол-во товара]
FROM GOODS 
join ORDERS on GOODS.наименование=ORDERS.наименование
GROUP BY GOODS.наименование

--3
CREATE VIEW  лиенты
 AS  SELECT ORDERS.id, ORDERS.покупатель, ORDERS.наименование
FROM ORDERS
WHERE ORDERS.покупатель = 'Ёлема' WITH CHECK OPTION

INSERT  лиенты 
VALUES (2334, 'Ёлема', 'ваза')

--4
CREATE VIEW “овар_sort
 AS SELECT top(4) GOODS.наименование, GOODS.описание
FROM GOODS
ORDER BY GOODS.наименование

--6
ALTER VIEW «аказанные_товары  with schemabinding
as SELECT GOODS.наименование, count(ORDERS.наименование) [кол-во товара]
FROM dbo.GOODS 
join dbo.ORDERS on GOODS.наименование=ORDERS.наименование
GROUP BY GOODS.наименование