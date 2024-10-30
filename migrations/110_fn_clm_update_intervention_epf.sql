CREATE
OR REPLACE FUNCTION clm.fn_clm_update_intervention_epf() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  WITH nom_intervention AS (
    SELECT
      string_agg(e.nom, ' ; ') AS intervention_epf
    FROM
      clm.epf_operations_foncieres_actives e
    WHERE
      NEW .geom & & e.geom
      AND st_intersects(NEW .geom, e.geom)
  )
  SELECT
    intervention_epf,
    CASE
      WHEN intervention_epf IS NULL THEN 'non'
      ELSE 'oui'
    END INTO NEW .intervention_epf_active_nom_operation,
    NEW .intervention_epf_active
  FROM
    nom_intervention;

RETURN NEW;

END $function$