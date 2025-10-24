CREATE SCHEMA IF NOT EXISTS bronze;


CREATE TABLE IF NOT EXISTS bronze.caracteristiques_raw (
  identifiant_de_l_accident TEXT,
  date_et_heure TEXT,
  jour TEXT,
  mois TEXT,
  annee TEXT,
  heure_minute TEXT,
  date TEXT,
  year_georef TEXT,
  lumiere TEXT,
  code_postal TEXT,
  code_insee TEXT,
  departement TEXT,
  commune TEXT,
  code_commune TEXT,
  code_officiel_commune TEXT,
  nom_officiel_commune TEXT,
  nom_officiel_commune_arrondissement_municipal TEXT,
  code_officiel_departement TEXT,
  nom_officiel_departement TEXT,
  code_officiel_region TEXT,
  nom_officiel_region TEXT,
  code_officiel_epci TEXT,
  nom_officiel_epci TEXT,
  localisation TEXT,
  intersection TEXT,
  conditions_atmospheriques TEXT,
  collision TEXT,
  adresse TEXT,
  gps TEXT,
  latitude TEXT,
  longitude TEXT,
  coordonnees TEXT,
  numero TEXT  
);

CREATE TABLE IF NOT EXISTS bronze.lieux_raw (
  identifiant_de_l_accident TEXT,
  categorie_route TEXT,
  voie TEXT,
  v1 TEXT,
  v2 TEXT,
  circulation TEXT,
  nombre_de_voies TEXT,
  voie_reservee TEXT,
  profil TEXT,
  pr TEXT,
  pr1 TEXT,
  plan TEXT,
  largeur_terre_plein_central TEXT,
  largeur_de_la_chaussee TEXT,
  surface TEXT,
  infrastructure TEXT,
  situation TEXT,
  env1 TEXT
);

CREATE TABLE IF NOT EXISTS bronze.vehicules_raw (
  identifiant_de_l_accident TEXT,
  identifiant_vehicule TEXT,
  sens TEXT,
  categorie_vehicule TEXT,
  obstacle_fixe_heurte TEXT,
  obstacle_mobile_heurte TEXT,
  point_de_choc TEXT,
  manoeuvre TEXT,
  nombre_d_occupants TEXT
);

CREATE TABLE IF NOT EXISTS bronze.usagers_raw (
  identifiant_de_l_accident TEXT,
  identifiant_vehicule TEXT,
  place TEXT,
  categorie_d_usager TEXT,
  gravite TEXT,
  sexe TEXT,
  annee_de_naissance TEXT,
  motif_trajet TEXT,
  existence_equipement_de_securite TEXT,
  utilisation_equipement_de_securite TEXT,
  localisation_du_pieton TEXT,
  action_pieton TEXT,
  pieton_seul_ou_non TEXT
);

CREATE INDEX IF NOT EXISTS br_car_ident_idx ON bronze.caracteristiques_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_lieux_ident_idx ON bronze.lieux_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_veh_ident_idx ON bronze.vehicules_raw (identifiant_de_l_accident);
CREATE INDEX IF NOT EXISTS br_usg_ident_idx ON bronze.usagers_raw (identifiant_de_l_accident);

CREATE INDEX IF NOT EXISTS br_car_dep_idx ON bronze.caracteristiques_raw (departement);
CREATE INDEX IF NOT EXISTS br_car_date_idx ON bronze.caracteristiques_raw (annee, mois);
CREATE INDEX IF NOT EXISTS br_veh_catv_idx ON bronze.vehicules_raw (categorie_vehicule);
CREATE INDEX IF NOT EXISTS br_usg_grav_idx ON bronze.usagers_raw (gravite);