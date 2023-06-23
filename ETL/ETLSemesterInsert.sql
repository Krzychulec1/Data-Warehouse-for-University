Declare @StartDate Date; 
Declare @EndDate Date;
Declare @SemesterID int = 1;

SELECT @StartDate = '01-01-1950', @EndDate = '01-01-2022';

Declare @DateInProcess Date = @StartDate;

While @DateInProcess <= @EndDate
	Begin
		Insert Into [dbo].[DimSemester] 
		( [semester_ID] 
		, [semester_year]
		, [season]
		, [seasonNo]
		)
		Values ( 
		  @SemesterID
		  , Cast( Year(@DateInProcess) as varchar(4)) -- [Year]
		  , CASE
				WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN 'Winter'
				ELSE 'Summer'
			END
		  ,CASE
				WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN '1'
				ELSE '2'
			END
		);  
		-- Add a day and loop again
		Set @SemesterID = @SemesterID +1;
		Set @DateInProcess = DateAdd(m, 6, @DateInProcess);
	End
go

--SELECT* FROM  [dbo].[DimSemester]


INSERT INTO DimMisc VALUES(1,'','')
INSERT INTO DimMisc VALUES(2,'Year with the highest number of recruited students','')
INSERT INTO DimMisc VALUES(3,'','Year with the lowest number of recruited students')
INSERT INTO DimMisc VALUES(4,'Year with the highest number of recruited students','Year with the lowest number of recruited students')

--SELECT* FROM  [dbo].DimMisc

GO
CREATE VIEW ETLDimCourse
AS
SELECT DISTINCT
	Course_ID as course_ID,
	Course_name as course_name,
	CASE
		WHEN Course_language = 'English' THEN 'The course is conducted in english'
		ELSE 'The course is not  conducted in english'
	END AS is_in_english
FROM UniversityWarehouse.dbo.Course;
go
MERGE INTO dbo.DimCourse as TT
	USING ETLDimCourse as ST
		ON TT.course_ID = ST.course_ID
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.course_ID,
					ST.course_name,
					ST.is_in_english
					)
			WHEN Not Matched By Source
				Then
					DELETE	;
Drop View ETLDimCourse;
--Select* from DimCourse

go
CREATE VIEW ETLDimDepartment
AS
SELECT DISTINCT
	department_ID as department_ID,
	CASE
		WHEN renovated_building= 1 THEN 'The department has MORE than 60% of buildings renovated after 2010'
		ELSE 'The department has LESS than 60% of buildings renovated after 2010'
	END AS renovated_building,
	CASE
		WHEN congestion <=2 THEN 'Small congestion'
		WHEN congestion BETWEEN 2 and 4 THEN 'AVG congestion'
		ELSE 'Big congestion'
	END AS congestion,
	CASE
		WHEN has_library = '1' THEN 'Library '
		ELSE 'No library'
	END AS has_library,
	CASE
		WHEN gastronomy = 0 THEN 'No gastronomy'
		WHEN gastronomy = 1 THEN 'One gastronomy'
		ELSE 'Many gastronomia'
	END AS gastronomy,
	CASE
		WHEN student_organization = 0 THEN 'No student organization'
		WHEN student_organization = 1 THEN 'One student organization'
		ELSE 'Many student organizations'
	END AS student_organization,
	CASE
		WHEN classrooms_with_computers = 0 THEN 'No classrooms'
		WHEN classrooms_with_computers BETWEEN 0 AND 25 THEN 'Some classrooms'
		WHEN classrooms_with_computers BETWEEN 25 AND 75 THEN 'Many  classrooms'
		else 'Lots classrooms'
	END AS classrooms_with_computers
FROM UniversityWarehouse.dbo.Department;

go
MERGE INTO dbo.DimDepartment as TT
	USING ETLDimDepartment as ST
		ON TT.department_ID = ST.department_ID 
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.department_ID,
					ST.renovated_building,
					ST.congestion,
					ST.has_library,
					ST.gastronomy,
					ST.student_organization,
					ST.classrooms_with_computers
					)
			WHEN Not Matched By Source
				Then
					DELETE	;
Drop View ETLDimDepartment;
--Select* from DimDepartment

go
CREATE VIEW ETLDimBuilding
AS
SELECT DISTINCT
	Building_ID as building_ID,
	CASE
		WHEN Has_gastronomy = 1 THEN 'Gastronomy'
		ELSE 'No gastronomy'
	END AS has_gastronomy
FROM UniversityWarehouse.dbo.Building;
go
MERGE INTO dbo.DimBuilding as TT
	USING ETLDimBuilding as ST
		ON TT.building_ID = ST.building_ID
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.building_ID,
					ST.has_gastronomy
					)
			WHEN Not Matched By Source
				Then
					DELETE	;
Drop View ETLDimBuilding;
--Select* from DimBuilding

If (object_id('dbo.StudentTemp') is not null) DROP TABLE dbo.StudentTemp;
CREATE TABLE dbo.StudentTemp(
	student_ID INT,
	nationality CHAR(20),
	is_erasmus char(3),
	is_IZP char(3),
	is_from_europe char(6),
	)

BULK INSERT dbo.StudentTemp
    FROM 'F:\Pobrane\ExcelDW.csv'
    WITH
    (
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',  --CSV field delimiter
    ROWTERMINATOR = '|',   --Use to shift the control to next row
    TABLOCK
    )
ALTER TABLE dbo.StudentTemp
ADD PESEL BIGINT;

ALTER TABLE dbo.StudentTemp
ADD SCDis_current Varchar(11);

ALTER TABLE dbo.StudentTemp
ADD scholarship Varchar(15);

ALTER TABLE dbo.StudentTemp
ADD SCDenddate DATE;

ALTER TABLE dbo.StudentTemp
ADD SCDstartdate DATE;

go
CREATE VIEW ETLDimStudent
AS
SELECT DISTINCT
	nationality as nationality,
	CASE
		WHEN is_erasmus = 1 THEN 'Erasmus'
		ELSE 'Not Erasmus'
	END AS is_erasmus,
	CASE
		WHEN is_IZP = 1 THEN 'IZP'
		ELSE 'Not IZP'
	END AS is_IZP,
	CASE
		WHEN is_from_europe = '1,  ' THEN 'From Europe'
		ELSE 'Not from Europe'
	END AS is_from_europe,
	UniversityWarehouse.dbo.Student.PESEL as PESEL,
	CASE
		WHEN UniversityWarehouse.dbo.Student.SCDis_current = 1 THEN 'Current'
		ELSE 'Not current'
	END AS SCDis_current,
	CASE
		WHEN UniversityWarehouse.dbo.Student.Scholarship = 1 THEN 'Scholarship'
		ELSE 'No scholarship'
	END AS scholarship,
	'1950-01-01' AS SCDstartdate,
	'0001-01-01' AS SCDenddate

FROM UniversityWarehouse.dbo.Student
JOIN StudentTemp ON UniversityWarehouse.dbo.Student.Student_ID = StudentTemp.student_ID;

SELECT *FROM ETLDimStudent

Declare @CurrentDate DATE =CAST (GETDATE()as Date)

MERGE INTO dbo.DimStudent as TT
	USING ETLDimStudent as ST
		ON TT.PESEL = ST.PESEL
			WHEN Not Matched
				THEN
					INSERT
					Values (
					ST.nationality,
					ST.is_erasmus,
					ST.is_IZP,
					ST.is_from_europe,
					ST.PESEL,
					ST.SCDis_current,
					ST.scholarship,
					ST.SCDstartdate,
					ST.SCDenddate
					)
				WHEN Matched 
				AND (ST.nationality <> TT.nationality
				OR ST.is_IZP <> TT.is_IZP
				OR ST.scholarship <> TT.scholarship)
			THEN
				UPDATE
				SET TT.SCDis_current = 'Not current',
					TT.SCDenddate = @CurrentDate
			WHEN Not Matched By Source
				Then
					DELETE	;

--SELECT *FROM DimStudent
Declare @CurrentDate1 DATE =CAST (GETDATE()as Date)
INSERT INTO DimStudent(
	nationality,
	is_erasmus,
	is_IZP,
	is_from_europe,
	PESEL,
	SCDis_current,
	scholarship,
	SCDstartdate,
	SCDenddate
)
SELECT 
	nationality,
	is_erasmus,
	is_IZP,
	is_from_europe,
	PESEL,
	'Current',
	scholarship,
	@CurrentDate1,
	SCDenddate
	FROM ETLDimStudent
	EXCEPT
	SELECT
	nationality,
	is_erasmus,
	is_IZP,
	is_from_europe,
	PESEL,
	'Current',
	scholarship,
	@CurrentDate1,
	SCDenddate
	FROM DimStudent

SELECT* FROM DimStudent ORDER BY 1 DESC;
Drop View ETLDimStudent;
Drop Table StudentTemp;
SELECT * FROM DimStudent

