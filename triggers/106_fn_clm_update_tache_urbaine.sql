CREATE
OR REPLACE FUNCTION clm.fn_clm_update_tache_urbaine() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    pct_tache_urbaine,
    CASE
      WHEN pct_tache_urbaine > .8 THEN 'Renouvellement'
      ELSE 'Extension'
    END nature_foncier INTO NEW .pct_tache_urbaine,
    NEW .nature_foncier
  FROM
    (
      SELECT
        SUM(st_area(polygonalIntersection(t.geom, NEW .geom))) :: numeric /(st_area(NEW .geom) :: numeric) AS pct_tache_urbaine
      FROM
        clm.tache_urbaine t
      WHERE
        st_area(NEW .geom) > 0
        AND NEW .geom & & t.geom
        AND st_intersects(t.geom, NEW .geom)
    ) foo;

RETURN NEW;

END $function$