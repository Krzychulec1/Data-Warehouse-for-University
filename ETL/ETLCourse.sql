USE UniversityStarSchema1

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
					);
Drop View ETLDimCourse;