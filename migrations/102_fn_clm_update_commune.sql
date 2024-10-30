CREATE
OR REPLACE FUNCTION clm.fn_clm_update_commune() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    communes.nom,
    communes.typo_commune,
    communes.typo_plh INTO NEW .commune,
    NEW .typologie_commune,
    NEW .typologie_commune_plh
  FROM
    clm.communes
  WHERE
    NEW .geom & & communes.geom
    AND st_within(st_pointonsurface(NEW .geom), communes.geom);

RETURN NEW;

END $function$