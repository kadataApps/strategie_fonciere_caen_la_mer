CREATE
OR REPLACE FUNCTION clm.fn_clm_update_env() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    COALESCE(surf, 0),
    COALESCE(
      surf :: numeric / st_area(NEW .geom) :: numeric,
      0
    ) pct INTO NEW .env_agricoleext_surf,
    NEW .env_agricoleext_pct
  FROM
    (
      SELECT
        SUM(
          st_area(polygonalIntersection(t.geom, NEW .geom))
        ) :: numeric AS surf
      FROM
        clm.env_agricoleext_difference t
      WHERE
        st_area(NEW .geom) > 0
        AND t.ae_val = 100
        AND NEW .geom & & t.geom
        AND st_intersects(t.geom, NEW .geom)
    ) foo;

SELECT
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_ao_surf,
  NEW .env_ao_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_ao_difference t
    WHERE
      st_area(NEW .geom) > 0
      AND t.ao_val = 100
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

SELECT
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_bo_surf,
  NEW .env_bo_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_bo_difference t
    WHERE
      st_area(NEW .geom) > 0
      AND t.bo_val = 100
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

SELECT
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_ma_surf,
  NEW .env_ma_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_ma_difference t
    WHERE
      st_area(NEW .geom) > 0
      AND t.aq_val = 100
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

SELECT
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_mh_surf,
  NEW .env_mh_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_mh_difference t
    WHERE
      st_area(NEW .geom) > 0
      AND t.hu_val = 100
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

SELECT
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_mt_surf,
  NEW .env_mt_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_mt_difference t
    WHERE
      st_area(NEW .geom) > 0
      AND t.th_val = 100
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

SELECT
  CASE
    WHEN COALESCE(
      surf :: numeric / st_area(NEW .geom) :: numeric,
      0
    ) > .05 THEN 'oui'
    ELSE 'non'
  END,
  COALESCE(surf, 0),
  COALESCE(
    surf :: numeric / st_area(NEW .geom) :: numeric,
    0
  ) pct INTO NEW .env_especes_protegees,
  NEW .env_especes_protegees_surf,
  NEW .env_especes_protegees_pct
FROM
  (
    SELECT
      SUM(
        st_area(polygonalIntersection(t.geom, NEW .geom))
      ) :: numeric AS surf
    FROM
      clm.env_especes_protegees t
    WHERE
      st_area(NEW .geom) > 0
      AND NEW .geom & & t.geom
      AND st_intersects(t.geom, NEW .geom)
  ) foo;

RETURN NEW;

END $function$