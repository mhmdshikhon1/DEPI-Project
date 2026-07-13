CREATE EXTERNAL TABLE IF NOT EXISTS samhsa_master_db.mh_cld_fact_raw (
  YEAR bigint,
  CASEID bigint,
  STATEFIP bigint,
  AGE bigint,
  SEX bigint,
  RACE bigint,
  ETHNIC bigint,
  EDUC bigint,
  MARSTAT bigint,
  EMPLOY bigint,
  LIVARAG bigint,
  VETERAN bigint,
  SMISED bigint,
  MH1 bigint,
  MH2 bigint,
  SUB bigint,
  SPHSERVICE bigint,
  CMPSERVICE bigint,
  OPISERVICE bigint,
  RTCSERVICE bigint
)
STORED AS PARQUET
LOCATION 's3://samhsa-datalake-2021-2023-depi/mh_cld_data/';


-----------------------------------------------------------------
CREATE OR REPLACE VIEW samhsa_master_db.mh_cld_decoded_view AS
SELECT 
    YEAR,
    CASEID,
    
    -- 1. Decoding Geography (STATEFIP - Full US States Mapping)
    CASE 
        WHEN STATEFIP = 1 THEN 'Alabama'
        WHEN STATEFIP = 2 THEN 'Alaska'
        WHEN STATEFIP = 4 THEN 'Arizona'
        WHEN STATEFIP = 5 THEN 'Arkansas'
        WHEN STATEFIP = 6 THEN 'California'
        WHEN STATEFIP = 8 THEN 'Colorado'
        WHEN STATEFIP = 9 THEN 'Connecticut'
        WHEN STATEFIP = 10 THEN 'Delaware'
        WHEN STATEFIP = 11 THEN 'District of Columbia'
        WHEN STATEFIP = 12 THEN 'Florida'
        WHEN STATEFIP = 13 THEN 'Georgia'
        WHEN STATEFIP = 15 THEN 'Hawaii'
        WHEN STATEFIP = 16 THEN 'Idaho'
        WHEN STATEFIP = 17 THEN 'Illinois'
        WHEN STATEFIP = 18 THEN 'Indiana'
        WHEN STATEFIP = 19 THEN 'Iowa'
        WHEN STATEFIP = 20 THEN 'Kansas'
        WHEN STATEFIP = 21 THEN 'Kentucky'
        WHEN STATEFIP = 22 THEN 'Louisiana'
        WHEN STATEFIP = 23 THEN 'Maine'
        WHEN STATEFIP = 24 THEN 'Maryland'
        WHEN STATEFIP = 25 THEN 'Massachusetts'
        WHEN STATEFIP = 26 THEN 'Michigan'
        WHEN STATEFIP = 27 THEN 'Minnesota'
        WHEN STATEFIP = 28 THEN 'Mississippi'
        WHEN STATEFIP = 29 THEN 'Missouri'
        WHEN STATEFIP = 30 THEN 'Montana'
        WHEN STATEFIP = 31 THEN 'Nebraska'
        WHEN STATEFIP = 32 THEN 'Nevada'
        WHEN STATEFIP = 33 THEN 'New Hampshire'
        WHEN STATEFIP = 34 THEN 'New Jersey'
        WHEN STATEFIP = 35 THEN 'New Mexico'
        WHEN STATEFIP = 36 THEN 'New York'
        WHEN STATEFIP = 37 THEN 'North Carolina'
        WHEN STATEFIP = 38 THEN 'North Dakota'
        WHEN STATEFIP = 39 THEN 'Ohio'
        WHEN STATEFIP = 40 THEN 'Oklahoma'
        WHEN STATEFIP = 41 THEN 'Oregon'
        WHEN STATEFIP = 42 THEN 'Pennsylvania'
        WHEN STATEFIP = 44 THEN 'Rhode Island'
        WHEN STATEFIP = 45 THEN 'South Carolina'
        WHEN STATEFIP = 46 THEN 'South Dakota'
        WHEN STATEFIP = 47 THEN 'Tennessee'
        WHEN STATEFIP = 48 THEN 'Texas'
        WHEN STATEFIP = 49 THEN 'Utah'
        WHEN STATEFIP = 50 THEN 'Vermont'
        WHEN STATEFIP = 51 THEN 'Virginia'
        WHEN STATEFIP = 53 THEN 'Washington'
        WHEN STATEFIP = 54 THEN 'West Virginia'
        WHEN STATEFIP = 55 THEN 'Wisconsin'
        WHEN STATEFIP = 56 THEN 'Wyoming'
        WHEN STATEFIP = 72 THEN 'Puerto Rico'
        WHEN STATEFIP = 99 THEN 'Other Jurisdictions'
        ELSE 'Unknown State'
    END AS State_Name,

    -- 2. Decoding Demographics: Age Groups (AGE)
    CASE 
        WHEN AGE = 1 THEN '0-11 years'
        WHEN AGE = 2 THEN '12-14 years'
        WHEN AGE = 3 THEN '15-17 years'
        WHEN AGE = 4 THEN '18-24 years'
        WHEN AGE = 5 THEN '25-34 years'
        WHEN AGE = 6 THEN '35-44 years'
        WHEN AGE = 7 THEN '45-54 years'
        WHEN AGE = 8 THEN '55-64 years'
        WHEN AGE = 9 THEN '65 years and over'
        ELSE 'Unknown/Missing'
    END AS Age_Group,
    
    -- 3. Decoding Demographics: Sex (SEX)
    CASE 
        WHEN SEX = 1 THEN 'Male'
        WHEN SEX = 2 THEN 'Female'
        ELSE 'Unknown/Missing'
    END AS Gender,

    -- 4. Decoding Demographics: Race (RACE)
    CASE 
        WHEN RACE = 1 THEN 'American Indian or Alaska Native'
        WHEN RACE = 2 THEN 'Asian'
        WHEN RACE = 3 THEN 'Black or African American'
        WHEN RACE = 4 THEN 'Native Hawaiian or Other Pacific Islander'
        WHEN RACE = 5 THEN 'White'
        WHEN RACE = 6 THEN 'Some other race / Multi-race'
        ELSE 'Unknown/Missing'
    END AS Race_Category,

    -- 5. Decoding Demographics: Ethnicity (ETHNIC)
    CASE 
        WHEN ETHNIC = 1 THEN 'Mexican'
        WHEN ETHNIC = 2 THEN 'Puerto Rican'
        WHEN ETHNIC = 3 THEN 'Other Hispanic or Latino'
        WHEN ETHNIC = 4 THEN 'Not Hispanic or Latino'
        ELSE 'Unknown/Missing'
    END AS Ethnicity,

    -- 6. Decoding Social Determinants: Education (EDUC)
    CASE 
        WHEN EDUC = 1 THEN 'No Schooling / Pre-K to 8th Grade'
        WHEN EDUC = 2 THEN '9th to 11th Grade'
        WHEN EDUC = 3 THEN '12th Grade / High School Diploma / GED'
        WHEN EDUC = 4 THEN 'Some College / Vocational School'
        WHEN EDUC = 5 THEN 'College Graduate / Advanced Degree'
        ELSE 'Unknown/Missing'
    END AS Education_Level,

    -- 7. Decoding Social Determinants: Marital Status (MARSTAT)
    CASE 
        WHEN MARSTAT = 1 THEN 'Never Married'
        WHEN MARSTAT = 2 THEN 'Now Married'
        WHEN MARSTAT = 3 THEN 'Separated'
        WHEN MARSTAT = 4 THEN 'Divorced / Widowed'
        ELSE 'Unknown/Missing'
    END AS Marital_Status,

    -- 8. Decoding Social Determinants: Employment Status (EMPLOY)
    CASE 
        WHEN EMPLOY = 1 THEN 'Full-time Employed'
        WHEN EMPLOY = 2 THEN 'Part-time Employed'
        WHEN EMPLOY = 3 THEN 'Other Employed'
        WHEN EMPLOY = 4 THEN 'Unemployed'
        WHEN EMPLOY = 5 THEN 'Not in Labor Force'
        ELSE 'Unknown/Missing'
    END AS Employment_Status,

    -- 9. Decoding Social Determinants: Living Arrangements (LIVARAG)
    CASE 
        WHEN LIVARAG = 1 THEN 'Homeless'
        WHEN LIVARAG = 2 THEN 'Private Residence'
        WHEN LIVARAG = 3 THEN 'Institutional / Group Home'
        ELSE 'Unknown/Missing'
    END AS Living_Arrangement,

    -- 10. Decoding Social Determinants: Veteran Status (VETERAN)
    CASE 
        WHEN VETERAN = 1 THEN 'Veteran'
        WHEN VETERAN = 2 THEN 'Non-Veteran'
        ELSE 'Unknown/Missing'
    END AS Veteran_Status,

    -- 11. Decoding Clinical Data: Serious Mental Illness Status (SMISED)
    CASE 
        WHEN SMISED = 1 THEN 'SMI (Serious Mental Illness)'
        WHEN SMISED = 2 THEN 'SED (Serious Emotional Disturbance)'
        WHEN SMISED = 3 THEN 'Both SMI and SED'
        WHEN SMISED = 4 THEN 'Not SMI or SED'
        ELSE 'Unknown/Missing'
    END AS Mental_Health_Status,

    -- 12. Decoding Clinical Data: Primary Diagnosis (MH1)
    CASE 
        WHEN MH1 = 1 THEN 'Trauma-related disorder'
        WHEN MH1 = 2 THEN 'Anxiety disorder'
        WHEN MH1 = 3 THEN 'ADHD'
        WHEN MH1 = 4 THEN 'Conduct disorder'
        WHEN MH1 = 5 THEN 'Delirium/Dementia disorder'
        WHEN MH1 = 6 THEN 'Bipolar disorder'
        WHEN MH1 = 7 THEN 'Depressive disorder'
        WHEN MH1 = 8 THEN 'Oppositional defiant disorder'
        WHEN MH1 = 9 THEN 'Pervasive developmental disorder'
        WHEN MH1 = 10 THEN 'Personality disorder'
        WHEN MH1 = 11 THEN 'Schizophrenia / Psychotic disorder'
        WHEN MH1 = 12 THEN 'Alcohol or substance use disorder'
        WHEN MH1 = 13 THEN 'Other disorders/conditions'
        ELSE 'Unknown/Missing'
    END AS Primary_Diagnosis,

    -- 13. Decoding Clinical Data: Secondary Diagnosis (MH2)
    CASE 
        WHEN MH2 = 1 THEN 'Trauma-related disorder'
        WHEN MH2 = 2 THEN 'Anxiety disorder'
        WHEN MH2 = 3 THEN 'ADHD'
        WHEN MH2 = 4 THEN 'Conduct disorder'
        WHEN MH2 = 5 THEN 'Delirium/Dementia disorder'
        WHEN MH2 = 6 THEN 'Bipolar disorder'
        WHEN MH2 = 7 THEN 'Depressive disorder'
        WHEN MH2 = 8 THEN 'Oppositional defiant disorder'
        WHEN MH2 = 9 THEN 'Pervasive developmental disorder'
        WHEN MH2 = 10 THEN 'Personality disorder'
        WHEN MH2 = 11 THEN 'Schizophrenia / Psychotic disorder'
        WHEN MH2 = 12 THEN 'Alcohol or substance use disorder'
        WHEN MH2 = 13 THEN 'Other disorders/conditions'
        ELSE 'No Secondary Diagnosis / Missing'
    END AS Secondary_Diagnosis,

    -- 14. Decoding Clinical Data: Co-occurring Substance Use Problem (SUB)
    CASE 
        WHEN SUB = 1 THEN 'Alcohol use only'
        WHEN SUB = 2 THEN 'Drug use only'
        WHEN SUB = 3 THEN 'Both alcohol and drug use'
        WHEN SUB = 4 THEN 'No substance use problem'
        ELSE 'Unknown/Missing'
    END AS Substance_Use_Problem,

    -- 15. Decoding Service Settings (Transformed to Served / Not served for optimized BI visuals)
    CASE WHEN SPHSERVICE = 1 THEN 'Served' WHEN SPHSERVICE = 2 THEN 'Not served' ELSE NULL END AS State_Psychiatric_Hospital,
    CASE WHEN CMPSERVICE = 1 THEN 'Served' WHEN CMPSERVICE = 2 THEN 'Not served' ELSE NULL END AS Community_Mental_Health_Center,
    CASE WHEN OPISERVICE = 1 THEN 'Served' WHEN OPISERVICE = 2 THEN 'Not served' ELSE NULL END AS Other_Outpatient_Facility,
    CASE WHEN RTCSERVICE = 1 THEN 'Served' WHEN RTCSERVICE = 2 THEN 'Not served' ELSE NULL END AS Residential_Treatment_Center

FROM samhsa_master_db.mh_cld_fact_raw;