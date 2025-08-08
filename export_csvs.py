import sqlite3, pandas as pd

conn = sqlite3.connect("bank.db")

def to_csv(sql, name):
    df = pd.read_sql_query(sql, conn)
    df.to_csv(f"{name}.csv", index=False, encoding="utf-8")
    print(f"OK -> {name}.csv")

to_csv("""
SELECT COUNT(*) AS tentativas, SUM(y_flag) AS conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) AS taxa_conversao_pct
FROM bank_clean
""", "kpi_global")

to_csv("""
SELECT contact, COUNT(*) tentativas, SUM(y_flag) conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) taxa_conversao_pct
FROM bank_clean GROUP BY contact
""", "conv_por_canal")

to_csv("""
SELECT month, COUNT(*) tentativas, SUM(y_flag) conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) taxa_conversao_pct
FROM bank_clean GROUP BY month
""", "conv_por_mes")

to_csv("""
SELECT campaign, COUNT(*) tentativas, SUM(y_flag) conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) taxa_conversao_pct
FROM bank_clean GROUP BY campaign
""", "conv_por_campaign")

to_csv("""
WITH base AS (
  SELECT CASE 
    WHEN age < 25 THEN '<25'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    WHEN age BETWEEN 55 AND 64 THEN '55-64'
    ELSE '65+' END AS faixa_idade, y_flag
  FROM bank_clean)
SELECT faixa_idade, COUNT(*) tentativas, SUM(y_flag) conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) taxa_conversao_pct
FROM base GROUP BY faixa_idade
""", "conv_por_faixa_idade")

to_csv("""
SELECT CASE 
    WHEN duration < 60 THEN '<60s'
    WHEN duration < 180 THEN '60-179s'
    WHEN duration < 300 THEN '180-299s'
    ELSE '300s+' END AS faixa_duracao,
COUNT(*) tentativas, SUM(y_flag) conversoes,
ROUND(100.0*SUM(y_flag)/COUNT(*),2) taxa_conversao_pct
FROM bank_clean GROUP BY faixa_duracao
""", "conv_por_duracao")

conn.close()
