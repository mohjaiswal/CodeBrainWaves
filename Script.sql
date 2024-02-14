-- SQL Syntax for Data Cleaning and Manipulation using TRSM Bootcamp's Database for SQL Challenge


-- Retrieve All Columns from the Age and the rest of the tables. 

SELECT * FROM Age;
SELECT * FROM Gender ;
SELECT * FROM Location ;


-- Count Surveyed Older Than 25

SELECT COUNT(*) FROM Age WHERE CAST(Age AS INTEGER) > 25;

-- Survey Count by Gender

SELECT Gender, COUNT(*) AS Count FROM Gender GROUP BY Gender;

-- Count 'NA' in Self Employed Column

SELECT COUNT(*) FROM MH_survey WHERE self_employed = 'NA';

-- Count of Males Who Received Treatment

SELECT * FROM MH_survey ;
SELECT treatment, COUNT(*) AS Count FROM MH_survey   GROUP BY treatment ;

SELECT COUNT(*) FROM MH_Survey 
JOIN Gender ON MH_Survey.SurveyID = Gender.SurveyID 
WHERE Gender.Gender = 'Male' AND MH_Survey.treatment = 'Yes';

-- Survey Details of Males Doing Remote Work from the US

SELECT * FROM Location ;
SELECT Country, COUNT(*) AS Count FROM Location  GROUP BY Country ;

SELECT * FROM MH_Survey 
JOIN Location ON MH_Survey.SurveyID = Location.SurveyID 
WHERE Location.Country  = 'United States' AND MH_Survey.remote_work  = 'Yes';

-- Count of Females (Cis and Trans Included using IN function) with Mental Health history residing in Canada

SELECT COUNT(*) FROM MH_Survey 
JOIN Gender ON MH_Survey.SurveyID = Gender.SurveyID
JOIN Location ON MH_Survey.SurveyID = Location.SurveyID
WHERE Location.Country  = 'Canada' AND MH_Survey.family_history = 'Yes' AND Gender.Gender IN ('Female','Female (cis)','Female (trans)', 'Cis Female', 'cis-female/femme');

-- Count of Females Over 40 in Tech with Frequent Work Interference

SELECT COUNT(*) FROM MH_Survey 
JOIN Gender ON MH_Survey.SurveyID = Gender.SurveyID
JOIN Age ON MH_Survey.SurveyID = Age.SurveyID
WHERE CAST(Age.Age AS INTEGER) > 40 AND MH_Survey.work_interfere  = 'Often' AND MH_Survey.tech_company = 'Yes' AND Gender.Gender IN ('Female','Female (cis)','Female (trans)', 'Cis Female', 'cis-female/femme');

-- View of Survey Details of people who are 30 or under

CREATE VIEW PeopleThirtyOrBelow AS
SELECT MH_Survey.*, Age.Age, Gender.Gender, Location.Country, Location.state
FROM MH_Survey
JOIN Age ON MH_Survey.SurveyID = Age.SurveyID
JOIN Gender ON MH_Survey.SurveyID = Gender.SurveyID
JOIN Location ON MH_Survey.SurveyID = Location.SurveyID
WHERE CAST(Age.Age AS INTEGER) <= 30;

SELECT * FROM PeopleThirtyOrBelow;

-- How many people have seeked help with anonymity for age groups = < 25; 26 to 49, and >50?

SELECT
  SUM(CASE WHEN CAST(Age.Age AS INTEGER) <= 25 THEN 1 ELSE 0 END) AS Under25,
  SUM(CASE WHEN CAST(Age.Age AS INTEGER) BETWEEN 26 AND 49 THEN 1 ELSE 0 END) AS Between26And49,
  SUM(CASE WHEN CAST(Age.Age AS INTEGER) >= 50 THEN 1 ELSE 0 END) AS Over50
FROM MH_Survey
JOIN Age ON MH_Survey.SurveyID = Age.SurveyID
WHERE MH_Survey.anonymity = 'Yes';

--- Making ER Diagram
DROP TABLE IF EXISTS AgeERD;
DROP TABLE IF EXISTS GenderERD;
DROP TABLE IF EXISTS LocationERD;
DROP TABLE IF EXISTS MH_SurveyERD;

CREATE TABLE MH_SurveyERD (
    SurveyID INTEGER PRIMARY KEY,
    Timestamp VARCHAR,
    self_employed VARCHAR,
    family_history VARCHAR,
    treatment VARCHAR,
    work_interfere VARCHAR,
    no_employees VARCHAR,
    remote_work VARCHAR,
    tech_company VARCHAR,
    benefits VARCHAR,
    care_options VARCHAR,
    wellness_program VARCHAR,
    seek_help VARCHAR,
    anonymity VARCHAR,
    leave VARCHAR,
    mental_health_consequence VARCHAR,
    phys_health_consequence VARCHAR,
    coworkers VARCHAR,
    supervisor VARCHAR,
    mental_health_interview VARCHAR,
    phys_health_interview VARCHAR,
    mental_vs_physical VARCHAR,
    obs_consequence VARCHAR,
    comments VARCHAR
);

CREATE TABLE AgeERD (
    SurveyID INTEGER,
    Age VARCHAR,
    PRIMARY KEY (SurveyID),
    FOREIGN KEY (SurveyID) REFERENCES MH_SurveyERD(SurveyID)
);

CREATE TABLE GenderERD (
    SurveyID INTEGER,
    Gender VARCHAR,
    PRIMARY KEY (SurveyID),
    FOREIGN KEY (SurveyID) REFERENCES MH_SurveyERD(SurveyID)
);

CREATE TABLE LocationERD (
    SurveyID INTEGER,
    Country VARCHAR,
    State VARCHAR,
    PRIMARY KEY (SurveyID),
    FOREIGN KEY (SurveyID) REFERENCES MH_SurveyERD(SurveyID)
);



