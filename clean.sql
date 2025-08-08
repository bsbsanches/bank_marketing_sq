DROP VIEW IF EXISTS bank_clean;

CREATE VIEW bank_clean AS
SELECT
    age,
    NULLIF(job, 'unknown')      AS job,
    NULLIF(marital, 'unknown')  AS marital,
    NULLIF(education, 'unknown')AS education,
    NULLIF("default", 'unknown')AS "default",
    balance,
    NULLIF(housing, 'unknown')  AS housing,
    NULLIF(loan, 'unknown')     AS loan,
    contact,
    day,
    month,
    duration,
    campaign,
    pdays,
    previous,
    poutcome,
    CASE WHEN y IN ('yes','y','1') THEN 1
         WHEN y IN ('no','n','0')  THEN 0
         ELSE NULL END AS y_flag
FROM bank_marketing;
