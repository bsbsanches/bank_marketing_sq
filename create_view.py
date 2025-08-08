import sqlite3
conn = sqlite3.connect("bank.db")
with open("clean.sql", "r", encoding="utf-8") as f:
    conn.executescript(f.read())
conn.close()
print("View criada com sucesso!")
