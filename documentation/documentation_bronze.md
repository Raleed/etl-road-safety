# Documentation – Couche Bronze – Projet Accidents de la Circulation

## 1. Contexte et objectifs

La **couche Bronze** dans une architecture **Medallion** est la couche des **données brutes** :  

- Elle stocke les fichiers sources **tels quels**, sans transformation majeure.  
- Elle garantit l’intégrité initiale des données pour pouvoir les **réutiliser et auditer**.  
- Elle sert de base pour les transformations futures (Silver → Gold).  

**Objectifs spécifiques pour ce projet :**

1. Importer les fichiers CSV d’accidents de la circulation.  
2. Normaliser les noms de colonnes.  
3. Stocker les données dans PostgreSQL (schéma `bronze`).  
4. Créer des indices pour accélérer les requêtes analytiques ultérieures.  

---

## 2. Architecture

Raw Data (CSV)
│
▼
[ Bronze Layer ] ← Postgres
│
▼
[ Silver Layer ] ← transformations, nettoyage
│
▼
[ Gold Layer ] ← données prêtes à la consommation (analyses/reporting)


### 2.1 Schéma `bronze`

- Nom du schéma SQL : **bronze**  
- Objectif : stocker les données brutes telles qu’importées.  
- Tables principales :  

| Table                  | Description                        | Clé primaire                  | Index principaux                                       |
|------------------------|-----------------------------------|-------------------------------|-------------------------------------------------------|
| `caracteristiques_raw` | Infos générales sur l'accident    | `identifiant_de_l_accident`   | `br_car_ident_idx`, `br_car_dep_idx`, `br_car_date_idx` |
| `lieux_raw`            | Détails sur la localisation       | `identifiant_de_l_accident`   | `br_lieux_ident_idx`                                  |
| `vehicules_raw`        | Infos sur les véhicules           | `identifiant_de_l_accident`   | `br_veh_ident_idx`, `br_veh_catv_idx`               |
| `usagers_raw`          | Infos sur les usagers/victimes   | `identifiant_de_l_accident`   | `br_usg_ident_idx`, `br_usg_grav_idx`               |

---

## 3. Description des tables

### 3.1 `caracteristiques_raw`
- Contient les informations sur l’accident : date, heure, commune, conditions météo, type de collision.  
- Colonne supplémentaire : `ingest_ts` (timestamp d’ingestion automatique).  

### 3.2 `lieux_raw`
- Contient les détails de localisation : route, type de voie, profil, PR, largeur, circulation.  

### 3.3 `vehicules_raw`
- Contient les informations sur les véhicules impliqués : catégorie, nombre d’occupants, points de choc, obstacles, manoeuvres.  

### 3.4 `usagers_raw`
- Contient les informations sur les usagers : gravité, catégorie, sexe, âge, équipement de sécurité, action du piéton.  

---

## 4. Flux ETL pour la couche Bronze

### 4.1 Préparation des données
1. Lecture des fichiers CSV bruts depuis `../data/raw`.  
2. Normalisation des noms de colonnes (`snake_case`, suppression accents et caractères spéciaux).  
3. Sélection des colonnes pertinentes pour chaque table.  

### 4.2 Insertion dans PostgreSQL
- Utilisation de la fonction `insert_df_to_table()` :  
  - Batch insertion via `psycopg2.extras.execute_values`.  
  - Gestion automatique des colonnes manquantes (`NULL`) ou supplémentaires.  

### 4.3 Indexation
- Création d’indices sur les colonnes fréquemment interrogées :  
  - `identifiant_de_l_accident` → pour relier les tables.  
  - `departement`, `annee`, `mois` → filtrage rapide.  
  - `categorie_vehicule`, `gravite` → analyses statistiques.  

---

## 5. Gestion des connexions PostgreSQL

- Vérifier les connexions ouvertes : `show_open_connections(engine, db_name)`  
- Fermer les connexions actives : `close_all_connections(engine, db_name)` (sauf session en cours)  
- Libérer l’engine SQLAlchemy après usage : `engine.dispose()` ou `close_engine(engine)`  

---

## 6. Exemple de code pour insertion

```python
engine = get_engine(DB_URL)
df = pd.read_csv(RAW_DIR / "accidents.csv", sep=";", dtype=str, encoding="utf-8-sig")
df_cleaned = normalize_columns(df)

table_cols = ["identifiant_de_l_accident", "date_et_heure", "commune", "annee", "mois", "jour", ...]
insert_df_to_table(engine, df_cleaned[table_cols], "bronze", "caracteristiques_raw", table_columns=table_cols)