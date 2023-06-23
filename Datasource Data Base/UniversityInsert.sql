USE UniversityWarehouse
GO

BULK INSERT Building FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Building.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Department FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Department.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Course FROM 'C:\Users\jezna\PycharmProjects\pythonProject\courses1.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Classes FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Classes.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Semester FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Semester.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Student FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Names.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT IsOnCourseSemester FROM 'C:\Users\jezna\PycharmProjects\pythonProject\IsOnCourseSemester.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT StudentOrganization FROM 'C:\Users\jezna\PycharmProjects\pythonProject\StudentOrganization1.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Gastronomy FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Gastronomy.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT Classroom FROM 'C:\Users\jezna\PycharmProjects\pythonProject\Classroom.bulk' WITH (FIELDTERMINATOR='|')
BULK INSERT BelongsStudentOrganization FROM 'C:\Users\jezna\PycharmProjects\pythonProject\BelongStudentOrganization.bulk' WITH (FIELDTERMINATOR='|')


