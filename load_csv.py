import pandas as pd
import sqlite3

# Nome do CSV
CSV = "bank-full.csv"  

# Lê o CSV separando por ponto e vírgula
df = pd.read_csv(CSV, sep=';')

# Padroniza nomes de colunas para snake_case
df.columns = [c.strip().lower().replace('.', '_').replace('-', '_') for c in df.columns]

# Cria conexão com SQLite
conn = sqlite3.connect("bank.db")

# Cria a tabela usando o schema.sql
with open("schema.sql", "r", encoding="utf-8") as f:
    conn.executescript(f.read())

# Insere dados no banco
df.to_sql("bank_marketing", conn, if_exists="append", index=False)

conn.close()
print("Importado com sucesso!")
