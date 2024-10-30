CREATE
OR REPLACE FUNCTION clm.fn_clm_update_docurba() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    p.type_zone,
    p.libelle plu_zonage,
    p.libelong plu_libelle_long INTO NEW .urba_typezonage,
    NEW .zonage,
    NEW .zonage_libelle
  FROM
    clm.zone_urba p
  WHERE
    NEW .geom & & p.geom
    AND st_intersects(p.geom, NEW .geom)
    AND st_area(st_intersection(p.geom, NEW .geom)) > 0
  ORDER BY
    round(
      st_area(st_intersection(p.geom, NEW .geom)) :: numeric,
      0
    ) DESC
  LIMIT
    1;

RETURN NEW;

END $function$