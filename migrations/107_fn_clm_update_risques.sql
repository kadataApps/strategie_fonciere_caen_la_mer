CREATE
OR REPLACE FUNCTION clm.fn_clm_update_risques() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  WITH alea AS (
    SELECT
      string_agg(
        DISTINCT nom,
        ' ; '
        ORDER BY
          nom
      ) libelle
    FROM
      clm. "N_ZONE_REG_PPRMR_BVO_S_014" r
    WHERE
      st_intersects(r.geom, NEW .geom)
  )
  SELECT
    libelle INTO NEW .risques_ppri
  FROM
    alea;

WITH alea AS (
  SELECT
    string_agg(
      DISTINCT alea,
      ' ; '
      ORDER BY
        alea
    ) AS libelle
  FROM
    clm.risques_argiles r
  WHERE
    st_intersects(r.geom, NEW .geom)
)
SELECT
  CASE
    WHEN libelle ilike '%Fort%' THEN 'Fort'
    WHEN libelle ilike '%moyen%' THEN 'Moyen'
    WHEN libelle ilike '%faible%' THEN 'Faible'
  END INTO NEW .risques_argiles
FROM
  alea;

WITH alea AS (
  SELECT
    string_agg(
      DISTINCT libelle,
      ' ; '
      ORDER BY
        libelle
    ) AS libelle
  FROM
    clm.risques_pprt r
  WHERE
    st_intersects(r.geom, NEW .geom)
)
SELECT
  CASE
    WHEN libelle ilike '%Fort%' THEN 'Fort'
    WHEN libelle ilike '%moyen%' THEN 'Moyen'
    WHEN libelle ilike '%faible%' THEN 'Faible'
  END INTO NEW .risques_pprt
FROM
  alea;

SELECT
  string_agg(
    DISTINCT nom,
    ' ; '
    ORDER BY
      nom
  ) INTO NEW .risques_pprm
FROM
  clm. "N_ZONE_REG_PPRM_MSO_20210810_S_014" r
WHERE
  st_intersects(r.geom, NEW .geom);

SELECT
  string_agg(
    DISTINCT naturecavite,
    ' ; '
    ORDER BY
      naturecavite
  ) INTO NEW .risques_cavites
FROM
  clm.risques_cavites r
WHERE
  st_intersects(r.geom, NEW .geom);

SELECT
  string_agg(
    DISTINCT "type",
    ' ; '
    ORDER BY
      "type"
  ) INTO NEW .env_znieff
FROM
  clm.env_znieff r
WHERE
  st_intersects(r.geom, NEW .geom)
  AND st_area(st_intersection(r.geom, NEW .geom)) / st_area(NEW .geom) > .05;

RETURN NEW;

END $function$