CREATE
OR REPLACE FUNCTION clm.fn_clm_update_cadastre() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  DELETE FROM
    clm.referentiel_foncier_parcelles
  WHERE
    id = NEW .id;

WITH synthese AS (
  SELECT
    right(p.idpar, LENGTH(p.idpar) -8) idpar,
    round(st_area(p.geom) :: numeric, 0) surface_par,
    st_multi(PolygonalIntersection(p.geom, NEW .geom)) geom,
    round(
      st_area(PolygonalIntersection(p.geom, NEW .geom)) :: numeric,
      0
    ) surface_intersection,
    p.nbat,
    p.nlocal,
    p.spevtot,
    p.nloclog,
    p.nloccom,
    p.nloccomsec,
    p.nloccomter,
    p.nlogh,
    p.nloghvac,
    p.idprocpte,
    p.typproppro,
    p.typpropges,
    p.ddenomproppro,
    p.ddenompropges,
    p.descprop,
    p.adressepar,
    p.typproprietaire
  FROM
    clm.parcellaire p
  WHERE
    NEW .geom & & p.geom
    AND st_intersects(p.geom, NEW .geom)
    AND st_area(PolygonalIntersection(p.geom, NEW .geom)) > 0
    AND (
      st_area(PolygonalIntersection(p.geom, NEW .geom)) / st_area(p.geom) > .1
      OR st_area(PolygonalIntersection(p.geom, NEW .geom)) > 1000
    )
)
INSERT INTO
  clm.referentiel_foncier_parcelles (
    id,
    idpar,
    geom,
    surface_parcelle_p,
    typproprietaire,
    ddenomproppro,
    descprop
  )
SELECT
  NEW .id,
  CASE
    WHEN surface_intersection < .9 * surface_par THEN idpar || 'p'
    ELSE idpar
  END AS idpar,
  geom,
  surface_intersection AS surface_parcelle_p,
  typproprietaire,
  ddenomproppro,
  descprop
FROM
  synthese;

WITH parcelles_site AS (
  SELECT
    right(p.idpar, LENGTH(p.idpar) -8) idpar,
    round(st_area(p.geom) :: numeric, 0) surface_par,
    round(
      st_area(PolygonalIntersection(p.geom, NEW .geom)) :: numeric,
      0
    ) surface_intersection,
    p.nbat,
    p.nlocal,
    p.spevtot,
    p.nloclog,
    p.nloccom,
    p.nloccomsec,
    p.nloccomter,
    p.nlogh,
    p.nloghvac,
    p.idprocpte,
    p.typproppro,
    p.typpropges,
    p.ddenomproppro,
    p.ddenompropges,
    p.descprop,
    p.adressepar,
    p.typproprietaire,
    p.ndroit
  FROM
    clm.parcellaire p
  WHERE
    NEW .geom & & p.geom
    AND st_intersects(p.geom, NEW .geom)
    AND st_area(PolygonalIntersection(p.geom, NEW .geom)) > 0
    AND (
      st_area(PolygonalIntersection(p.geom, NEW .geom)) / st_area(p.geom) > .1
      OR st_area(PolygonalIntersection(p.geom, NEW .geom)) > 1000
    )
),
synthese AS (
  SELECT
    SUM(nbat) AS nbat,
    SUM(nlocal) AS nlocal,
    SUM(spevtot) AS spevtot,
    SUM(nloclog) AS nloclog,
    SUM(nloccom) AS nb_loc_commerciaux_existants,
    SUM(nloccomsec) AS nloccomsec,
    SUM(nloccomter) AS nloccomter,
    SUM(nlogh) AS nb_logements_existants,
    SUM(nloghvac) AS nloghvac,
    SUM(surface_intersection) AS surface_cadastrale,
    SUM(
      CASE
        WHEN typproprietaire = 'COMMUNE' THEN surface_intersection
        ELSE 0
      END
    ) AS surface_commune,
    SUM(
      CASE
        WHEN typproprietaire = 'EPCI' THEN surface_intersection
        ELSE 0
      END
    ) AS surface_epci,
    SUM(
      CASE
        WHEN typproprietaire = 'EPF' THEN surface_intersection
        ELSE 0
      END
    ) AS surf_cad_epf,
    SUM(
      CASE
        WHEN typproprietaire = 'AMENAGEUR_PUB' THEN surface_intersection
        ELSE 0
      END
    ) AS surface_amenageur_public,
    SUM(
      CASE
        WHEN typproprietaire = 'AUTRE_PUB' THEN surface_intersection
        ELSE 0
      END
    ) AS surface_autre_public,
    SUM(
      CASE
        WHEN (typproprietaire = 'COPROPRIETE') THEN surface_intersection
        ELSE 0
      END
    ) AS surface_copropriete,
    SUM(
      CASE
        WHEN (typproprietaire ilike 'PRIVE') THEN surface_intersection
        ELSE 0
      END
    ) AS surface_prive,
    SUM(
      CASE
        WHEN NOT (
          typproprietaire = 'AUTRE_PUB'
          OR typproprietaire = 'PRIVE'
          OR typproprietaire = 'COPROPRIETE'
        ) THEN surface_intersection
        ELSE 0
      END
    ) AS surf_totale_maitrisee,
    SUM(
      CASE
        WHEN NOT (
          typproprietaire = 'AUTRE_PUB'
          OR typproprietaire = 'PRIVE'
          OR typproprietaire = 'COPROPRIETE'
        ) THEN surface_intersection
        ELSE 0
      END
    ) / st_area(NEW .geom) AS pct_surf_maitrisee,
    COUNT(
      DISTINCT CASE
        WHEN (
          typproprietaire = 'AUTRE_PUB'
          OR typproprietaire = 'PRIVE'
          OR typproprietaire = 'COPROPRIETE'
        ) THEN idprocpte
        ELSE NULL
      END
    ) AS nb_uf_non_maitrisee,
    COUNT(DISTINCT idprocpte) AS nb_proprietaires,
    COUNT(*) AS nb_parcelles,
    MAX(adressepar) AS adresse
  FROM
    parcelles_site
),
proprietaires_site AS (
  SELECT
    SUM(ndroit) ndroit
  FROM
    (
      SELECT
        DISTINCT ndroit,
        idprocpte
      FROM
        parcelles_site
      WHERE
        typproprietaire = 'AUTRE_PUB'
        OR typproprietaire = 'PRIVE'
        OR typproprietaire = 'COPROPRIETE'
    ) t
)
SELECT
  * INTO NEW .nbat,
  NEW .nlocal,
  NEW .spevtot,
  NEW .nloclog,
  NEW .nb_loc_commerciaux_existants,
  NEW .nloccomsec,
  NEW .nloccomter,
  NEW .nb_logements_existants,
  NEW .nloghvac,
  NEW .surface_cadastrale,
  NEW .surface_commune,
  NEW .surface_epci,
  NEW .surf_cad_epf,
  NEW .surface_amenageur_public,
  NEW .surface_autre_public,
  NEW .surface_copropriete,
  NEW .surface_prive,
  NEW .surf_totale_maitrisee,
  NEW .pct_surf_maitrisee,
  NEW .nb_uf_non_maitrisee,
  NEW .nb_proprietaires,
  NEW .nb_parcelles,
  NEW .adresse,
  NEW .ndroit_non_maitrise
FROM
  synthese,
  proprietaires_site;

RETURN NEW;

END $function$