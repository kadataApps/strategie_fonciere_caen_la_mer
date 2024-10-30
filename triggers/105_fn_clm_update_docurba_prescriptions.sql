CREATE
OR REPLACE FUNCTION clm.fn_clm_update_docurba_prescriptions() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    string_agg(DISTINCT typologie_simplifie, ' ; ') prescriptions INTO NEW .urba_prescriptions
  FROM
    clm.du_prescription_surf p
  WHERE
    NEW .geom & & p.geom
    AND st_intersects(p.geom, NEW .geom)
    AND st_area(st_intersection(p.geom, NEW .geom)) > 0;

RETURN NEW;

END $function$