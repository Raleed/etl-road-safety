-- =====================================
-- Insérer les données nettoyées de Bronze vers Silver
-- =====================================
--Insertion transformée dans la table silver avec cast simple
INSERT INTO silver.caracteristiques_clean (
    identifiant_de_l_accident,
    date_et_heure,
    jour,
    mois,
    annee,
    heure_minute,
    date,
    year_georef,
    lumiere,
    code_postal,
    code_insee,
    departement,
    commune,
    code_commune,
    code_officiel_commune,
    nom_officiel_commune,
    nom_officiel_commune_arrondissement_municipal,
    code_officiel_departement,
    nom_officiel_departement,
    code_officiel_region,
    nom_officiel_region,
    code_officiel_epci,
    nom_officiel_epci,
    localisation,
    intersection,
    conditions_atmospheriques,
    collision,
    adresse,
    gps,
    latitude,
    longitude,
    coordonnees,
    numero,
    insert_ts,
    source
)
SELECT
    CAST(identifiant_de_l_accident AS VARCHAR(64)),
    CAST(date_et_heure AS TIMESTAMP),
    CAST(jour AS SMALLINT),
    CAST(mois AS SMALLINT),
    CAST(annee AS SMALLINT),
    CAST(heure_minute AS TIME),
    CAST(date AS DATE),
    CAST(year_georef AS SMALLINT),
    lumiere,
    code_postal,
    code_insee,
    departement,
    commune,
    code_commune,
    code_officiel_commune,
    nom_officiel_commune,
    nom_officiel_commune_arrondissement_municipal,
    code_officiel_departement,
    nom_officiel_departement,
    code_officiel_region,
    nom_officiel_region,
    code_officiel_epci,
    nom_officiel_epci,
    localisation,
    CAST(intersection AS SMALLINT),
    conditions_atmospheriques,
    collision,
    adresse,
    gps,
	CAST(REPLACE(latitude, ',', '.') AS DOUBLE PRECISION),
	CAST(REPLACE(longitude, ',', '.') AS DOUBLE PRECISION),
    coordonnees,
    numero,
    NOW() AS insert_ts,                 -- timestamp d'insertion
    'bronze.caracteristiques_raw' AS source  -- source de la donnée
FROM bronze.caracteristiques_raw;
-- Commit the transaction
COMMIT;


-- =====================================
-- Insérer les données nettoyées de Bronze vers Silver
-- =====================================
--Insertion transformée dans la table silver avec cast simple et lookup pour intersection


--Création d'une table temporaire de correspondance
CREATE TEMP TABLE lookup_intersection (
    code SMALLINT,
    libelle VARCHAR(50)
);

--Insertion des valeurs dans la table temporaire
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

--Insertion transformée dans la table silver
INSERT INTO silver.caracteristiques_clean (
    identifiant_de_l_accident,
    date_et_heure,
    jour,
    mois,
    annee,
    heure_minute,
    date,
    year_georef,
    lumiere,
    code_postal,
    code_insee,
    departement,
    commune,
    code_commune,
    code_officiel_commune,
    nom_officiel_commune,
    nom_officiel_commune_arrondissement_municipal,
    code_officiel_departement,
    nom_officiel_departement,
    code_officiel_region,
    nom_officiel_region,
    code_officiel_epci,
    nom_officiel_epci,
    localisation,
    intersection,
    conditions_atmospheriques,
    collision,
    adresse,
    gps,
    latitude,
    longitude,
    coordonnees,
    numero,
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
    CAST(c.date AS DATE),
    CAST(c.year_georef AS SMALLINT),
    c.lumiere,
    c.code_postal,
    c.code_insee,
    c.departement,
    c.commune,
    c.code_commune,
    c.code_officiel_commune,
    c.nom_officiel_commune,
    c.nom_officiel_commune_arrondissement_municipal,
    c.code_officiel_departement,
    c.nom_officiel_departement,
    c.code_officiel_region,
    c.nom_officiel_region,
    c.code_officiel_epci,
    c.nom_officiel_epci,
    c.localisation,
    COALESCE(i.libelle, 'autre intersection') AS intersection,
    c.conditions_atmospheriques,
    c.collision,
    c.adresse,
    c.gps,
    CAST(REPLACE(c.latitude, ',', '.') AS DOUBLE PRECISION),
    CAST(REPLACE(c.longitude, ',', '.') AS DOUBLE PRECISION),
    c.coordonnees,
    c.numero,
    NOW() AS insert_ts,
    'bronze.caracteristiques_raw' AS source
FROM bronze.caracteristiques_raw c
LEFT JOIN lookup_intersection i
    ON CAST(c.intersection AS SMALLINT) = i.code;
-- Commit the transaction
COMMIT;