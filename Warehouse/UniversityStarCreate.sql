USE UniversityStarSchema1
GO


CREATE TABLE DimDepartment(
	department_ID INT PRIMARY KEY,
    renovated_building Varchar(70),
    congestion Varchar(16),
    has_library Varchar(10),
    gastronomy Varchar(16),
    student_organization Varchar(26),
    classrooms_with_computers Varchar(20)
);

CREATE TABLE DimCourse(
	course_ID INT PRIMARY KEY,
	course_name CHAR(60	),
	is_in_english Varchar(39),
);

CREATE TABLE DimStudent(
	student_ID INTEGER IDENTITY(100001,1) PRIMARY KEY,
	nationality CHAR(20),
	is_erasmus Varchar(11),
	is_IZP Varchar(7),
	is_from_europe Varchar(15),
	PESEL BIGINT,
	SCDis_current Varchar(11),
	scholarship Varchar(15),
	SCDstartdate DATE,
	SCDenddate DATE
);

CREATE TABLE DimMisc(
    misc_ID INT PRIMARY KEY,
    most_crowded_semester Varchar(51),
    least_crowded_semester Varchar(50)
);

CREATE TABLE DimSemester(
	semester_ID INT PRIMARY KEY,
	semester_year INT,
	season CHAR(6),
	seasonNo INT
);

CREATE TABLE F_recruitment(
	recruitment_ID INT PRIMARY KEY,
	course_ID INT REFERENCES DimCourse NOT NULL,
	department_ID INT REFERENCES DimDepartment NOT NULL,
	misc_ID INT REFERENCES DimMisc NOT NULL,
	semester_ID INT REFERENCES DimSemester NOT NULL,
	student_ID INT REFERENCES DimStudent NULL,
	Waiting_time INT,
	Stationary Varchar(44)
);
INSERT INTO DimSemester VALUES(-1,0,'UNKN',0)
INSERT INTO DimMisc VALUES(-1,'UNKNOWN','UNKNOWN')
INSERT INTO DimCourse VALUES(-1,'UNKNOWN','UNKNOWN')
INSERT INTO DimDepartment VALUES(-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN')
--INSERT INTO DimStudent VALUES(-1,'UNKNOWN','UNKNOWN','UNKNOWN','UNKNOWN',1,'UNKNOWN','UNKNOWN',NULL,NULL)