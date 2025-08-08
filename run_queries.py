import sqlite3, pathlib, textwrap

DB = "bank.db"
SQL_FILE = "queries.sql"

sql_text = pathlib.Path(SQL_FILE).read_text(encoding="utf-8")
# separa por ';' preservando blocos com CTEs
queries = [q.strip() for q in sql_text.split(";") if q.strip()]

conn = sqlite3.connect(DB)
cur = conn.cursor()

for i, q in enumerate(queries, 1):
    print(f"\n=== Consulta {i} ===")
    try:
        cur.execute(q)
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description] if cur.description else []
        if cols:
            print("\t".join(cols))
            for r in rows[:50]:  # mostra até 50 linhas por consulta
                print("\t".join("" if x is None else str(x) for x in r))
        else:
            print("OK")
    except Exception as e:
        print("ERRO:", e)
        print("SQL que falhou:\n", textwrap.shorten(q.replace("\n"," "), width=300))
conn.close()
