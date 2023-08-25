-- View dataset
SELECT TOP(10) *
FROM korean_drama

-- Since krama_id is unique, check krama_id for any DUPLICATES
SELECT kdrama_id, COUNT(*)
FROM korean_drama
GROUP BY kdrama_id
HAVING COUNT(*) > 1

-- Check every column for NULL values
SELECT
    COUNT(CASE WHEN kdrama_id IS NULL THEN 1 END) AS kdramaid_nulls,
    COUNT(CASE WHEN drama_name IS NULL THEN 1 END) AS drama_name_nulls,
    COUNT(CASE WHEN year IS NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN director IS NULL THEN 1 END) AS director_nulls,
    COUNT(CASE WHEN screenwriter IS NULL THEN 1 END) AS screenwriter_nulls,
    COUNT(CASE WHEN country IS NULL THEN 1 END) AS country_nulls,
    COUNT(CASE WHEN type IS NULL THEN 1 END) AS type_nulls,
    COUNT(CASE WHEN tot_eps IS NULL THEN 1 END) AS tot_eps_nulls,
    COUNT(CASE WHEN duration IS NULL THEN 1 END) AS duration_nulls,
    COUNT(CASE WHEN start_dt IS NULL THEN 1 END) AS start_dt_nulls,
    COUNT(CASE WHEN end_dt IS NULL THEN 1 END) AS end_dt_nulls,
    COUNT(CASE WHEN aired_on IS NULL THEN 1 END) AS aired_on_nulls,
    COUNT(CASE WHEN org_net IS NULL THEN 1 END) AS org_net_nulls,
    COUNT(CASE WHEN content_rt IS NULL THEN 1 END) AS content_rt_nulls,
    COUNT(CASE WHEN synopsis IS NULL THEN 1 END) AS synopsis_nulls,
    COUNT(CASE WHEN rank IS NULL THEN 1 END) AS rank_nulls,
    COUNT(CASE WHEN pop IS NULL THEN 1 END) AS pop_nulls
FROM korean_drama
-- Null values for director: 716, screenwritter: 793, duration:24, aired_on: 232, org_net: 408, synopsis: 168

--Director column:
UPDATE korean_drama
SET director = 'Not Given'
WHERE director IS NULL
-- Remove '[]' and '' in director column
SELECT director, REPLACE(REPLACE(director,'[',''), ']', '')
FROM korean_drama
UPDATE korean_drama
SET director = REPLACE(REPLACE(director,'[',''), ']', '')
-- some rows in director have 2 or 3 directors, we will just choose the first director to show since it will be easy to visualize.
SELECT director, REPLACE(director, '''', '')
FROM korean_drama
UPDATE korean_drama
SET director = REPLACE(director, '''', '')

SELECT director,
        CASE 
            WHEN CHARINDEX(',', director) > 0 THEN SUBSTRING(director, 1, CHARINDEX(',', director) -1)
            ELSE director 
            END         
FROM korean_drama

UPDATE korean_drama
SET director = (CASE 
            WHEN CHARINDEX(',', director) > 0 THEN SUBSTRING(director, 1, CHARINDEX(',', director) -1)
            ELSE director 
            END)

-- Screenwriter column:
UPDATE korean_drama
SET screenwriter = 'Not Given'
WHERE screenwriter IS NULL
-- Remove '[]' and '' in screenwriter column
SELECT screenwriter, REPLACE(REPLACE(screenwriter,'[',''), ']', '')
FROM korean_drama
UPDATE korean_drama
SET screenwriter = REPLACE(REPLACE(screenwriter,'[',''), ']', '')

SELECT screenwriter, REPLACE(screenwriter, '''', '')
FROM korean_drama
UPDATE korean_drama
SET screenwriter = REPLACE(screenwriter, '''', '')
-- we will choose the first screeenwriter to show on report since it will be easy to visualize
SELECT screenwriter,
        CASE 
            WHEN CHARINDEX(',', screenwriter) > 0 THEN SUBSTRING(screenwriter, 1, CHARINDEX(',', screenwriter) -1)
            ELSE screenwriter
            END         
FROM korean_drama

UPDATE korean_drama
SET screenwriter = (CASE 
            WHEN CHARINDEX(',', screenwriter) > 0 THEN SUBSTRING(screenwriter, 1, CHARINDEX(',', screenwriter) -1)
            ELSE screenwriter 
            END)


-- Duration column: since there is only 24 null values in this column, we will delete them.
DELETE FROM korean_drama
WHERE kdrama_id IN (SELECT kdrama_id FROM korean_drama WHERE duration IS NULL)

-- Aired_on column:
UPDATE korean_drama
SET aired_on = 'Not Given'
WHERE aired_on IS NULL

-- Org_net column:
UPDATE korean_drama
SET org_net = 'Not Given'
WHERE org_net IS NULL

-- Synopsis column:
UPDATE korean_drama
SET synopsis = 'Not Given'
WHERE synopsis IS NULL

SELECT content_rt, COUNT(*)
FROM korean_drama
GROUP BY content_rt

SELECT content_rt, 
        CASE 
            WHEN content_rt ='18+ Restricted (violence & profanity)' THEN '18+'
            WHEN content_rt = '15+ - Teens 15 or older' THEN '18+'
            WHEN content_rt = 'R - Restricted Screening (nudity & violence)' THEN 'R'
            WHEN content_rt = 'G - All Ages' THEN 'G'
            WHEN content_rt = '13+ - Teens 13 or older' THEN '13+'
            ELSE 'Not Rated'
        END AS content_rating
FROM korean_drama

ALTER TABLE korean_drama
ADD content_rating NVARCHAR(50)

UPDATE korean_drama
SET content_rating = ( CASE 
            WHEN content_rt ='18+ Restricted (violence & profanity)' THEN '18+'
            WHEN content_rt = '15+ - Teens 15 or older' THEN '18+'
            WHEN content_rt = 'R - Restricted Screening (nudity & violence)' THEN 'R'
            WHEN content_rt = 'G - All Ages' THEN 'G'
            WHEN content_rt = '13+ - Teens 13 or older' THEN '13+'
            ELSE 'Not Rated'
        END)

-- Double check if there is still any NULL values.
SELECT
    COUNT(CASE WHEN kdrama_id IS NOT NULL THEN 1 END) AS kdramaid_nulls,
    COUNT(CASE WHEN drama_name IS NOT NULL THEN 1 END) AS drama_name_nulls,
    COUNT(CASE WHEN year IS NOT NULL THEN 1 END) AS year_nulls,
    COUNT(CASE WHEN director IS NOT NULL THEN 1 END) AS director_nulls,
    COUNT(CASE WHEN screenwriter IS NOT NULL THEN 1 END) AS screenwriter_nulls,
    COUNT(CASE WHEN tot_eps IS NOT NULL THEN 1 END) AS tot_eps_nulls,
    COUNT(CASE WHEN duration IS NOT NULL THEN 1 END) AS duration_nulls,
    COUNT(CASE WHEN start_dt IS NOT NULL THEN 1 END) AS start_dt_nulls,
    COUNT(CASE WHEN end_dt IS NOT NULL THEN 1 END) AS end_dt_nulls,
    COUNT(CASE WHEN aired_on IS NOT NULL THEN 1 END) AS aired_on_nulls,
    COUNT(CASE WHEN org_net IS NOT NULL THEN 1 END) AS org_net_nulls,
    COUNT(CASE WHEN content_rt IS NOT NULL THEN 1 END) AS content_rt_nulls,
    COUNT(CASE WHEN synopsis IS NOT NULL THEN 1 END) AS synopsis_nulls,
    COUNT(CASE WHEN rank IS NOT NULL THEN 1 END) AS rank_nulls,
    COUNT(CASE WHEN pop IS NOT NULL THEN 1 END) AS pop_nulls
FROM korean_drama
-- Total number of rows are equal for all columns.

-- Drop 2 columns: country and type which will not use in analysis.
ALTER TABLE korean_drama
DROP COLUMN country
ALTER TABLE korean_drama
DROP COLUMN type

-- Modify start_dt and end_dt columns:
-- Tried to convert start_dt column to date but could not
SELECT CONVERT(date, start_dt, 23)
FROM korean_drama
-- Check values where we could not do a convert from string to date, there are some time range 
SELECT start_dt
FROM korean_drama
WHERE ISDATE(start_dt) = 0

UPDATE korean_drama
SET start_dt = 'Aug 30, 2017'
WHERE start_dt ='Aug 30, 2017 - 2017'

UPDATE korean_drama
SET start_dt = 'Jan 15, 2017'
WHERE start_dt ='Jan 15, 2017 - 2017'

UPDATE korean_drama
SET start_dt = 'May 01, 2021'
WHERE start_dt ='May, 2021 - Jul, 2021'

UPDATE korean_drama
SET start_dt = 'Aug 01, 2017'
WHERE start_dt ='Aug, 2017 - 2017'

UPDATE korean_drama
SET start_dt = 'Aug 01, 2016'
WHERE start_dt ='Aug, 2016 - Oct, 2016'

UPDATE korean_drama
SET start_dt = CONVERT(date, start_dt, 23)

-- Convert end_dt column to date format
SELECT end_dt
FROM korean_drama
WHERE ISDATE(end_dt) = 0

UPDATE korean_drama
SET end_dt = 'Jul 01, 2021'
WHERE end_dt ='May, 2021 - Jul, 2021'

UPDATE korean_drama
SET end_dt = 'Aug 30, 2017'
WHERE end_dt ='Aug 30, 2017 - 2017'

UPDATE korean_drama
SET end_dt = 'Aug 01, 2017'
WHERE end_dt ='Aug, 2017 - 2017'

UPDATE korean_drama
SET end_dt = 'Jan 15, 2017'
WHERE end_dt ='Jan 15, 2017 - 2017'

UPDATE korean_drama
SET end_dt = 'Oct 01, 2016'
WHERE end_dt ='Aug, 2016 - Oct, 2016'

SELECT CONVERT(date, end_dt, 23)
FROM korean_drama

UPDATE korean_drama
SET end_dt = CONVERT(date, end_dt, 23)