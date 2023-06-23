USE UniversityStarSchema1
GO
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
					);
Drop View ETLDimDepartment;