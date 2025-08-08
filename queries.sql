-- 1) Conversão global
SELECT 
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean;

-- 2) Conversão por canal de contato
SELECT 
  contact,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean
GROUP BY contact
ORDER BY taxa_conversao_pct DESC;

-- 3) Conversão por mês (ordem cronológica)
SELECT 
  month,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean
GROUP BY month
ORDER BY 
  CASE month
    WHEN 'jan' THEN 1 WHEN 'feb' THEN 2 WHEN 'mar' THEN 3 WHEN 'apr' THEN 4
    WHEN 'may' THEN 5 WHEN 'jun' THEN 6 WHEN 'jul' THEN 7 WHEN 'aug' THEN 8
    WHEN 'sep' THEN 9 WHEN 'oct' THEN 10 WHEN 'nov' THEN 11 WHEN 'dec' THEN 12
  END;

-- 4) Conversão por nº de contatos (saturação de campanha)
SELECT 
  campaign,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean
GROUP BY campaign
HAVING COUNT(*) >= 50
ORDER BY campaign;

-- 5) Faixas etárias
WITH base AS (
  SELECT
    CASE 
      WHEN age < 25 THEN '<25'
      WHEN age BETWEEN 25 AND 34 THEN '25-34'
      WHEN age BETWEEN 35 AND 44 THEN '35-44'
      WHEN age BETWEEN 45 AND 54 THEN '45-54'
      WHEN age BETWEEN 55 AND 64 THEN '55-64'
      ELSE '65+'
    END AS faixa_idade,
    y_flag
  FROM bank_clean
)
SELECT 
  faixa_idade,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM base
GROUP BY faixa_idade
ORDER BY 
  CASE faixa_idade
    WHEN '<25' THEN 1 WHEN '25-34' THEN 2 WHEN '35-44' THEN 3
    WHEN '45-54' THEN 4 WHEN '55-64' THEN 5 ELSE 6 END;

-- 6) Duração da ligação (proxy de engajamento)
SELECT
  CASE 
    WHEN duration < 60 THEN '<60s'
    WHEN duration < 180 THEN '60-179s'
    WHEN duration < 300 THEN '180-299s'
    ELSE '300s+'
  END AS faixa_duracao,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean
GROUP BY faixa_duracao
ORDER BY 
  CASE faixa_duracao
    WHEN '<60s' THEN 1 WHEN '60-179s' THEN 2 WHEN '180-299s' THEN 3 ELSE 4 END;

-- 7) Top segmentos (job x marital x education) com volume mínimo
SELECT 
  job, marital, education,
  COUNT(*) AS tentativas,
  SUM(y_flag) AS conversoes,
  ROUND(100.0 * SUM(y_flag)/COUNT(*), 2) AS taxa_conversao_pct
FROM bank_clean
GROUP BY job, marital, education
HAVING COUNT(*) >= 200
ORDER BY taxa_conversao_pct DESC
LIMIT 10;

-- 8) Qualidade de base (percentual de 'unknown' por coluna categórica)
WITH long AS (
  SELECT 'job' col, job val FROM bank_clean UNION ALL
  SELECT 'marital', marital FROM bank_clean UNION ALL
  SELECT 'education', education FROM bank_clean UNION ALL
  SELECT 'housing', housing FROM bank_clean UNION ALL
  SELECT 'loan', loan FROM bank_clean
)
SELECT 
  col AS coluna,
  ROUND(100.0 * SUM(CASE WHEN val IS NULL THEN 1 ELSE 0 END)/COUNT(*), 2) AS pct_null
FROM long
GROUP BY col
ORDER BY pct_null DESC;
