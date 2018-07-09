use SAV_UNIVER;
--� ������� ��������� SELECT ����-�������� �������������� �����,
--��-�������� ��� ������ � ������� ������� FACULTY 
SELECT *  FROM  FACULTY;

--� ������� ��������� SELECT ����-�������� �������������� �����,
--��-�������� ��� ������ �������� TEACHER � PULPIT ������� TEACHER
SELECT  TEACHER,PULPIT
FROM  TEACHER;

--������������ �������� ���� �������-������� (������� TEACHER),
-- �������-��� �� ������� ���� (������� PULPIT).
SELECT TEACHER_NAME, PULPIT
FROM TEACHER
WHERE PULPIT='����';

--������������ �������� ���� (������� TEACHER_NAME) �������������� (������� TEACHER),
-- ���������� �� ������� ���� ��� �� ������� ��-���� (������� PULPIT).
SELECT TEACHER_NAME,PULPIT FROM TEACHER WHERE (PULPIT='����'OR PULPIT ='������');

--������������ �������� ���� (������� TEACHER_NAME) �������������� (������� TEACHER) �������� ���� (������� GENDER),
-- ���������� �� ��-����� ����.
SELECT TEACHER_NAME, GENDER, PULPIT FROM TEACHER 
	WHERE (GENDER='�' AND PULPIT='����');

--������������ �������� ���� (������� TEACHER_NAME) ���� �����������-��� (������� TEACHER) ����� �����-��������� �������� ����
-- (������� GEN-DER), ���������� �� ������� ����. ��� ���� ������� ��������������� ������ ������ ����� ���: ��� �����-��������. 
SELECT TEACHER_NAME[��� �������������],GENDER,PULPIT FROM TEACHER
	WHERE (GENDER<>'�' AND PULPIT='����' );

--�� ������ ����������� ������� TEACHER ������������ �������� ����� ���� ������. ����������: ��������-���� ������ DISTINCT. 
SELECT Distinct  PULPIT FROM TEACHER;

--������������ �������� ��������� (������� AUDITORIUM) � ������� ���-�������� �� ����������� (������� AUDITORIUM_CAPACITY).
-- ����������: ������������ ������ ORDER BY.
SELECT AUDITORIUM_CAPACITY  FROM AUDITORIUM
	ORDER  BY AUDITORIUM_CAPACITY ;

--�� ������ ����������� ������� AUDITORIUM ������� ��� ���� ��������� (������� AUDITORIUM_TYPE),
--� ��-����� ��������� ����� ������������� ���������. ����������: ������������ ������ ORDER BY, �������� ����� DISTINCT � TOP.
use SAV_UNIVER;
SELECT DISTINCT TOP(4) AUDITORIUM , AUDITORIUM_TYPE,AUDITORIUM_CAPACITY  FROM AUDITORIUM
	ORDER BY AUDITORIUM_CAPACITY DESC;
	

--�� ������ ����������� ������� PROGRESS ������������ �������� �����-���� (������� SUBJECT), �� ������� ������� ������ � �������� �� 8 �� 10.
-- ����������: ������������ �������� ����� DISTINCT � �������� BETWEEN
SELECT  Distinct  SUBJECTS,  NOTE   FROM  PROGRESS 
		  Where NOTE  Between 8 And 10;

--�� ������ ����������� ������� PROFESSION ���������� �������� ������������ �������������� (������� PROFESSION_NAME),
-- ������� �������-������ ������������ (������� QUALIFICATION) � ������������ �������� ������������ ����� �����.
-- ����������-���� ����� ������� ������ ��������� ��� ������� � �������: ������������ ������������� � ������������.
-- ���-�������: ������������ LIKE.
  SELECT  PROFESSION_NAME,QUALIFICATION  FROM  PROFESSION 
               Where  QUALIFICATION  Like  '%�����%' ;  

--� ������� ��������� SELECT ������-��� ������ � ��������� (��� � ���� ��������) �� ��������� �������

SELECT NAME,BDAY INTO #STUDENT_INFO FROM STUDENT
    SELECT  * FROM #STUDENT_INFO;

--�� ������� PROGRESS ���������� ������� ���� ���������, � ������� ��� �������������������� ������.
SELECT AVG(NOTE) AS �������_�������� FROM PROGRESS
	WHERE NOTE >= 4;
	
