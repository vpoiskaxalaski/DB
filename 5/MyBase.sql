use Sav_MyBase;
SELECT *  from GOODS;

SELECT наименование, дата_заказа from ORDERS
where  дата_заказа between '2018-02-01' and '2018-02-28'

SELECT Distinct Top(3) наименование, количество_на_складе
                  FROM GOODS  Order by количество_на_складе Desc;
