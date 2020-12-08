/* [SINGH]  Characterizing how Racial and Social Factors Impact use of anti-VEGF Treatment of Diabetic Macular Edema 
	Author: Kat Parisis 
	Start Date: 28-Oct-2020
	End Date: 29-Oct-2020
	Database Version: 09-Oct-2020 */

--STEP 1: Create patient universe 
		
		--1a. First, we want to focus on coding the inclusion criteria.
		--We want to filter for patients in Madrid2 that have:
		--all ICD codes listed in SAP inclusion criteria
		--have been diagnosed between 2013 and 2018 
		
		--1b. We are also creating the 'diagnosis_date' since we don’t have a diagnosis date column in Madrid2.
		--It is standard protocol to take which ever date is earliest between documentation_date and problem_onset_date in the patient_problem_laterality 
		--table in order to create the diagnosis date since they are both related to the diagnosis that the patient has. Our goal with
		--taking the earliest date is to eventually create the index date for when the patients entered this study.
		
		--1c. Since this analysis and the ICD codes are eye level, we want to pull the appropriate eyes that
		--correspond to each diagnosis. We assign '1' for the right eye, '2' for the left eye. For '3' (which is bilateral)
		--we assign it into '1' and '2' to eliminate any ambiguity and get the proper eye count for the universe.
		--If we left bilateral eyes as '3', then we would not have counted the correct number of eyes since the count 
		--function in SQL is ran on a row level and recognizes '3' as one row instead of two, which is the actual number of 
		--eyes that we want to account for.
		
		--1d. We UNION these three datasets to stack their results into one cohesive dataset. 
			 
DROP TABLE IF EXISTS aao_grants.singh_universe_new;
CREATE TABLE aao_grants.singh_universe_new AS 
(SELECT DISTINCT
	patient_guid,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code,
	CASE WHEN diag_eye = '1' THEN
		1
	WHEN diag_eye = '2' THEN
		2
	END AS eye,
	problem_code
FROM
	madrid2.patient_problem_laterality 
WHERE
	EXTRACT (year from diagnosis_date) BETWEEN '2013' AND '2018'
	and(
		problem_code ILIKE 'E08.37X1%'
		OR problem_code ILIKE 'E08.37X2%'
		OR problem_code ILIKE 'E08.37X3%'
		OR problem_code ILIKE 'E09.37X1%'
		OR problem_code ILIKE 'E09.37X2%'
		OR problem_code ILIKE 'E09.37X3%'
		OR problem_code ILIKE 'E10.37X1%'
		OR problem_code ILIKE 'E10.37X2%'
		OR problem_code ILIKE 'E10.37X3%'
		OR problem_code ILIKE 'E11.37X1%'
		OR problem_code ILIKE 'E11.37X2%'
		OR problem_code ILIKE 'E11.37X3%'
		OR problem_code ILIKE 'E13.37X1%'
		OR problem_code ILIKE 'E13.37X2%'
		OR problem_code ILIKE 'E13.37X3%'
		OR problem_code ILIKE 'E08.3211%'
		OR problem_code ILIKE 'E08.3212%'
		OR problem_code ILIKE 'E08.3213%'
		OR problem_code ILIKE 'E08.3311%'
		OR problem_code ILIKE 'E08.3312%'
		OR problem_code ILIKE 'E08.3313%'
		OR problem_code ILIKE 'E08.3411%'
		OR problem_code ILIKE 'E08.3412%'
		OR problem_code ILIKE 'E08.3413%'
		OR problem_code ILIKE 'E08.3511%'
		OR problem_code ILIKE 'E08.3512%'
		OR problem_code ILIKE 'E08.3513%'
		OR problem_code ILIKE 'E09.3211%'
		OR problem_code ILIKE 'E09.3212%'
		OR problem_code ILIKE 'E09.3213%'
		OR problem_code ILIKE 'E09.3311%'
		OR problem_code ILIKE 'E09.3312%'
		OR problem_code ILIKE 'E09.3313%'
		OR problem_code ILIKE 'E09.3411%'
		OR problem_code ILIKE 'E09.3412%'
		OR problem_code ILIKE 'E09.3413%'
		OR problem_code ILIKE 'E09.3511%'
		OR problem_code ILIKE 'E09.3512%'
		OR problem_code ILIKE 'E09.3513%'
		OR problem_code ILIKE 'E10.3211%'
		OR problem_code ILIKE 'E10.3212%'
		OR problem_code ILIKE 'E10.3213%'
		OR problem_code ILIKE 'E10.3311%'
		OR problem_code ILIKE 'E10.3312%'
		OR problem_code ILIKE 'E10.3313%'
		OR problem_code ILIKE 'E10.3411%'
		OR problem_code ILIKE 'E10.3412%'
		OR problem_code ILIKE 'E10.3413%'
		OR problem_code ILIKE 'E10.3511%'
		OR problem_code ILIKE 'E10.3512%'
		OR problem_code ILIKE 'E10.3513%'
		OR problem_code ILIKE 'E11.3211%'
		OR problem_code ILIKE 'E11.3212%'
		OR problem_code ILIKE 'E11.3213%'
		OR problem_code ILIKE 'E11.3311%'
		OR problem_code ILIKE 'E11.3312%'
		OR problem_code ILIKE 'E11.3313%'
		OR problem_code ILIKE 'E11.3411%'
		OR problem_code ILIKE 'E11.3412%'
		OR problem_code ILIKE 'E11.3413%'
		OR problem_code ILIKE 'E11.3511%'
		OR problem_code ILIKE 'E11.3512%'
		OR problem_code ILIKE 'E11.3513%'
		OR problem_code ILIKE 'E13.3211%'
		OR problem_code ILIKE 'E13.3212%'
		OR problem_code ILIKE 'E13.3213%'
		OR problem_code ILIKE 'E13.3311%'
		OR problem_code ILIKE 'E13.3312%'
		OR problem_code ILIKE 'E13.3313%'
		OR problem_code ILIKE 'E13.3411%'
		OR problem_code ILIKE 'E13.3412%'
		OR problem_code ILIKE 'E13.3413%'
		OR problem_code ILIKE 'E13.3511%'
		OR problem_code ILIKE 'E13.3512%'
		OR problem_code ILIKE 'E13.3513%')
		and diag_eye in (1, 2))
UNION
 (SELECT DISTINCT
	patient_guid,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code,
	case when diag_eye = '3' then 1 
		end as eye,
	problem_code
FROM
	madrid2.patient_problem_laterality 
WHERE EXTRACT (year from diagnosis_date) BETWEEN '2013' AND '2018'
	and (
		problem_code ILIKE 'E08.37X1%'
		OR problem_code ILIKE 'E08.37X2%'
		OR problem_code ILIKE 'E08.37X3%'
		OR problem_code ILIKE 'E09.37X1%'
		OR problem_code ILIKE 'E09.37X2%'
		OR problem_code ILIKE 'E09.37X3%'
		OR problem_code ILIKE 'E10.37X1%'
		OR problem_code ILIKE 'E10.37X2%'
		OR problem_code ILIKE 'E10.37X3%'
		OR problem_code ILIKE 'E11.37X1%'
		OR problem_code ILIKE 'E11.37X2%'
		OR problem_code ILIKE 'E11.37X3%'
		OR problem_code ILIKE 'E13.37X1%'
		OR problem_code ILIKE 'E13.37X2%'
		OR problem_code ILIKE 'E13.37X3%'
		OR problem_code ILIKE 'E08.3211%'
		OR problem_code ILIKE 'E08.3212%'
		OR problem_code ILIKE 'E08.3213%'
		OR problem_code ILIKE 'E08.3311%'
		OR problem_code ILIKE 'E08.3312%'
		OR problem_code ILIKE 'E08.3313%'
		OR problem_code ILIKE 'E08.3411%'
		OR problem_code ILIKE 'E08.3412%'
		OR problem_code ILIKE 'E08.3413%'
		OR problem_code ILIKE 'E08.3511%'
		OR problem_code ILIKE 'E08.3512%'
		OR problem_code ILIKE 'E08.3513%'
		OR problem_code ILIKE 'E09.3211%'
		OR problem_code ILIKE 'E09.3212%'
		OR problem_code ILIKE 'E09.3213%'
		OR problem_code ILIKE 'E09.3311%'
		OR problem_code ILIKE 'E09.3312%'
		OR problem_code ILIKE 'E09.3313%'
		OR problem_code ILIKE 'E09.3411%'
		OR problem_code ILIKE 'E09.3412%'
		OR problem_code ILIKE 'E09.3413%'
		OR problem_code ILIKE 'E09.3511%'
		OR problem_code ILIKE 'E09.3512%'
		OR problem_code ILIKE 'E09.3513%'
		OR problem_code ILIKE 'E10.3211%'
		OR problem_code ILIKE 'E10.3212%'
		OR problem_code ILIKE 'E10.3213%'
		OR problem_code ILIKE 'E10.3311%'
		OR problem_code ILIKE 'E10.3312%'
		OR problem_code ILIKE 'E10.3313%'
		OR problem_code ILIKE 'E10.3411%'
		OR problem_code ILIKE 'E10.3412%'
		OR problem_code ILIKE 'E10.3413%'
		OR problem_code ILIKE 'E10.3511%'
		OR problem_code ILIKE 'E10.3512%'
		OR problem_code ILIKE 'E10.3513%'
		OR problem_code ILIKE 'E11.3211%'
		OR problem_code ILIKE 'E11.3212%'
		OR problem_code ILIKE 'E11.3213%'
		OR problem_code ILIKE 'E11.3311%'
		OR problem_code ILIKE 'E11.3312%'
		OR problem_code ILIKE 'E11.3313%'
		OR problem_code ILIKE 'E11.3411%'
		OR problem_code ILIKE 'E11.3412%'
		OR problem_code ILIKE 'E11.3413%'
		OR problem_code ILIKE 'E11.3511%'
		OR problem_code ILIKE 'E11.3512%'
		OR problem_code ILIKE 'E11.3513%'
		OR problem_code ILIKE 'E13.3211%'
		OR problem_code ILIKE 'E13.3212%'
		OR problem_code ILIKE 'E13.3213%'
		OR problem_code ILIKE 'E13.3311%'
		OR problem_code ILIKE 'E13.3312%'
		OR problem_code ILIKE 'E13.3313%'
		OR problem_code ILIKE 'E13.3411%'
		OR problem_code ILIKE 'E13.3412%'
		OR problem_code ILIKE 'E13.3413%'
		OR problem_code ILIKE 'E13.3511%'
		OR problem_code ILIKE 'E13.3512%'
		OR problem_code ILIKE 'E13.3513%')
		and diag_eye = '3')
UNION
 (SELECT DISTINCT
	patient_guid,
	CASE WHEN documentation_date IS NULL THEN
		problem_onset_date
	WHEN problem_onset_date IS NULL THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date < documentation_date THEN
		problem_onset_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date > documentation_date THEN
		documentation_date
	WHEN (
		documentation_date IS NOT NULL
		AND problem_onset_date IS NOT NULL)
		AND problem_onset_date = documentation_date THEN
		documentation_date
	END AS diagnosis_date,
	problem_code,
	case when diag_eye = '3' then 2 
		end as eye,
	problem_code
FROM
	madrid2.patient_problem_laterality 
WHERE EXTRACT (year from diagnosis_date) BETWEEN '2013' AND '2018'
	and (
		problem_code ILIKE 'E08.37X1%'
		OR problem_code ILIKE 'E08.37X2%'
		OR problem_code ILIKE 'E08.37X3%'
		OR problem_code ILIKE 'E09.37X1%'
		OR problem_code ILIKE 'E09.37X2%'
		OR problem_code ILIKE 'E09.37X3%'
		OR problem_code ILIKE 'E10.37X1%'
		OR problem_code ILIKE 'E10.37X2%'
		OR problem_code ILIKE 'E10.37X3%'
		OR problem_code ILIKE 'E11.37X1%'
		OR problem_code ILIKE 'E11.37X2%'
		OR problem_code ILIKE 'E11.37X3%'
		OR problem_code ILIKE 'E13.37X1%'
		OR problem_code ILIKE 'E13.37X2%'
		OR problem_code ILIKE 'E13.37X3%'
		OR problem_code ILIKE 'E08.3211%'
		OR problem_code ILIKE 'E08.3212%'
		OR problem_code ILIKE 'E08.3213%'
		OR problem_code ILIKE 'E08.3311%'
		OR problem_code ILIKE 'E08.3312%'
		OR problem_code ILIKE 'E08.3313%'
		OR problem_code ILIKE 'E08.3411%'
		OR problem_code ILIKE 'E08.3412%'
		OR problem_code ILIKE 'E08.3413%'
		OR problem_code ILIKE 'E08.3511%'
		OR problem_code ILIKE 'E08.3512%'
		OR problem_code ILIKE 'E08.3513%'
		OR problem_code ILIKE 'E09.3211%'
		OR problem_code ILIKE 'E09.3212%'
		OR problem_code ILIKE 'E09.3213%'
		OR problem_code ILIKE 'E09.3311%'
		OR problem_code ILIKE 'E09.3312%'
		OR problem_code ILIKE 'E09.3313%'
		OR problem_code ILIKE 'E09.3411%'
		OR problem_code ILIKE 'E09.3412%'
		OR problem_code ILIKE 'E09.3413%'
		OR problem_code ILIKE 'E09.3511%'
		OR problem_code ILIKE 'E09.3512%'
		OR problem_code ILIKE 'E09.3513%'
		OR problem_code ILIKE 'E10.3211%'
		OR problem_code ILIKE 'E10.3212%'
		OR problem_code ILIKE 'E10.3213%'
		OR problem_code ILIKE 'E10.3311%'
		OR problem_code ILIKE 'E10.3312%'
		OR problem_code ILIKE 'E10.3313%'
		OR problem_code ILIKE 'E10.3411%'
		OR problem_code ILIKE 'E10.3412%'
		OR problem_code ILIKE 'E10.3413%'
		OR problem_code ILIKE 'E10.3511%'
		OR problem_code ILIKE 'E10.3512%'
		OR problem_code ILIKE 'E10.3513%'
		OR problem_code ILIKE 'E11.3211%'
		OR problem_code ILIKE 'E11.3212%'
		OR problem_code ILIKE 'E11.3213%'
		OR problem_code ILIKE 'E11.3311%'
		OR problem_code ILIKE 'E11.3312%'
		OR problem_code ILIKE 'E11.3313%'
		OR problem_code ILIKE 'E11.3411%'
		OR problem_code ILIKE 'E11.3412%'
		OR problem_code ILIKE 'E11.3413%'
		OR problem_code ILIKE 'E11.3511%'
		OR problem_code ILIKE 'E11.3512%'
		OR problem_code ILIKE 'E11.3513%'
		OR problem_code ILIKE 'E13.3211%'
		OR problem_code ILIKE 'E13.3212%'
		OR problem_code ILIKE 'E13.3213%'
		OR problem_code ILIKE 'E13.3311%'
		OR problem_code ILIKE 'E13.3312%'
		OR problem_code ILIKE 'E13.3313%'
		OR problem_code ILIKE 'E13.3411%'
		OR problem_code ILIKE 'E13.3412%'
		OR problem_code ILIKE 'E13.3413%'
		OR problem_code ILIKE 'E13.3511%'
		OR problem_code ILIKE 'E13.3512%'
		OR problem_code ILIKE 'E13.3513%')
		and diag_eye = '3');

SELECT * from aao_grants.singh_universe_new;

SELECT count(DISTINCT patient_guid) from aao_grants.singh_universe_new; --720,671 <-- This is the patient count of everyone who has had a diagnosis correlated to the ICD codes between 2013 and 2018.
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.singh_universe_new); --1,237,031



--STEP 2: Add 'index_date' column. Each unique ICD code results in a separate diagnosis.
--The ROWNUMBER window function allows us to take the earliest diagnosis date per eye per patient 
--and allows us to set that as the patient's index date (since diagnoses are eye specific).
--We want to do this because we want only the first diagnosis per patient eye, which is the 
--qualifying event for the patient to enter the cohort (we only need one qualifying event).

--ROW_NUMBER numbers all rows sequentially. 
--OVER clause defines the window or set of rows that the window function operates on
--PARTITION BY patient_guid, eye divides the result set produced by the FROM clause into partitions to which the ROW_NUMBER function is applied (patient_guid + eye).
--ORDER BY clause determines the sequence in which the rows are assigned their unique ROW_NUMBER within a specified partition.

DROP TABLE IF EXISTS aao_grants.singh_universe_index;

CREATE TABLE aao_grants.singh_universe_index AS
SELECT
	*
FROM (
	SELECT
		patient_guid,
		eye,
		problem_code,
		diagnosis_date AS index_date,
		row_number() OVER (PARTITION BY patient_guid, eye ORDER BY diagnosis_date ASC) AS rn
	FROM
		aao_grants.singh_universe_new)
WHERE
	rn = 1;

SELECT * from aao_grants.singh_universe_index;

SELECT count(DISTINCT patient_guid) from aao_grants.singh_universe_index; --720,671
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.singh_universe_index); --1,237,031


--STEP 3: Patients must have no anti-vegf 1 year prior to index date and must have at least one anti-vegf treatment after index date 
--but before study end date (2018-12-31).

	--3a. Anti-Vegf table is updated to aao_team.vegf_madrid2_100720_nocui and left joined to the cohort because
	--we want to account for patients that have had an anti-vegf treatment. When this left join is performed 
	--we retain all the rows from the aao_team.vegf_madrid2_100720_nocui table and fetch the matching rows in the 
	--aao_grants.singh_universe_index table to get us patients that have anti-vegf data. Patients with no anti-vegf
	--treatment get dropped from the cohort.
	
	--3b. We are joining on both the patient_guid and eye columns because we would like data from both columns
	--in both tables since they both have a patient_guid and eye column (we can match data on those columns).
	
	--We want to match on both columns because anti-vegf treatment is eye specific and we want to make sure that we are matching the correct eye to the correct patient.
	--These two columns provide a link between both tables and acts as a cross reference aka foreign key.
	
	--3c. We are accounting for patients that have an anti-vegf injection between 2013 and 2018. 
	
	--3d. This is where we get a significantly large loss in patients because most patients in aao_grants.singh_universe_index 
	--do not have a history anti-vegf treatments. 

--GENERAL NOTE TO SELF: "Study date range" refers to index date. Need to take into account any follow up and lookback period that study specifies to adjust for other dates.
DROP TABLE IF EXISTS aao_grants.singh_universe_join_vegf;

CREATE TABLE aao_grants.singh_universe_join_vegf AS SELECT DISTINCT
	dx.patient_guid,
	dx.index_date,
	pp.procedure_date,
	dx.eye
	/*, pp.vegf_type*/
FROM
	aao_team.vegf_madrid2_100720_nocui pp
	LEFT JOIN aao_grants.singh_universe_index dx ON dx.patient_guid = pp.patient_guid
		AND dx.eye = pp.eye
WHERE
	EXTRACT(
		year FROM procedure_date) BETWEEN '2012'
	AND '2019'; 


SELECT * from aao_grants.singh_universe_join_vegf;

SELECT count(DISTINCT patient_guid) from aao_grants.singh_universe_join_vegf; --223,829 <-- This is the patient count of everyone who has had an anti-vegf treatment in the cohort. 
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.singh_universe_join_vegf); --338,141

--3e. We are removing patients with anti-vegf within 1 year before index date and making sure that
--patients have had their anti-vegf treatments AFTER index date.

DROP TABLE IF EXISTS aao_grants.rpb_singh_universe_remove;

CREATE TABLE aao_grants.rpb_singh_universe_remove AS SELECT DISTINCT
	patient_guid,
	index_date,
	/*procedure_date,*/
	eye
FROM
	aao_grants.singh_universe_join_vegf
WHERE
	patient_guid NOT in(
		SELECT DISTINCT
			patient_guid FROM aao_grants.singh_universe_join_vegf
		WHERE
			procedure_date BETWEEN index_date - interval '365 days'
			AND index_date
);

SELECT * from aao_grants.rpb_singh_universe_remove;

SELECT count(DISTINCT patient_guid) from aao_grants.rpb_singh_universe_remove; --142,902 <-- This is the patient count of everyone who has had an anti-vegf treatment in the cohort after their index date 
--and have removed patients who have had anti-vegf treatment during a one year window prior to their index date.
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.rpb_singh_universe_remove);	--209,895	

--STEP 4: We are getting the age of each patient in the universe at index date.

		--4a. We subtact the year of index_date from year_of_birth.
		--We need to extract the year from index_date (YYYY-MM-DD) to match the date format that
		--year_of_birth (YYYY) is in. SQL cannot perform this function if the formats are different.

		--4b. We are looking for patients that between 18 and 110 years old.
		
		--4c. We are joining aao_grants.rpb_singh_universe_remove to madrid2.patient to get the cohort's 
		--patients' age and yob data. 
		
DROP TABLE IF EXISTS aao_grants.singh_universe_dob;
CREATE TABLE aao_grants.singh_universe_dob AS SELECT DISTINCT
	t.patient_guid,
	p.year_of_birth,
	index_date,
	eye,
	(
		extract(year FROM index_date)) - year_of_birth AS age_at_index
FROM
	aao_grants.rpb_singh_universe_remove t
	LEFT JOIN madrid2.patient p ON t.patient_guid = p.patient_guid
	WHERE
	age_at_index >= '18' ;
 
SELECT * from aao_grants.singh_universe_dob;

SELECT count(DISTINCT patient_guid) from aao_grants.singh_universe_dob; --142,835 <-- This is the patient count of everyone who is 18 years old or older from the anti-vegf table (above).
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.singh_universe_dob); --209,793

--Final inclusion criteria unique patient count: 126,304

--STEP 4: Exclusions (patient level)

		--4a. We want to begin our exclusion section by coding with the ICD codes listed in the SAP exclusion criteria (diagnostic exclusions).
		--We need to get the desired ICD codes from madrid2.patient_problem_laterality and ensure that the patients in 
		--aao_grants.singh_universe_dob are also diagnosed with these exclusion ICD codes in IRIS because these codes 
		--are not in already included in our cohort, and we have to get them from madrid2.patient_problem_laterality.

--Since this is a patient level analysis, we only need patient data and wouldnt make sense to join tables on eye column due to it not being needed.

DROP TABLE IF EXISTS aao_grants.singh_universe_dx_excl;
CREATE TABLE aao_grants.singh_universe_dx_excl AS
SELECT
	patient_guid,
	diag_eye,
	EXTRACT(
		YEAR FROM diagnosis_date) as diagnosis_date,
	index_date
FROM (
	SELECT DISTINCT
		a.patient_guid,
		diag_eye,
		CASE WHEN documentation_date IS NULL THEN
			problem_onset_date
		WHEN problem_onset_date IS NULL THEN
			documentation_date
		WHEN (documentation_date IS NOT NULL
			AND problem_onset_date IS NOT NULL)
			AND problem_onset_date < documentation_date THEN
			problem_onset_date
		WHEN (documentation_date IS NOT NULL
			AND problem_onset_date IS NOT NULL)
			AND problem_onset_date > documentation_date THEN
			documentation_date
		WHEN (documentation_date IS NOT NULL
			AND problem_onset_date IS NOT NULL)
			AND problem_onset_date = documentation_date THEN
			documentation_date
		END AS diagnosis_date,
		EXTRACT(year FROM index_date) AS index_date
	FROM
		aao_grants.singh_universe_dob a
	LEFT JOIN madrid2.patient_problem_laterality b ON a.patient_guid = b.patient_guid
WHERE
	-- Degenerative myopia
	problem_code ILIKE 'H44.2%'
	OR problem_code ILIKE 'H44.20%'
	OR problem_code ILIKE 'H44.21%'
	OR problem_code ILIKE 'H44.22%'
	OR problem_code ILIKE 'H44.23%'
	OR problem_code ILIKE '360.21%'
	OR
	-- Ocular histoplasmosis syndrome
	problem_code ILIKE 'B39.9%'
	OR problem_code ILIKE 'H32%'
	OR problem_code ILIKE '115.02%'
	OR
	-- Angioid streaks
	problem_code ILIKE 'H35.33%'
	OR problem_code ILIKE '363.43%'
	OR
	-- Macular, cyst, hole, or pseudohole
	problem_code ILIKE 'H35.34%'
	OR problem_code ILIKE 'H35.341%'
	OR problem_code ILIKE 'H35.342%'
	OR problem_code ILIKE 'H35.343%'
	OR problem_code ILIKE 'H35.349%'
	OR problem_code ILIKE '362.54%'
	OR
	-- Choroidal Degeneration
	problem_code ILIKE 'H31.1%'
	OR problem_code ILIKE 'H31.10%'
	OR problem_code ILIKE 'H31.11%'
	OR problem_code ILIKE 'H31.12%'
	OR problem_code ILIKE '363.40%'
	OR
	-- Hereditary Choroidal Dystrophy
	problem_code ILIKE 'H31.2%'
	OR problem_code ILIKE 'H31.20%'
	OR problem_code ILIKE 'H31.21%'
	OR problem_code ILIKE 'H31.22%'
	OR problem_code ILIKE 'H31.23%'
	OR problem_code ILIKE 'H31.29%'
	OR problem_code ILIKE '363.50%'
	OR
	-- Choroidal hemorrhage and rupture
	problem_code ILIKE 'H31.3%'
	OR problem_code ILIKE 'H31.30%'
	OR problem_code ILIKE 'H31.302%'
	OR problem_code ILIKE 'H31.303%'
	OR problem_code ILIKE 'H31.309%'
	OR problem_code ILIKE 'H31.311%'
	OR problem_code ILIKE 'H31.312%'
	OR problem_code ILIKE 'H31.313%'
	OR problem_code ILIKE 'H31.319%'
	OR problem_code ILIKE 'H31.321%'
	OR problem_code ILIKE 'H31.322%'
	OR problem_code ILIKE 'H31.323%'
	OR problem_code ILIKE 'H31.329%'
	OR problem_code ILIKE '363.6%'
	OR
	-- Choroidal Detachment
	problem_code ILIKE 'H31.4%'
	OR problem_code ILIKE 'H31.40%'
	OR problem_code ILIKE 'H31.401%'
	OR problem_code ILIKE 'H31.402%'
	OR problem_code ILIKE 'H31.403%'
	OR problem_code ILIKE 'H31.409%'
	OR problem_code ILIKE 'H31.41%'
	OR problem_code ILIKE 'H31.411%'
	OR problem_code ILIKE 'H31.412%'
	OR problem_code ILIKE 'H31.413%'
	OR problem_code ILIKE 'H31.419%'
	OR problem_code ILIKE 'H31.42%'
	OR problem_code ILIKE 'H31.421%'
	OR problem_code ILIKE 'H31.422%'
	OR problem_code ILIKE 'H31.423%'
	OR problem_code ILIKE 'H31.429%'
	OR problem_code ILIKE '363.70%'
	OR
	-- Other unspecified disorders of choroid
	problem_code ILIKE 'H31.8%'
	OR problem_code ILIKE 'H31.9%'
	OR problem_code ILIKE '363.8%'
	OR
	-- Choroidal neovascularization
	problem_code ILIKE '362.16%'
	OR problem_code ILIKE 'H44.2A%'
	OR -- Degenerative myopia with choroidal neovascularization'
	problem_code ILIKE 'H44.2A1%'
	OR -- Degenerative myopia with choroidal neovascularization'
	problem_code ILIKE 'H44.2A2%'
	OR -- Degenerative myopia with choroidal neovascularization'
	problem_code ILIKE 'H44.2A3%'
	OR -- Degenerative myopia with choroidal neovascularization'
	problem_code ILIKE 'H44.2A9%'
	OR -- Degenerative myopia with choroidal neovascularization'
	-- Retinal vein occlusion
	problem_code ILIKE 'H34.811%'
	OR problem_code ILIKE 'H34.812%'
	OR problem_code ILIKE 'H34.813%'
	OR problem_code ILIKE 'H34.819%'
	OR problem_code ILIKE '362.35%'
	OR
	-- Age-related macular degeneration
	problem_code ILIKE '362.50%'
	OR problem_code ILIKE 'H35.30%'
	OR -- Unspecified macular degeneration'
	problem_code ILIKE 'H35.31%'
	OR -- Nonexudative age-related macular degeneration'
	problem_code ILIKE 'H35.311%'
	OR -- Nonexudative age-related macular degeneration'
	problem_code ILIKE 'H35.312%'
	OR -- Nonexudative age-related macular degeneration'
	problem_code ILIKE 'H35.313%'
	OR -- Nonexudative age-related macular degeneration'
	problem_code ILIKE 'H35.319%'
	OR -- Nonexudative age-related macular degeneration'
	problem_code ILIKE 'H35.32%'
	OR -- Exudative age-related macular degeneration'
	problem_code ILIKE 'H35.321%'
	OR -- Exudative age-related macular degeneration'
	problem_code ILIKE 'H35.322%'
	OR -- Exudative age-related macular degeneration'
	problem_code ILIKE 'H35.323%'
	OR -- Exudative age-related macular degeneration'
	problem_code ILIKE 'H35.329%'
	OR -- Exudative age-related macular degeneration'
	-- Toxic maculopathy
	problem_code ILIKE 'H35.38%'
	OR problem_code ILIKE 'H35.381%'
	OR problem_code ILIKE 'H35.382%'
	OR problem_code ILIKE 'H35.383%'
	OR problem_code ILIKE 'H35.389%'
	OR problem_code ILIKE '362.55%'
	OR
	-- Unspecified macular degeneration
	problem_code ILIKE 'H35.30%'
	OR problem_code ILIKE '362.51%'
	OR
	-- Hereditary retinal dystrophy
	problem_code ILIKE 'H35.5%'
	OR problem_code ILIKE 'H35.50%'
	OR problem_code ILIKE 'H35.51%'
	OR problem_code ILIKE 'H35.52%'
	OR problem_code ILIKE 'H35.53%'
	OR problem_code ILIKE 'H35.54%'
	OR problem_code ILIKE '362.70%'
	OR
	-- Separation of retinal layers (central serous chorioretinopathy, serous detachment of retinal pigment epithelium and hemorrhagic detachment of retinal pigment epithelium)
	problem_code ILIKE 'H35.7%'
	OR problem_code ILIKE 'H35.70%'
	OR problem_code ILIKE 'H35.71%'
	OR problem_code ILIKE 'H35.711%'
	OR problem_code ILIKE 'H35.712%'
	OR problem_code ILIKE 'H35.713%'
	OR problem_code ILIKE 'H35.719%'
	OR problem_code ILIKE 'H35.72%'
	OR problem_code ILIKE 'H35.721%'
	OR problem_code ILIKE 'H35.722%'
	OR problem_code ILIKE 'H35.723%'
	OR problem_code ILIKE 'H35.729%'
	OR problem_code ILIKE 'H35.73%'
	OR problem_code ILIKE 'H35.731%'
	OR problem_code ILIKE 'H35.732%'
	OR problem_code ILIKE 'H35.733%'
	OR problem_code ILIKE 'H35.739%'
	OR problem_code ILIKE '362.41%'
	OR problem_code ILIKE '362.42%'
	OR problem_code ILIKE '362.43%'
	OR
	-- Retinitis pigmentosa
	problem_code ILIKE 'H35.52%'
	OR problem_code ILIKE '362.74%'
	OR
	-- Central retinal artery occlusion
	problem_code ILIKE 'H34.1%'
	OR problem_code ILIKE 'H34.10%'
	OR problem_code ILIKE 'H34.11%'
	OR problem_code ILIKE 'H34.12%'
	OR problem_code ILIKE 'H34.13%'
	OR problem_code ILIKE '362.31%'
	OR
	-- Partial retinal artery occlusion
	problem_code ILIKE 'H34.21%'
	OR problem_code ILIKE 'H34.211%'
	OR problem_code ILIKE 'H34.212%'
	OR problem_code ILIKE 'H34.213%'
	OR problem_code ILIKE 'H34.219%'
	OR problem_code ILIKE '362.33%'
	OR
	-- Retinal artery branch occlusion
	problem_code ILIKE 'H34.23%'
	OR problem_code ILIKE 'H34.231%'
	OR problem_code ILIKE 'H34.232%'
	OR problem_code ILIKE 'H34.233%'
	OR problem_code ILIKE 'H34.239%'
	OR problem_code ILIKE '362.32%'
	OR
	-- Venous Engorgement
	problem_code ILIKE 'H34.82%'
	OR problem_code ILIKE 'H34.821%'
	OR problem_code ILIKE 'H34.822%'
	OR problem_code ILIKE 'H34.823%'
	OR problem_code ILIKE 'H34.829%'
	OR problem_code ILIKE '362.37%'
	OR
	-- Iridocyclitis, iritis, uveitis due to:
	problem_code ILIKE 'D86.83%'
	OR -- Sarcoidosis'
	problem_code ILIKE 'A51.43%'
	OR -- Syphilis'
	problem_code ILIKE 'B58.09%'
	OR -- Toxoplasmosis'
	problem_code ILIKE 'A18.54%'
	OR -- Tuberculosis'
	problem_code ILIKE 'A36.89%'
	OR -- Diphtheria'
	problem_code ILIKE 'A54.32%'
	OR -- Gonococcal'
	problem_code ILIKE 'B00.51%'
	OR -- Herpes simplex'
	problem_code ILIKE 'B02.32%'
	OR -- Herpes Zoster'
	-- Focal chorioretinal inflammation - macular or paramacular
	problem_code ILIKE 'H30.04%'
	OR problem_code ILIKE 'H30.041%'
	OR problem_code ILIKE 'H30.042%'
	OR problem_code ILIKE 'H30.043%'
	OR problem_code ILIKE 'H30.049%'
	OR problem_code ILIKE '363.06%'
	OR
	-- Post-traumatic post inflammatory macula scar of posterior pole
	problem_code ILIKE 'H31.01%'
	OR problem_code ILIKE 'H31.011%'
	OR problem_code ILIKE 'H31.012%'
	OR problem_code ILIKE 'H31.013%'
	OR problem_code ILIKE 'H31.019%'
	OR problem_code ILIKE '363.32%'
	OR
	-- Malignant neoplasm of choroid
	problem_code ILIKE 'C69.3%'
	OR problem_code ILIKE 'C69.30%'
	OR problem_code ILIKE 'C69.31%'
	OR problem_code ILIKE 'C69.32%'
	OR problem_code ILIKE '190.6%'
	OR
	-- Malignant neoplasm of retina
	problem_code ILIKE 'C69.20%'
	OR problem_code ILIKE 'C69.21%'
	OR problem_code ILIKE 'C69.22%'
	OR problem_code ILIKE '190.5%')
WHERE
	diagnosis_date < index_date
	and extract(YEAR from diagnosis_date) BETWEEN '2000' and '2018';

SELECT * from aao_grants.singh_universe_dx_excl;

SELECT COUNT(DISTINCT patient_guid) from aao_grants.singh_universe_dx_excl; --16,509 <-- This is the number of patients that qualify for the diagnostic exclusion criteria.


--STEP 5: We want to remove patients who have a history of intraocular surgery within 3 months of encounter (aka index date) 
--this would date back to 2012 since the earliest index date is in 2013 (procedure exclusions).
--We need to get the desired procedure codes from madrid2.patient_procedure_laterality and ensure that the patients in
--aao_grants.singh_universe_dob are also diagnosed with these exclusion procedure codes in IRIS because these codes
--are not in already included in our cohort, and we have to get them from madrid2.patient_procedure_laterality.

DROP TABLE IF EXISTS aao_grants.singh_universe_excl_proc;
CREATE TABLE aao_grants.singh_universe_excl_proc AS SELECT DISTINCT
	u.patient_guid,
	proc_eye,
	EXTRACT(YEAR from procedure_date) as procedure_date,
	EXTRACT(YEAR from index_date) as index_date
FROM
	aao_grants.singh_universe_dob u
	LEFT JOIN madrid2.patient_procedure_laterality l ON u.patient_guid = l.patient_guid
WHERE abs(
		procedure_date - u.index_date) BETWEEN 0 AND 90
		and extract(YEAR from procedure_date) BETWEEN '2012' and '2018' 
	and(
		-- History of intraocular surgery within 3 months of encounter
		procedure_code ILIKE '67108%'
		OR -- Vitrectomy'
		procedure_code ILIKE '67036%'
		OR -- Vitrectomy'
		procedure_code ILIKE '67121%'
		OR -- Vitrectomy'
		procedure_code ILIKE '65710%'
		OR -- Corneal transplant'
		procedure_code ILIKE '65730%'
		OR -- Corneal transplant'
		procedure_code ILIKE '65750%'
		OR -- Corneal transplant'
		procedure_code ILIKE '65755%'
		OR -- Corneal transplant'
		procedure_code ILIKE '0474T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '66183%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '0191T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '0253T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '0449T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '+0450T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '+0376T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '67107%'
		OR -- Scleral buckle'
		procedure_code ILIKE '0450T%'
		OR -- Glaucoma surgery'
		procedure_code ILIKE '0376T%'
		-- Glaucoma surgery
		and procedure_date < index_date
);

SELECT * from aao_grants.singh_universe_excl_proc;

SELECT COUNT(DISTINCT patient_guid) from aao_grants.singh_universe_excl_proc; --1,068 <-- This is the number of patients that qualify for the procedure exclusion criteria.


--STEP 6: We want to exclude patients that died within 365 days (1 year) of receiving first anti-VEGF treatment.
		--We need to join our cohort to aao_team.vegf_madrid2_100720_nocui to get anti-vegf injection data 
		--and to madrid2.patient to get death data (1 = patient has died / 0 = patient is alive).
		--ROWNUMBER is getting the patient's first anti-vegf procedure date.

--These left joins are matching patients in our cohort to anti-vegf and death data if they have it. If they dont, they get dropped.
DROP TABLE IF EXISTS aao_grants.singh_universe_excl_died_new;
CREATE TABLE aao_grants.singh_universe_excl_died_new AS
SELECT
	patient_guid,
	extract (year from procedure_date) as procedure_date,
	year_of_death
FROM (
	SELECT DISTINCT a.patient_guid,
	year_of_death,
	procedure_date,
	a.eye,
	ROW_NUMBER() OVER (PARTITION BY a.patient_guid, a.eye ORDER BY procedure_date ASC) AS rn
	FROM
		 aao_grants.singh_universe_dob a
	LEFT JOIN aao_team.vegf_madrid2_100720_nocui b ON a.patient_guid = b.patient_guid
	LEFT JOIN madrid2.patient c ON b.patient_guid = c.patient_guid
WHERE year_of_death BETWEEN procedure_date 
			AND procedure_date + interval '365 days'
	AND is_deceased = '1'
	AND extract(YEAR from procedure_date) BETWEEN '2013' and '2019'
	)
WHERE
	rn = '1';


SELECT * FROM aao_grants.singh_universe_excl_died_new;

SELECT count(distinct patient_guid) FROM aao_grants.singh_universe_excl_died_new; --706 <-- This is the number of patients that have died 1 year after receiving an anti-vegf treatment.


--STEP 7: We want to create our full initial patient universe (cohort) by combining (UNION) the three exclusion datasets 
--that we have created. We do this by querying our final inclusion cohort (aao_grants.singh_universe_dob) and exclude 
--the union exclusion dataset with the NOT IN function under the WHERE clause. 
--We want to do this step to make sure that the patients that qualify for the exclusion criteria are not included in our complete initial cohort.
			
--Final universe

DROP TABLE IF EXISTS aao_grants.rpb_singh_universe_new;

CREATE TABLE aao_grants.rpb_singh_universe_new AS SELECT DISTINCT
	patient_guid,
	eye,
	scramble_guids (
		patient_guid) AS uniquepatientuid,
	index_date
FROM
	aao_grants.singh_universe_dob
WHERE
	patient_guid NOT in(
		SELECT
			patient_guid FROM aao_grants.singh_universe_dx_excl
		UNION
		SELECT
			patient_guid FROM aao_grants.singh_universe_excl_proc
		UNION
		SELECT
			patient_guid FROM aao_grants.singh_universe_excl_died_new
);

SELECT * from aao_grants.rpb_singh_universe_new;

SELECT count(distinct patient_guid) FROM aao_grants.rpb_singh_universe_new; --124,826
SELECT count(*) from (SELECT DISTINCT patient_guid, eye from aao_grants.rpb_singh_universe_new); --185,145 


--Complete intial unique patient count: 124,826

