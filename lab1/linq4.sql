USE SavchukProdaji
SELECT Наименование_товара,Заказчик, Дата_поставки FROM ЗАКАЗЫ
WHERE Заказчик = 'Монолит_Групп'       
ORDER BY Дата_поставки DESC;