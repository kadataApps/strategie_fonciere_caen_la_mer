CREATE
OR REPLACE FUNCTION clm.fn_clm_update_durete_fonciere() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  WITH notes_durete AS (
    SELECT
      CASE
        WHEN (NEW .nb_uf_non_maitrisee = 0) THEN 0
        WHEN (
          NEW .surf_totale_maitrisee + NEW .surface_autre_public >= NEW .surface_cadastrale
        ) THEN 1
        WHEN (
          NEW .surface_copropriete = 0
          AND NEW .ndroit_non_maitrise <= 4
        ) THEN 2
        WHEN (
          NEW .surface_copropriete = 0
          AND NEW .ndroit_non_maitrise > 4
        ) THEN 3
        ELSE 6
      END AS note_morcellement,
      CASE
        WHEN (
          NEW .nb_loc_commerciaux_existants IS NULL
          OR NEW .nb_loc_commerciaux_existants = 0
        )
        AND (
          NEW .nb_logements_existants IS NULL
          OR NEW .nb_logements_existants = NEW .nloghvac
        ) THEN 0
        WHEN (
          NEW .nb_loc_commerciaux_existants IS NULL
          OR NEW .nb_loc_commerciaux_existants = 0
        )
        AND NEW .nb_logements_existants = 1 THEN 1
        ELSE 2
      END AS note_occupation,
      CASE
        WHEN NEW .etat_bati ilike '%bon%' THEN 3
        ELSE 0
      END AS note_etat_bati,
      CASE
        WHEN NEW .env_score_total = 4 THEN 2
        WHEN NEW .env_score_total > 4 THEN 6
        ELSE 0
      END AS note_environnement,
      CASE
        WHEN NEW .risques_ppri ilike '%rouge%'
        OR NEW .risques_ppri ilike '%bleu%'
        OR NEW .risques_ppri ilike '%orange%' THEN 3
        WHEN NEW .risques_pprm ilike '%rouge%'
        OR NEW .risques_pprm ilike '%bleu%' THEN 3
        ELSE 0
      END AS note_ppri,
      CASE
        WHEN NEW .env_especes_protegees ilike 'oui' THEN 6
        ELSE 0
      END AS note_espace_protege
  ),
  synthese AS (
    SELECT
      CASE
        WHEN note_morcellement = 0 THEN 0
        ELSE note_morcellement + note_occupation + note_etat_bati + note_environnement + note_ppri + note_espace_protege
      END AS note_durete
    FROM
      notes_durete
  )
  SELECT
    n.note_morcellement,
    n.note_occupation,
    n.note_etat_bati,
    n.note_environnement,
    n.note_ppri,
    n.note_espace_protege,
    synthese.note_durete,
    CASE
      WHEN note_durete = 0 THEN 'Maitrisé'
      WHEN note_durete <= 2 THEN 'Faible'
      WHEN note_durete <= 5 THEN 'Moyen'
      ELSE 'Fort'
    END AS classe_durete_fonciere INTO NEW .note_morcellement,
    NEW .note_occupation,
    NEW .note_etat_bati,
    NEW .note_environnement,
    NEW .note_ppri,
    NEW .note_espace_protege,
    NEW .note_durete,
    NEW .classe_durete_fonciere
  FROM
    notes_durete n,
    synthese;

RETURN NEW;

END $function$