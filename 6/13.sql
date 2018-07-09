use SAV_UNIVER;

create table TIMETABLE(
IDGROUPS int foreign key (IDGROUPS) references GROUPS,
AUDITORIUM char(20) foreign key (AUDITORIUM) references AUDITORIUM,
SUBJECTS char(10) foreign key (SUBJECTS) references SUBJECTS,
TEACHER char(10) foreign key (TEACHER) references TEACHER,
WEEK_DAY char(20),
PARA int not null
);

insert into TIMETABLE (IDGROUPS, AUDITORIUM, SUBJECTS, TEACHER, WEEK_DAY,PARA)
values (1, '110-4', '���', '����', '�����������', 1),
	(4, '111-4', '���', '������', '�����������', 3),
	(15, '110-4', '��        ', '���       ', '�����',2),
	(26, '313-1', '��        ', '������    ', '�����������',4),
	(9, '408-2', '��        ', '���       ', '�������',5),
	(12, '423-1', '����      ', '���       ', '�������',4);
                            

--drop table TIMETABLE;

