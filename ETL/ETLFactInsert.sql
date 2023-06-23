If (object_id('view_junkNeed') is not null) Drop View view_junkNeed;
go
CREATE VIEW view_junkNeed
AS
SELECT DISTINCT
	[UniversityWarehouse].dbo.IsOnCourseSemester.IsOnCourseSemester_ID as junkNeed_ID,
	CASE 
		WHEN [UniversityWarehouse].dbo.Semester.Most_crowded = '1' THEN '1'--'Most crowded semester'
		else ''
	END AS most_crowded,
	CASE 
		WHEN [UniversityWarehouse].dbo.Semester.Least_crowded = '1' THEN '1' -- 'Least crowded semester'
		else ''
	END AS least_crowded
	FROM [UniversityWarehouse].dbo.IsOnCourseSemester
	LEFT JOIN [UniversityWarehouse].dbo.Semester ON [UniversityWarehouse].dbo.Semester.Semester_ID = [UniversityWarehouse].dbo.IsOnCourseSemester.Semester_ID

go
If (object_id('view_auxilary') is not null) Drop View view_auxilary;
go
CREATE VIEW view_auxilary
AS
SELECT DISTINCT 
[UniversityStarSchema1].dbo.DimMisc.misc_ID as [miscID],
[UniversityStarSchema1].dbo.view_junkNeed.junkNeed_ID as [appID]
FROM [UniversityStarSchema1].dbo.DimMisc
INNER JOIN [UniversityStarSchema1].dbo.view_junkNeed ON [UniversityStarSchema1].dbo.view_junkNeed.most_crowded = [UniversityStarSchema1].dbo.DimMisc.most_crowded_semester
AND  [UniversityStarSchema1].dbo.view_junkNeed.least_crowded = [UniversityStarSchema1].dbo.DimMisc.least_crowded_semester

go
If (object_id('vETLFRecruitment') is not null) Drop view vETLFRecruitment;
go
CREATE VIEW vETLFRecruitment
AS
SELECT DISTINCT 
	[UniversityWarehouse].dbo.IsOnCourseSemester.IsOnCourseSemester_ID as recruitment_ID,
	CASE WHEN [UniversityWarehouse].dbo.Course.Course_ID IS NOT NULL THEN [UniversityWarehouse].dbo.Course.Course_ID ELSE -1 END as course_ID,
	CASE WHEN [UniversityWarehouse].dbo.Department.Department_ID IS NOT NULL THEN  [UniversityWarehouse].dbo.Department.Department_ID ELSE -1 END as department_ID,
	CASE WHEN [UniversityStarSchema1].dbo.view_auxilary.miscID IS NOT NULL THEN [UniversityStarSchema1].dbo.view_auxilary.miscID ELSE -1 END as misc_ID,
	CASE WHEN [UniversityWarehouse].dbo.Semester.Semester_ID IS NOT NULL THEN [UniversityWarehouse].dbo.Semester.Semester_ID ELSE -1 END as semester_ID,
	CASE WHEN [UniversityStarSchema1].dbo.DimStudent.student_ID IS NOT NULL THEN [UniversityStarSchema1].dbo.DimStudent.student_ID ELSE -1 END as student_ID,
	CASE WHEN [UniversityWarehouse].dbo.Student.Waiting_time IS NOT NULL THEN [UniversityWarehouse].dbo.Student.Waiting_time ELSE -1 END as waiting_time,
	CASE WHEN [UniversityWarehouse].dbo.Student.Stationary IS NOT NULL THEN [UniversityWarehouse].dbo.Student.Stationary ELSE -1 END as stationary
		FROM [UniversityWarehouse].dbo.IsOnCourseSemester
		LEFT JOIN [UniversityWarehouse].dbo.Course ON [UniversityWarehouse].dbo.Course.Course_ID = [UniversityWarehouse].dbo.IsOnCourseSemester.Course_ID
		LEFT JOIN [UniversityWarehouse].dbo.Classes ON [UniversityWarehouse].dbo.Classes.Course_ID = [UniversityWarehouse].dbo.Course.Course_ID
		lEFT JOIN [UniversityWarehouse].dbo.Department ON [UniversityWarehouse].dbo.Department.Department_ID =[UniversityWarehouse].dbo.IsOnCourseSemester.Department_ID
		LEFT JOIN [UniversityWarehouse].dbo.Student ON [UniversityWarehouse].dbo.Student.PESEL = [UniversityWarehouse].dbo.IsOnCourseSemester.PESEL
		LEFT JOIN [UniversityWarehouse].dbo.Semester ON [UniversityWarehouse].dbo.Semester.Semester_ID = [UniversityWarehouse].dbo.IsOnCourseSemester.Semester_ID
		LEFT JOIN [UniversityStarSchema1].dbo.view_auxilary ON [UniversityStarSchema1].dbo.view_auxilary.appID = [UniversityWarehouse].dbo.IsOnCourseSemester.IsOnCourseSemester_ID
		JOIN [UniversityStarSchema1].dbo.DimStudent ON [UniversityStarSchema1].dbo.DimStudent.PESEL = [UniversityWarehouse].dbo.Student.PESEL and [UniversityStarSchema1].dbo.DimStudent.SCDis_current = 'Current'
go
MERGE INTO [UniversityStarSchema1].dbo.F_recruitment as TT
	USING vETLFRecruitment as ST
		ON TT.recruitment_ID = ST.recruitment_ID
			WHEN Not Matched
				THEN
					INSERT
					Values (
					recruitment_ID,
					course_ID,
					department_ID,
					misc_ID,
					semester_ID,
					student_ID,
					waiting_time,
					stationary
					)
			WHEN Not Matched By Source
				Then
					DELETE
				;

DROP VIEW view_junkNeed
DROP VIEW vETLFRecruitment
DROP VIEW view_auxilary

--SELECT* FROM F_recruitment ORDER BY 1 DESC