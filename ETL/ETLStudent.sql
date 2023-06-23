USE UniversityStarSchema1
GO

If (object_id('dbo.StudentTemp') is not null) DROP TABLE dbo.StudentTemp;
CREATE TABLE dbo.StudentTemp(
	student_ID INT,
	nationality CHAR(20),
	is_erasmus char(3),
	is_IZP char(3),
	is_from_europe char(10),
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
--SELECt* FROM StudentTemp ORDER BY 1 DESC
go
If (object_id('dbo.ETLDimStudent') is not null) DROP View dbo.ETLDimStudent;
go
CREATE VIEW ETLDimStudent
AS
SELECT DISTINCT TOP 200000
	dbo.StudentTemp.student_ID as student_ID,
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
	cast(null as date) AS SCDenddate

FROM UniversityWarehouse.dbo.Student
JOIN StudentTemp ON StudentTemp.student_ID = UniversityWarehouse.dbo.Student.Student_ID
ORDER BY PESEL

go
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
				AND (ST.scholarship <> TT.scholarship)
			THEN
				UPDATE
				SET TT.SCDis_current = 'Not current',
					TT.SCDenddate = @CurrentDate;

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
	@CurrentDate,
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
	@CurrentDate,
	SCDenddate
	FROM DimStudent
	;
--SELECT* FROM DimStudent WHERE PESEL =10000378273;
--SELECT* FROM DimStudent WHERE student_ID =109924
--SELECT* FROM DimStudent ORDER BY 1 DESC;
--Drop View ETLDimStudent;
Drop View ETLDimStudent;
Drop Table StudentTemp;
--SELECT * FROM Student ORDER BY 1 DESC 
