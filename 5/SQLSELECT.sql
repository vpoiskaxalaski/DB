use SAV_UNIVER;
--С помощью оператора SELECT сфор-мировать результирующий набор,
--со-держащий все строки и столбцы таблицы FACULTY 
SELECT *  FROM  FACULTY;

--С помощью оператора SELECT сфор-мировать результирующий набор,
--со-держащий все строки столбцов TEACHER и PULPIT таблицы TEACHER
SELECT  TEACHER,PULPIT
FROM  TEACHER;

--Сформировать перечень имен препода-вателей (таблица TEACHER),
-- работаю-щих на кафедре ИСиТ (столбец PULPIT).
SELECT TEACHER_NAME, PULPIT
FROM TEACHER
WHERE PULPIT='ИСиТ';

--Сформировать перечень имен (столбец TEACHER_NAME) преподавателей (таблица TEACHER),
-- работающих на кафедре ИСиТ или на кафедре ПО-иСОИ (столбец PULPIT).
SELECT TEACHER_NAME,PULPIT FROM TEACHER WHERE (PULPIT='ИСиТ'OR PULPIT ='ПОиСОИ');

--Сформировать перечень имен (столбец TEACHER_NAME) преподавателей (таблица TEACHER) женского пола (столбец GENDER),
-- работающих на ка-федре ИСиТ.
SELECT TEACHER_NAME, GENDER, PULPIT FROM TEACHER 
	WHERE (GENDER='ж' AND PULPIT='ИСиТ');

--Сформировать перечень имен (столбец TEACHER_NAME) всех преподавате-лей (таблица TEACHER) кроме препо-давателей женского пола
-- (столбец GEN-DER), работающих на кафедре ИСиТ. При этом столбец результирующего набора должен иметь имя: Имя препо-давателя. 
SELECT TEACHER_NAME[имя преподавателя],GENDER,PULPIT FROM TEACHER
	WHERE (GENDER<>'ж' AND PULPIT='ИСиТ' );

--На основе содержимого таблицы TEACHER сформировать перечень кодов всех кафедр. Примечание: использо-вать секцию DISTINCT. 
SELECT Distinct  PULPIT FROM TEACHER;

--Сформировать перечень аудиторий (таблица AUDITORIUM) в порядке воз-растания их вместимости (столбец AUDITORIUM_CAPACITY).
-- Примечание: использовать секцию ORDER BY.
SELECT AUDITORIUM_CAPACITY  FROM AUDITORIUM
	ORDER  BY AUDITORIUM_CAPACITY ;

--На основе содержимого таблицы AUDITORIUM выбрать два типа аудиторий (столбец AUDITORIUM_TYPE),
--к ко-торым относятся самые вместительные аудитории. Примечание: использовать секции ORDER BY, ключевые слова DISTINCT и TOP.
use SAV_UNIVER;
SELECT DISTINCT TOP(4) AUDITORIUM , AUDITORIUM_TYPE,AUDITORIUM_CAPACITY  FROM AUDITORIUM
	ORDER BY AUDITORIUM_CAPACITY DESC;
	

--На основе содержимого таблицы PROGRESS сформировать перечень дисци-плин (столбец SUBJECT), по которым имеются оценки в пределах от 8 до 10.
-- Примечание: использовать ключевое слово DISTINCT и предикат BETWEEN
SELECT  Distinct  SUBJECTS,  NOTE   FROM  PROGRESS 
		  Where NOTE  Between 8 And 10;

--На основе содержимого таблицы PROFESSION определить перечень наименований специальностей (столбец PROFESSION_NAME),
-- которым соответ-ствует квалификация (столбец QUALIFICATION) в наименовании которого присутствует слово химик.
-- Результиру-ющий набор запроса должен содержать два столбца с именами: Наименование специальности и Квалификация.
-- При-мечание: использовать LIKE.
  SELECT  PROFESSION_NAME,QUALIFICATION  FROM  PROFESSION 
               Where  QUALIFICATION  Like  '%химик%' ;  

--С помощью оператора SELECT перене-сти данные о студентах (ФИО и дата рождения) во временную таблицу

SELECT NAME,BDAY INTO #STUDENT_INFO FROM STUDENT
    SELECT  * FROM #STUDENT_INFO;

--По таблице PROGRESS определить средний балл студентов, у которых нет неудовлетворительных оценок.
SELECT AVG(NOTE) AS Среднее_Значение FROM PROGRESS
	WHERE NOTE >= 4;
	
