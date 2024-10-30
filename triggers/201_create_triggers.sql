CREATE TRIGGER tr_clm_00_update_surface BEFORE
INSERT
  OR
UPDATE
  OF geom,
  surface ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_surface();

CREATE TRIGGER tr_clm_01_update_commune BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_commune();

CREATE TRIGGER tr_clm_02_update_cadastre BEFORE
INSERT
  OR
UPDATE
  OF geom,
  nbat ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_cadastre();

CREATE TRIGGER tr_clm_03_update_docurba BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_docurba();

CREATE TRIGGER tr_clm_04_update_docurba_prescriptions BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_docurba_prescriptions();

CREATE TRIGGER tr_clm_05_update_tache_urbaine BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_tache_urbaine();

CREATE TRIGGER tr_clm_06_update_risques BEFORE
INSERT
  OR
UPDATE
  OF geom,
  risques_ppri ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_risques();

CREATE TRIGGER tr_clm_07_update_risques BEFORE
INSERT
  OR
UPDATE
  OF geom,
  basias_nb_sites ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_pollution();

CREATE TRIGGER tr_clm_08_estimation_theorique BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_estimation_theorique();

CREATE TRIGGER tr_clm_09_update_intervention_fonciere BEFORE
INSERT
  OR
UPDATE
  OF geom ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_intervention_epf();

CREATE TRIGGER tr_clm_10_update_durete_fonciere BEFORE
INSERT
  OR
UPDATE
  OF geom,
  classe_durete_fonciere ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_durete_fonciere();

CREATE TRIGGER tr_clm_50_update_env BEFORE
INSERT
  OR
UPDATE
  OF geom,
  env_agricoleext_surf ON clm.referentiel_foncier FOR EACH ROW EXECUTE FUNCTION clm.fn_clm_update_env();
