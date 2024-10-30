CREATE
OR REPLACE FUNCTION clm.fn_clm_update_estimation_theorique() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    CASE
      WHEN (
        NEW .vocation = 'Habitat'
        OR NEW .vocation = 'Mixte'
      )
      AND (
        NEW .echeance = 'En cours'
        OR NEW .echeance = 'Gisement'
        OR NEW .echeance = 'Prospectif'
      ) THEN round(
        CASE
          WHEN st_area(NEW .geom) > 5000 THEN C .densite_sup_5000 * st_area(NEW .geom)
          ELSE C .densite_inf_5000 * st_area(NEW .geom)
        END :: numeric / 10000,
        0
      ) :: INTEGER
      ELSE 0
    END AS estimation_logements_theorique INTO NEW .estimation_logements_theorique
  FROM
    clm.communes_decoupees C
  WHERE
    NEW .geom & & C .geom
    AND st_within(st_pointonsurface(NEW .geom), C .geom);

RETURN NEW;

END $function$