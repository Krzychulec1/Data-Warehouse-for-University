USE UniversityWarehouse
GO

CREATE TABLE Building(
	Building_ID INT PRIMARY KEY,
	Capacity INT,
	Floors INT,
	Last_renovation INT,
	Building_Area INT,
	Has_gastronomy BIT
);

CREATE TABLE Department(
	Department_ID INT PRIMARY KEY,
	Department_name CHAR(60),
	renovated_building BIT,
	congestion INT,
	has_library BIT,
	gastronomy INT,
	student_organization INT,
    classrooms_with_computers INT
);

CREATE TABLE Course(
	Course_ID INT PRIMARY KEY,
	Course_language CHAR(40),
	Year_of_fundation INT,
	Course_name CHAR(60),
);

CREATE TABLE Classes(
	Classes_ID INT PRIMARY KEY,
	Building_ID INT REFERENCES Building,
	Course_ID INT REFERENCES Course
);

CREATE TABLE Semester(
	Semester_ID INT PRIMARY KEY,
	Semester_year INT,
	SummerWinter CHAR(10),
	Most_crowded BIT,
	Least_crowded BIT
);

CREATE TABLE Student (
	Student_ID INT Primary key,
	Student_name CHAR(40),
	Student_surname CHAR(40),
	Date_of_Birth DATE,
	PESEL BIGINT,
	Score INT,
	Scholarship CHAR(10),
	SCDis_current BIT,
	Waiting_time INT,
	Stationary BIT
);
CREATE TABLE IsOnCourseSemester(
	IsOnCourseSemester_ID INT PRIMARY KEY,
	Course_ID INT REFERENCES Course,
	Semester_ID INT REFERENCES Semester,
	Student_ID INT REFERENCES Student,
	Department_ID INT REFERENCES Department,
	PESEL BIGINT
);

CREATE TABLE StudentOrganization(
	Organization_ID INT PRIMARY KEY,
	Organization_name CHAR(40),
	Field_of_interest CHAR(40),
	Department_ID INT REFERENCES Department
);

CREATE TABLE Gastronomy(
	Gastronomy_ID INT PRIMARY KEY,
	Local_name CHAR(40),
	Local_owner CHAR(40),
	Building_ID INT REFERENCES Building
);

CREATE TABLE Classroom(
	Classroom_ID INT PRIMARY KEY,
	Classroom_capacity INT,
	Computers CHAR(10),
	Class_area INT,
	Classroom_type CHAR(40),
	Building_ID INT REFERENCES Building
);

CREATE TABLE BelongsStudentOrganization(
	BelongsStudentOrganization_ID INT PRIMARY KEY,
	Student_ID INT REFERENCES Student,
	StudentOrganization_ID INT REFERENCES StudentOrganization
);
