# 🧾 Documentation des transformations vers la couche Silver

## 🗂️ Objectif
La couche **Silver** contient des données **nettoyées, normalisées et typées** à partir de la couche **Bronze**.  
Les traitements appliqués dans cette couche permettent de :
- Fiabiliser les types (cast, conversion de formats)
- Harmoniser les valeurs (lookup, nettoyage texte)
- Supprimer les doublons et valeurs invalides
- Ajouter des métadonnées pour traçabilité (`insert_ts`, `source`)

---

## 🧱 Tables Silver créées

| Table | Description |
|--------|--------------|
| `silver.caracteristiques_clean` | Métadonnées des accidents (localisation, conditions, date/heure) |
| `silver.lieux_clean` | Informations sur les routes et lieux d'accident |
| `silver.vehicules_clean` | Informations sur les véhicules impliqués |
| `silver.usagers_clean` | Informations sur les usagers impliqués |

---

## ⚙️ Règles générales de transformation

| Étape | Description | Exemple |
|--------|--------------|----------|
| **1. Conversion de type** | Conversion des types bruts (`TEXT`) vers des types structurés (`SMALLINT`, `DOUBLE PRECISION`, `TIMESTAMP`, etc.) | `'12'` → `SMALLINT(12)` |
| **2. Nettoyage texte** | Trim, suppression d’espaces multiples, passage en minuscules, suppression des accents | `" Rue  du Bac "` → `"rue du bac"` |
| **3. Normalisation nulls** | Remplacement des chaînes vides ou `'nan'` par `NULL` | `''` → `NULL` |
| **4. Validation géographique** | Vérification de la présence de latitude / longitude | ligne exclue ou corrigée si manquante |
| **5. Harmonisation / Lookup** | Ajout de libellés lisibles via tables de correspondance | `intersection=6` → `"giratoire"` |
| **6. Suppression des doublons** | Sur la clé `identifiant_de_l_accident` |  |
| **7. Métadonnées d’insertion** | Ajout automatique de la source et du timestamp | `insert_ts = NOW()`, `source = 'bronze.xxx_raw'` |

---

## 🔍 Détail des transformations par table

### 🧩 `silver.caracteristiques_clean`

| Colonne | Type Silver | Transformation appliquée | Exemple |
|----------|--------------|--------------------------|----------|
| `identifiant_de_l_accident` | VARCHAR(64) | Cast direct depuis texte | `"2023A1234"` |
| `date_et_heure` | TIMESTAMP | Conversion avec `CAST(... AS TIMESTAMP)` et fuseau UTC | `"2023-05-12 08:45"` |
| `jour`, `mois`, `annee`, `year_georef` | SMALLINT | Cast en entier court | `"05"` → `5` |
| `heure_minute` | TIME | Extraction heure-minute | `"08:45:00"` |
| `latitude` / `longitude` | DOUBLE PRECISION | Remplacement `,` → `.` + cast | `"45,678"` → `45.678` |
| `intersection` | VARCHAR(50) | Jointure lookup_intersection | `6` → `"giratoire"` |
| `collision` | VARCHAR(50) | Remplacement `-1` par `"Inconnu"` | `-1` → `"Inconnu"` |
| `insert_ts` | TIMESTAMP | `NOW()` lors de l’insertion | `"2025-10-24 20:00"` |
| `source` | VARCHAR(255) | `'bronze.caracteristiques_raw'` |  |

#### 🔹 Lookup appliqué : `lookup_intersection`

| Code | Libellé |
|------|----------|
| 0 | non renseigné |
| 1 | hors intersection |
| 2 | intersection en x |
| 3 | intersection en t |
| 4 | intersection en y |
| 5 | intersection à plus de 4 branches |
| 6 | giratoire |
| 7 | place |
| 8 | passage à niveau |
| 9 | autre intersection |

#### 🔹 Lookup exemple supplémentaire : `lookup_lumiere`

| Code | Libellé |
|------|----------|
| 0 | non renseigné |
| 1 | plein jour |
| 2 | crépuscule ou aube |
| 3 | nuit sans éclairage public |
| 4 | nuit avec éclairage public allumé |
| 5 | nuit avec éclairage public éteint |

---

### 🧩 Exemple d’INSERT avec lookup en SQL

```sql
CREATE TEMP TABLE lookup_intersection (
    code SMALLINT,
    libelle VARCHAR(50)
);

INSERT INTO lookup_intersection VALUES
(0, 'non renseigné'),
(1, 'hors intersection'),
(2, 'intersection en x'),
(3, 'intersection en t'),
(4, 'intersection en y'),
(5, 'intersection à plus de 4 branches'),
(6, 'giratoire'),
(7, 'place'),
(8, 'passage à niveau'),
(9, 'autre intersection');

INSERT INTO silver.caracteristiques_clean (
    identifiant_de_l_accident,
    date_et_heure,
    jour,
    mois,
    annee,
    heure_minute,
    year_georef,
    lumiere,
    intersection,
    latitude,
    longitude,
    insert_ts,
    source
)
SELECT
    CAST(c.identifiant_de_l_accident AS VARCHAR(64)),
    CAST(c.date_et_heure AS TIMESTAMP),
    CAST(c.jour AS SMALLINT),
    CAST(c.mois AS SMALLINT),
    CAST(c.annee AS SMALLINT),
    CAST(c.heure_minute AS TIME),
    CAST(c.year_georef AS SMALLINT),
    c.lumiere,
    COALESCE(i.libelle, 'autre intersection') AS intersection,
    CAST(REPLACE(c.latitude, ',', '.') AS DOUBLE PRECISION),
    CAST(REPLACE(c.longitude, ',', '.') AS DOUBLE PRECISION),
    NOW() AS insert_ts,
    'bronze.caracteristiques_raw' AS source
FROM bronze.caracteristiques_raw c
LEFT JOIN lookup_intersection i
    ON CAST(c.intersection AS SMALLINT) = i.code;
