-- Bronze : tables construites à partir des noms nettoyés du CSV (tous les champs TEXT)
CREATE SCHEMA IF NOT EXISTS bronze;

-- TABLE: caracteristiques_raw (informations générales par accident)
CREATE TABLE IF NOT EXISTS bronze.caracteristiques_raw (
  identifiant_de_l_accident TEXT,
  date_et_heure TEXT,
  commune TEXT,
  annee TEXT,
  mois TEXT,
  jour TEXT,
  heure_minute TEXT,
  lumiere TEXT,
  localisation TEXT,
  intersection TEXT,
  conditions_atmospheriques TEXT,
  collision TEXT,
  departement TEXT,
  code_commune TEXT,
  code_insee TEXT,
  adresse TEXT,
  latitude TEXT,
  longitude TEXT,
  code_postal TEXT,
  numero TEXT,
  coordonnees TEXT,
  pr TEXT,
  surface TEXT,
  v1 TEXT,
  circulation TEXT,
  voie_reservee TEXT,
  env1 TEXT,
  voie TEXT,
  largeur_de_la_chaussee TEXT,
  v2 TEXT,
  largeur_terre_plein_central TEXT,
  nombre_de_voies TEXT,
  categorie_route TEXT,
  pr1 TEXT,
  plan TEXT,
  profil TEXT,
  infrastructure TEXT,
  situation TEXT,
  gps TEXT,
  date TEXT,
  year_georef TEXT,
  nom_officiel_commune TEXT,
  code_officiel_departement TEXT,
  nom_officiel_departement TEXT,
  code_officiel_epci TEXT,
  nom_officiel_epci TEXT,
  code_officiel_region TEXT,
  nom_officiel_region TEXT,
  nom_officiel_commune_arrondissement_municipal TEXT,
  code_officiel_commune TEXT
);

-- TABLE: lieux_raw (détails liés au lieu / route / géoréférencement)
CREATE TABLE IF NOT EXISTS bronze.lieux_raw (
  identifiant_de_l_accident TEXT,
  categorie_route TEXT,                 -- équivalent catr
  voie TEXT,
  v1 TEXT,
  v2 TEXT,
  circulation TEXT,                     -- circ
  nombre_de_voies TEXT,                 -- nbv
  voie_reservee TEXT,                   -- vosp
  profil TEXT,                          -- prof
  pr TEXT,
  pr1 TEXT,
  plan TEXT,
  largeur_terre_plein_central TEXT,     -- lartpc
  largeur_de_la_chaussee TEXT,          -- larrout
  surface TEXT,                         -- surf
  infrastructure TEXT,                  -- infra
  situation TEXT,                       -- situ
  env1 TEXT,
  coordonnees TEXT
);

-- TABLE: vehicules_raw (données par véhicule impliqué)
CREATE TABLE IF NOT EXISTS bronze.vehicules_raw (
  identifiant_de_l_accident TEXT,
  identifiant_vehicule TEXT,
  sens TEXT,                            -- senc / sens
  categorie_vehicule TEXT,              -- catv
  obstacle_fixe_heurte TEXT,            -- obs
  obstacle_mobile_heurte TEXT,          -- obsm
  point_de_choc TEXT,                   -- choc
  manoeuvre TEXT,                       -- manv
  nombre_d_occupants TEXT,              -- occutc / nombre_d_occupants
  source_file TEXT
);

-- TABLE: usagers_raw (données par usager / victime / piéton)
CREATE TABLE IF NOT EXISTS bronze.usagers_raw (
  identifiant_de_l_accident TEXT,
  identifiant_vehicule TEXT,
  place TEXT,
  categorie_d_usager TEXT,              -- catu
  gravite TEXT,
  sexe TEXT,
  annee_de_naissance TEXT,
  motif_trajet TEXT,                    -- trajet
  existence_equipement_de_securite TEXT, -- secu (partie 1)
  utilisation_equipement_de_securite TEXT,-- secu (partie 2)
  localisation_du_pieton TEXT,          -- locp
  action_pieton TEXT,                   -- actp
  pieton_seul_ou_non TEXT
);

-- Indexs basiques pour accélérer jointures/filtrages sur l'identifiant d'accident
CREATE INDEX IF NOT EXISTS br_car_ident_idx ON bronze.caracteristiques_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_lieux_ident_idx ON bronze.lieux_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_veh_ident_idx ON bronze.vehicules_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_usg_ident_idx ON bronze.usagers_raw (identifiant_de_l_accident);

-- Indexs additionnels conseillés (optionnel)
CREATE INDEX IF NOT EXISTS br_car_dep_idx ON bronze.caracteristiques_raw (departement);
CREATE INDEX IF NOT EXISTS br_car_date_idx ON bronze.caracteristiques_raw (annee, mois);
CREATE INDEX IF NOT EXISTS br_veh_catv_idx ON bronze.vehicules_raw (categorie_vehicule);
CREATE INDEX IF NOT EXISTS br_usg_grav_idx ON bronze.usagers_raw (gravite);