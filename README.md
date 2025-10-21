# Observatoire Sécurité Routière

## 🎯 Objectif
Créer une base de données centralisant les accidents corporels pour identifier les zones à risque et les conditions aggravantes.

## 👥 Équipe
- Kaouter
- Caroline  
- Khalid 

## 👥 Taches 
— Data Engineer (ETL, SQL)
— Modélisation, Documentation
— Analyse, Requêtes SQL

## ⚙️ Stack technique
- Python (Pandas, SQLAlchemy)
- MySQL ou SQLite
- SQL (requêtes analytiques)
- draw.io / Lucidchart (MCD) -> https://lucid.app/lucidchart/faf28986-9745-4e9d-bbdb-2799e8cf8024/edit?viewport_loc=-240%2C-96%2C2253%2C1105%2C0_0&invitationId=inv_94fe03bf-afc7-437b-8b38-7539488889af

## 🗓️ Planning (4 jours)
| Jour | Objectif principal | Livrable |
|------|---------------------|-----------|
| 1 | Compréhension + récupération des données | README + CSV brut |
| 2 | ETL (chargement et nettoyage) | Notebook `etl_accidents.ipynb` |
| 3 | Création de la base SQL + MCD | `schema.sql` + MCD.png |
| 4 | Analyse SQL + rendu final | `requetes.sql` + README final |

---

## 📥 Données – téléchargement et emplacement

Les fichiers de données **ne sont pas versionnés dans Git** (trop volumineux).  
Vous devez les télécharger manuellement avant d’exécuter les notebooks.

### 🔗 Source officielle
> **Jeu de données :** [Accidents corporels de la circulation - millésimé (Opendatasoft)](https://public.opendatasoft.com/explore/dataset/accidents-corporels-de-la-circulation-millesime/export/)

### 🧭 Étapes :
1. Ouvrir le lien ci-dessus.  
2. Cliquer sur **“Exporter” → “CSV (Jeu de données entier)”**.  
3. Une fois téléchargé, renommer le fichier en : accidents-corporels-de-la-circulation-millesime.csv
4. Déplacer ce fichier dans le dossier :
data/raw/


### 📂 Structure attendue du projet :
etl-road-safety/
├── data/
│ ├── raw/
│ │ ├── accidents-corporels-de-la-circulation-millesime.csv
│ │ └── .gitkeep
│ ├── cleaned/
│ │ └── .gitkeep
│ └── .gitkeep
├── notebooks/
│ ├── etl_accidents.ipynb
│ └── etl_accidents_test.ipynb
├── scripts/
│ └── fetch_data.py (optionnel)
├── schema.sql
├── requetes.sql
└── README.md