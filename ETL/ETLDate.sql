USE UniversityStarSchema1
GO

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
		-- Check if a row with the same values already exists in the table
		SELECT @SemesterID, Cast( Year(@DateInProcess) as varchar(4)),
			CASE WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN 'Winter'
			ELSE 'Summer' END,
			CASE WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN '1'
			ELSE '2' END
		WHERE NOT EXISTS (
			SELECT 1 FROM [dbo].[DimSemester]
			WHERE [semester_ID] = @SemesterID
			AND [semester_year] = Cast( Year(@DateInProcess) as varchar(4))
			AND [season] = CASE WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN 'Winter'
					ELSE 'Summer' END
			AND [seasonNo] = CASE WHEN DATEPART(MONTH, @DateInProcess) = 7 THEN '1'
					ELSE '2' END
		);
  
		-- Add a day and loop again
		Set @SemesterID = @SemesterID +1;
		Set @DateInProcess = DateAdd(m, 6, @DateInProcess);
	End
go
