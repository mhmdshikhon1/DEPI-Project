CREATE EXTERNAL TABLE samhsa_master_db.nsduh_fact_raw (
  ANALWT2_C1 double,
  YEAR bigint,
  AGE3 bigint,
  CATAGE bigint,
  IRSEX bigint,
  NEWRACE2 bigint,
  EDUHIGHCAT bigint,
  IRWRKSTAT bigint,
  IRPINC3 bigint,
  PDEN10 bigint,
  POVERTY3 double,
  HEALTH2 double,
  AMDEYR double,
  KSSLR6YR double,
  IRSUICTHNK double,
  ALCYR bigint,
  CIGYR bigint,
  MRJYR bigint,
  PYUD5ALC double,
  PYUD5MRJ double,
  MHTNSEEKPY double
)
STORED AS PARQUET
LOCATION 's3://samhsa-datalake-2021-2023-depi/nsduh_data/';


-------------------------------------------------------------------------
CREATE VIEW samhsa_master_db.nsduh_decoded_view AS
SELECT 
    ANALWT2_C1 AS Survey_Weight,
    YEAR AS Survey_Year,
    
    -- 1. Detailed Age Groups (AGE3)
    CASE 
        WHEN AGE3 = 1 THEN '12 or 13 years old'
        WHEN AGE3 = 2 THEN '14 or 15 years old'
        WHEN AGE3 = 3 THEN '16 or 17 years old'
        WHEN AGE3 = 4 THEN '18 to 20 years old'
        WHEN AGE3 = 5 THEN '21 to 23 years old'
        WHEN AGE3 = 6 THEN '24 or 25 years old'
        WHEN AGE3 = 7 THEN '26 to 29 years old'
        WHEN AGE3 = 8 THEN '30 to 34 years old'
        WHEN AGE3 = 9 THEN '35 to 49 years old'
        WHEN AGE3 = 10 THEN '50 to 64 years old'
        WHEN AGE3 = 11 THEN '65 years old or older'
        ELSE 'Unknown'
    END AS Detailed_Age_Group,

    -- 2. Broad Age Category (CATAGE)
    CASE 
        WHEN CATAGE = 1 THEN '12-17 Years Old'
        WHEN CATAGE = 2 THEN '18-25 Years Old'
        WHEN CATAGE = 3 THEN '26-34 Years Old'
        WHEN CATAGE = 4 THEN '35 or Older'
        ELSE 'Unknown'
    END AS Age_Category,
    
    -- 3. Respondent Sex (IRSEX)
    CASE 
        WHEN IRSEX = 1 THEN 'Male'
        WHEN IRSEX = 2 THEN 'Female'
        ELSE 'Unknown'
    END AS Gender,

    -- 4. Race / Ethnicity Recode (NEWRACE2)
    CASE 
        WHEN NEWRACE2 = 1 THEN 'Non-Hispanic White'
        WHEN NEWRACE2 = 2 THEN 'Black / African American'
        WHEN NEWRACE2 = 3 THEN 'Non-Hispanic Native American / Alaska Native'
        WHEN NEWRACE2 = 4 THEN 'Non-Hispanic Native Hawaiian / Other Pacific Islander'
        WHEN NEWRACE2 = 5 THEN 'Non-Hispanic Asian'
        WHEN NEWRACE2 = 6 THEN 'Non-Hispanic More Than One Race'
        WHEN NEWRACE2 = 7 THEN 'Hispanic'
        ELSE 'Unknown'
    END AS Race_Ethnicity,

    -- 5. Highest Education Level Category (EDUHIGHCAT)
    CASE 
        WHEN EDUHIGHCAT = 1 THEN 'Less than high school'
        WHEN EDUHIGHCAT = 2 THEN 'High school graduate'
        WHEN EDUHIGHCAT = 3 THEN 'Some college / Associate degree'
        WHEN EDUHIGHCAT = 4 THEN 'College graduate'
        WHEN EDUHIGHCAT = 5 THEN 'Youth aged 12 to 17'
        ELSE 'Unknown'
    END AS Education_Level,

    -- 6. Employment Status (IRWRKSTAT)
    CASE 
        WHEN IRWRKSTAT = 1 THEN 'Employed full time'
        WHEN IRWRKSTAT = 2 THEN 'Employed part time'
        WHEN IRWRKSTAT = 3 THEN 'Unemployed'
        WHEN IRWRKSTAT = 4 THEN 'Other (including not in labor force)'
        WHEN IRWRKSTAT = 99 THEN 'Youth aged 12 to 14'
        ELSE 'Unknown'
    END AS Employment_Status,

    -- 7. Personal Income Category (IRPINC3)
    CASE 
        WHEN IRPINC3 = 1 THEN 'Less than $10,000'
        WHEN IRPINC3 = 2 THEN '$10,000 - $19,999'
        WHEN IRPINC3 = 3 THEN '$20,000 - $29,999'
        WHEN IRPINC3 = 4 THEN '$30,000 - $39,999'
        WHEN IRPINC3 = 5 THEN '$40,000 - $49,999'
        WHEN IRPINC3 = 6 THEN '$50,000 - $74,999'
        WHEN IRPINC3 = 7 THEN '$75,000 or more'
        ELSE 'Unknown'
    END AS Personal_Income,

    -- 8. Population Density / Urbanicity (PDEN10)
    CASE 
        WHEN PDEN10 = 1 THEN 'Segment in CBSA with 1 million or more persons'
        WHEN PDEN10 = 2 THEN 'Segment in CBSA with fewer than 1 million persons'
        WHEN PDEN10 = 3 THEN 'Segment not in CBSA'
        ELSE 'Unknown'
    END AS Population_Density,

    -- 9. Poverty Status relative to Federal Threshold (POVERTY3)
    CASE 
        WHEN CAST(POVERTY3 AS INT) = 1 THEN 'Living in Poverty'
        WHEN CAST(POVERTY3 AS INT) = 2 THEN 'Income Up to 2X Federal Poverty Threshold'
        WHEN CAST(POVERTY3 AS INT) = 3 THEN 'Income More Than 2X Federal Poverty Threshold'
        ELSE 'Unknown'
    END AS Poverty_Status,

    -- 10. Self-Rated Overall Health Status (HEALTH2)
    CASE 
        WHEN CAST(HEALTH2 AS INT) = 1 THEN 'Excellent'
        WHEN CAST(HEALTH2 AS INT) = 2 THEN 'Very Good'
        WHEN CAST(HEALTH2 AS INT) = 3 THEN 'Good'
        WHEN CAST(HEALTH2 AS INT) = 4 THEN 'Fair / Poor'
        ELSE 'Unknown'
    END AS Overall_Health,

    -- 11. Major Depressive Episode in Past Year (AMDEYR)
    CASE 
        WHEN CAST(AMDEYR AS INT) = 1 THEN 'Yes'
        WHEN CAST(AMDEYR AS INT) = 2 THEN 'No'
        ELSE 'Unknown'
    END AS Past_Year_Depressive_Episode,

    -- 12. Kessler-6 Psychological Distress Score (KSSLR6YR)
    KSSLR6YR AS Kessler6_Distress_Score,

    -- 13. Serious Suicidal Thoughts in Past Year (IRSUICTHNK)
    CASE 
        WHEN CAST(IRSUICTHNK AS INT) = 1 THEN 'Yes'
        WHEN CAST(IRSUICTHNK AS INT) = 0 THEN 'No'
        WHEN IRSUICTHNK IS NULL OR TRIM(CAST(IRSUICTHNK AS VARCHAR)) = '.' THEN 'Aged 12-17'
        ELSE 'Unknown'
    END AS Past_Year_Suicidal_Thoughts,

    -- 14. Alcohol Use in Past Year (ALCYR)
    CASE 
        WHEN ALCYR = 1 THEN 'Used in past year'
        WHEN ALCYR = 0 THEN 'Did not use in past year / Never used'
        WHEN ALCYR = 2 THEN 'Did not use in past year (Used previously)'
        ELSE 'Unknown'
    END AS Past_Year_Alcohol_Use,

    -- 15. Cigarette Use in Past Year (CIGYR)
    CASE 
        WHEN CIGYR = 1 THEN 'Used in past year'
        WHEN CIGYR = 0 THEN 'Did not use in past year / Never used'
        WHEN CIGYR = 2 THEN 'Did not use in past year (Used previously)'
        ELSE 'Unknown'
    END AS Past_Year_Cigarette_Use,

    -- 16. Marijuana Use in Past Year (MRJYR)
    CASE 
        WHEN MRJYR = 1 THEN 'Used in past year'
        WHEN MRJYR = 0 THEN 'Did not use in past year / Never used'
        WHEN MRJYR = 2 THEN 'Did not use in past year (Used previously)'
        ELSE 'Unknown'
    END AS Past_Year_Marijuana_Use,

    -- 17. DSM-5 Alcohol Use Disorder (PYUD5ALC)
    CASE 
        WHEN CAST(PYUD5ALC AS INT) = 1 THEN 'Yes (Has Alcohol Use Disorder)'
        WHEN CAST(PYUD5ALC AS INT) = 2 THEN 'No (Alcohol User without Disorder)'
        WHEN CAST(PYUD5ALC AS INT) = 0 THEN 'No Disorder (Not Evaluated/Skip)'
        WHEN CAST(PYUD5ALC AS INT) = 91 THEN 'Never Used Alcohol'
        WHEN CAST(PYUD5ALC AS INT) = 93 THEN 'Did Not Use Alcohol Past Year'
        ELSE 'Unknown'
    END AS Alcohol_Use_Disorder,

    -- 18. DSM-5 Marijuana Use Disorder (PYUD5MRJ)
    CASE 
        WHEN CAST(PYUD5MRJ AS INT) = 1 THEN 'Yes (Has Marijuana Use Disorder)'
        WHEN CAST(PYUD5MRJ AS INT) = 2 THEN 'No (Marijuana User without Disorder)'
        WHEN CAST(PYUD5MRJ AS INT) = 0 THEN 'No Disorder (Not Evaluated/Skip)'
        WHEN CAST(PYUD5MRJ AS INT) = 91 THEN 'Never Used Marijuana'
        WHEN CAST(PYUD5MRJ AS INT) = 93 THEN 'Did Not Use Marijuana Past Year'
        ELSE 'Unknown'
    END AS Marijuana_Use_Disorder,

    -- 19. Sought Mental Health Treatment in Past Year (MHTNSEEKPY)
    CASE 
        WHEN CAST(MHTNSEEKPY AS INT) = 1 THEN 'Yes'
        WHEN CAST(MHTNSEEKPY AS INT) = 2 THEN 'No'
        ELSE 'Unknown'
    END AS Sought_Mental_Health_Treatment

FROM samhsa_master_db.nsduh_fact_raw;