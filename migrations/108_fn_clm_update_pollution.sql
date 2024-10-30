CREATE
OR REPLACE FUNCTION clm.fn_clm_update_pollution() RETURNS TRIGGER LANGUAGE plpgsql AS $function$ BEGIN
  SELECT
    COUNT(*) nb,
    string_agg(
      COALESCE(nom_usuel, raison_sociale, '?') || ' - activité: ' || COALESCE(activites, '?') || ' - statut: ' || COALESCE(etat_site, '?'),
      ' ; '
    ) detail INTO NEW .basias_nb_sites,
    NEW .basias_detail
  FROM
    clm.basias b
  WHERE
    st_within(b.geom, NEW .geom);

RETURN NEW;

END $function$