USE UniversityStarSchema1
GO
INSERT INTO DimMisc (misc_ID, most_crowded_semester, least_crowded_semester)
SELECT 1,'',''
WHERE NOT EXISTS (SELECT * FROM DimMisc WHERE misc_ID = 1 AND most_crowded_semester = '' AND least_crowded_semester = '')

INSERT INTO DimMisc (misc_ID, most_crowded_semester, least_crowded_semester)
SELECT 2,1,''
WHERE NOT EXISTS (SELECT * FROM DimMisc WHERE misc_ID = 2 AND most_crowded_semester = 1 AND least_crowded_semester = '')

INSERT INTO DimMisc (misc_ID, most_crowded_semester, least_crowded_semester)
SELECT 3,'',1
WHERE NOT EXISTS (SELECT * FROM DimMisc WHERE misc_ID = 3 AND most_crowded_semester = '' AND least_crowded_semester = 1)

INSERT INTO DimMisc (misc_ID, most_crowded_semester, least_crowded_semester)
SELECT 4,1,1
WHERE NOT EXISTS (SELECT * FROM DimMisc WHERE misc_ID = 4 AND most_crowded_semester = 1 AND least_crowded_semester = 1)