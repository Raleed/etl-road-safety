# notebooks/fetch_1000_simple.py
import time
from pathlib import Path
import requests
import pandas as pd

DATASET = "accidents-corporels-de-la-circulation-millesime"
BASE_URL = f"https://public.opendatasoft.com/api/explore/v2.1/catalog/datasets/{DATASET}/records"

TOTAL = 1000           # on veut 1000 lignes
PAGE_SIZE = 100        # <= 100 pour éviter le 400
DELAY = 0.15           # petit délai anti rate-limit

OUT_DIR = Path("data"); OUT_DIR.mkdir(parents=True, exist_ok=True)
OUT_FILE = OUT_DIR / "accidents_1000.csv"

def fetch_page(offset: int):
    params = {"limit": PAGE_SIZE, "offset": offset}
    r = requests.get(BASE_URL, params=params, timeout=60)
    r.raise_for_status()
    return r.json().get("results", [])

def main():
    all_rows = []
    offset = 0
    print("⏳ Téléchargement des 1000 premières lignes (par pages de 100)…")

    while len(all_rows) < TOTAL:
        chunk = fetch_page(offset)
        if not chunk:
            break
        all_rows.extend(chunk)
        print(f"  → {len(all_rows)} lignes cumulées")
        offset += PAGE_SIZE
        time.sleep(DELAY)

    all_rows = all_rows[:TOTAL]
    df = pd.DataFrame(all_rows)
    df.to_csv(OUT_FILE, index=False, encoding="utf-8")
    print(f"✅ {len(df)} lignes enregistrées dans {OUT_FILE}")

if __name__ == "__main__":
    main()