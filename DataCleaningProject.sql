/*

Cleaning Data in Sql Queries

*/


SELECT * 
FROM PortfolioProject..Fifa21Data

---------------------------------------------------------------------------------------------------------------------------------
--Changing ambiguous columns names to more clear ones

EXEC sp_rename 'PortfolioProject..Fifa21Data.↓OVA', 'OverallRating','COLUMN';
EXEC sp_rename 'PortfolioProject..Fifa21Data.POT', 'Potential','COLUMN';
EXEC sp_rename 'PortfolioProject..Fifa21Data.ID', 'id','COLUMN';
EXEC sp_rename 'PortfolioProject..Fifa21Data.Release Clause', 'ReleaseClause','COLUMN';
EXEC sp_rename 'PortfolioProject..Fifa21Data.Best Position', 'BestPosition','COLUMN';
EXEC sp_rename 'PortfolioProject..Fifa21Data.Preferred Foot', 'PreferredFoot','COLUMN';

SELECT * 
FROM PortfolioProject..Fifa21Data

---------------------------------------------------------------------------------------------------------------------------------
--Removing characters,symbols,etc... from (Value), (Wage), (Release Clause) Columns to Convert them to numeric datatypes later.

SELECT TRIM('€M' FROM Value)
FROM PortfolioProject..Fifa21Data


UPDATE PortfolioProject..Fifa21Data
SET Value = TRIM('€M' FROM Value) 

UPDATE PortfolioProject..Fifa21Data
SET Wage = TRIM('€M' FROM Value)

UPDATE PortfolioProject..Fifa21Data
SET ReleaseClause = TRIM('€M' FROM Value) 

---------------------------------------------------------------------------------------------------------------------------------

-- Used Union to combine thousands and miliions together to put the numbers in "millions" Form.

SELECT *, (Convert(float,TRIM('K' from Value)) / 1000) * 1000000 as JValuesModified -- WEIRD NAME! I'm Bad at Naming Things.
FROM PortfolioProject..Fifa21Data
Where Value like '%K'
Union
SELECT *, Convert(float, Value) * 1000000 as JValuesModified
FROM PortfolioProject..Fifa21Data
Where Value not like '%K'
Order by JValuesModified DESC


-- I had to make a new table From the Union above to Join the two tables and adding this Union to "Fifa21DAta" table.
SELECT *
FROM PortfolioProject..NumericValue

--Adding New Column to Update it to 'JValuesModified'.
ALTER TABLE PortfolioProject..Fifa21Data
ADD ValuesModified float;

-- Here's the Update 
UPDATE f
SET ValuesModified = JValuesModified
FROM PortfolioProject..Fifa21Data AS f
FULL OUTER JOIN PortfolioProject..NumericValue AS nv
ON f.id= nv.id

---------------------------------------------------------------------------------------------------------------------------------
-- Converting Columns data types

EXEC sp_rename 'PortfolioProject.dbo.Fifa21Data.Height', 'HeightInCm','COLUMN';

UPDATE PortfolioProject..Fifa21Data
SET HeightInCm = TRIM('cm' FROM HeightInCm)



ALTER TABLE PortfolioProject..Fifa21Data
ALTER COLUMN HeightInCm INT;


EXEC sp_rename 'PortfolioProject.dbo.Fifa21Data.Weight', 'WeightInKg','COLUMN';

UPDATE PortfolioProject..Fifa21Data
SET WeightInKg = TRIM('kg' FROM WeightInKg)

ALTER TABLE PortfolioProject..Fifa21Data
ALTER COLUMN WeightInKg INT;


ALTER TABLE PortfolioProject..Fifa21Data
ALTER COLUMN Joined Date;

SELECT * 
FROM PortfolioProject..Fifa21Data

---------------------------------------------------------------------------------------------------------------------------------
-- Drop Unused Columns

EXEC sp_rename 'PortfolioProject.dbo.Fifa21Data.Loan Date End', 'LoanDateEnd','COLUMN';

ALTER TABLE PortfolioProject..Fifa21Data
DROP COLUMN LongName, photoUrl, playerUrl, Contract, BOV, LoanDateEnd, Wage, ReleaseClause
