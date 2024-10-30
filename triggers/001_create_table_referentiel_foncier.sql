

CREATE TABLE clm.referentiel_foncier (
    id integer DEFAULT nextval('clm.referentiel_foncier_id_seq'::regclass) NOT NULL,
    geom public.geometry(MultiPolygon,2154),
    commune character varying,
    echeance character varying,
    vocation character varying DEFAULT 'A préciser'::character varying,
    niveau_enjeu_clm character varying,
    adresse character varying,
    priorite_terrain_avp character varying,
    origine_reperage character varying,
    typologie_commune character varying,
    nom_site character varying,
    nom_detail character varying,
    commentaire character varying,
    commentaire_clm character varying,
    etat_bati character varying,
    photo1 character varying,
    photo2 character varying,
    photo3 character varying,
    zonage text,
    urba_typezonage text,
    zonage_libelle text,
    nature_foncier text,
    surface integer,
    nbat integer,
    nlocal integer,
    spevtot integer,
    nloclog integer,
    nb_loc_commerciaux_existants integer,
    nloccomsec integer,
    nloccomter integer,
    nb_logements_existants integer,
    nloghvac integer,
    surface_cadastrale integer,
    surface_commune integer,
    surface_epci integer,
    surf_cad_epf integer,
    surface_autre_public integer,
    surface_copropriete integer,
    surface_prive integer,
    nb_uf_non_maitrisee integer,
    nb_proprietaires integer,
    nb_parcelles integer,
    urba_prescriptions text,
    estimation_logements_theorique numeric,
    pct_tvb numeric,
    pct_tache_urbaine numeric,
    intervention_epf_active text,
    intervention_epf_active_nom_operation text,
    env_agricoleext_surf numeric,
    env_agricoleext_pct numeric,
    env_ao_surf numeric,
    env_ao_pct numeric,
    env_bo_surf numeric,
    env_bo_pct numeric,
    env_ma_surf numeric,
    env_ma_pct numeric,
    env_mh_surf numeric,
    env_mh_pct numeric,
    env_mt_surf numeric,
    env_mt_pct numeric,
    surface_amenageur_public integer,
    env_score_total integer,
    risques_ppri text,
    risques_pprm text,
    risques_pprt text,
    risques_argiles text,
    risques_cavites text,
    env_znieff text,
    surf_totale_maitrisee numeric,
    pct_surf_maitrisee numeric,
    ndroit_non_maitrise integer,
    note_morcellement integer,
    note_occupation integer,
    note_etat_bati integer,
    note_durete integer,
    classe_durete_fonciere text,
    env_especes_protegees text,
    env_especes_protegees_surf numeric,
    env_especes_protegees_pct numeric,
    site_priorise text DEFAULT 'Non'::text,
    typologie_commune_plh text,
    basias_nb_sites integer,
    basias_detail text,
    note_environnement integer,
    note_ppri integer,
    note_espace_protege integer,
    commune_origine text,
    photo4 text,
    vu_terrain text DEFAULT 'non'::text,
    outils_plu text,
    etude_prealable text,
    competence text,
    intervention text,
    portage text,
    echeance_ct_lt text,
    surface_creee integer,
    nb_logts_crees integer,
    couts_acquisition integer,
    couts_travaux_deconstruction integer,
    couts_travaux_depollution integer,
    couts_travaux integer,
    couts_etudes integer,
    montant_total_couts integer,
    montant_total_recettes integer,
    solde integer,
    filiere text,
    CONSTRAINT geometry_is_valid_check CHECK (public.st_isvalid(geom))
);


ALTER TABLE ONLY clm.referentiel_foncier
    ADD CONSTRAINT referentiel_foncier_pkey PRIMARY KEY (id);


CREATE INDEX sidx_referentiel_foncier_geom ON clm.referentiel_foncier USING gist (geom);


COMMENT ON COLUMN clm.referentiel_foncier.id IS 'Identifiant unique pour chaque site, généré automatiquement';
COMMENT ON COLUMN clm.referentiel_foncier.geom IS 'Géométrie du site en projection Lambert 93 (EPSG:2154). La géométrie du site doit être un polygone ou multipolyone valide.';
COMMENT ON COLUMN clm.referentiel_foncier.commune IS 'Nom de la commune, issu d''un croisement géographique.';
COMMENT ON COLUMN clm.referentiel_foncier.echeance IS 'Stade d''avancement du projet: Prospectif, Gisement, Projet, En cours/Terminé';
COMMENT ON COLUMN clm.referentiel_foncier.vocation IS 'Vocation du terrain envisagée';
COMMENT ON COLUMN clm.referentiel_foncier.niveau_enjeu_clm IS 'Niveau d''enjeu du site selon le CLM';
COMMENT ON COLUMN clm.referentiel_foncier.adresse IS 'Adresse du site issu de la base MAJIC';
COMMENT ON COLUMN clm.referentiel_foncier.priorite_terrain_avp IS 'Priorité du terrain (traitement AVP)';
COMMENT ON COLUMN clm.referentiel_foncier.origine_reperage IS 'Origine de l’identification ou du repérage du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.typologie_commune IS 'Typologie de la commune au SCoT';
COMMENT ON COLUMN clm.referentiel_foncier.nom_site IS 'Nom du site';
COMMENT ON COLUMN clm.referentiel_foncier.nom_detail IS 'Détails supplémentaires sur le nom du site';
COMMENT ON COLUMN clm.referentiel_foncier.commentaire IS 'Commentaires sur le site';
COMMENT ON COLUMN clm.referentiel_foncier.commentaire_clm IS 'Commentaires de CLM sur le site';
COMMENT ON COLUMN clm.referentiel_foncier.etat_bati IS 'État du bâti existant';
COMMENT ON COLUMN clm.referentiel_foncier.photo1 IS 'Lien vers la première photo du site';
COMMENT ON COLUMN clm.referentiel_foncier.photo2 IS 'Lien vers la deuxième photo du site';
COMMENT ON COLUMN clm.referentiel_foncier.photo3 IS 'Lien vers la troisième photo du site';
COMMENT ON COLUMN clm.referentiel_foncier.photo4 IS 'Lien vers la quatrième photo du site';
COMMENT ON COLUMN clm.referentiel_foncier.zonage IS 'Zonage réglementaire du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.urba_typezonage IS 'Type de zonage';
COMMENT ON COLUMN clm.referentiel_foncier.zonage_libelle IS 'Libellé du zonage';
COMMENT ON COLUMN clm.referentiel_foncier.nature_foncier IS 'Nature du foncier (extension ou renouvellement)';
COMMENT ON COLUMN clm.referentiel_foncier.surface IS 'Surface totale du terrain en m²';
COMMENT ON COLUMN clm.referentiel_foncier.nbat IS 'Nombre de bâtiments sur le terrain. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nlocal IS 'Nombre de locaux. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.spevtot IS 'Surface totale des parties évaluatives en m². MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nloclog IS 'Nombre de logements présents. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nb_loc_commerciaux_existants IS 'Nombre de locaux commerciaux existants. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nloccomsec IS 'Nombre de locaux commerciaux sect. secondaire. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nloccomter IS 'Nombre de locaux commerciaux sect. tertiaire. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nb_logements_existants IS 'Nombre total de logements existants. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nloghvac IS 'Nombre de logements vacants. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surface_cadastrale IS 'Surface cadastrale totale du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.surface_commune IS 'Surface des parcelles appartenant à la commune. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surface_epci IS 'Surface des parcelles appartenant à l’EPCI. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surf_cad_epf IS 'Surface des parcelles appartenant à l’EPF. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surface_autre_public IS 'Surface des parcelles appartenant à d’autres organismes publics (ETAT, Région, Département, etc.). MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surface_copropriete IS 'Surface en copropriété. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.surface_prive IS 'Surface des parcelles appartenant à des propriétaires privés. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nb_uf_non_maitrisee IS 'Nombre d’unités foncières non maîtrisées. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nb_proprietaires IS 'Nombre total de propriétaires. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.nb_parcelles IS 'Nombre de parcelles associées au site. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.urba_prescriptions IS 'Prescriptions au PLU';
COMMENT ON COLUMN clm.referentiel_foncier.estimation_logements_theorique IS 'Estimation théorique du nombre de logements potentiels';
COMMENT ON COLUMN clm.referentiel_foncier.pct_tvb IS 'Pourcentage de trame verte et bleue';
COMMENT ON COLUMN clm.referentiel_foncier.pct_tache_urbaine IS 'Pourcentage de tache urbaine';
COMMENT ON COLUMN clm.referentiel_foncier.intervention_epf_active IS 'Intervention EPF active (oui/non)';
COMMENT ON COLUMN clm.referentiel_foncier.intervention_epf_active_nom_operation IS 'Nom de l’opération EPF';
COMMENT ON COLUMN clm.referentiel_foncier.env_agricoleext_surf IS 'Surface des zones liées aux espèces associées aux milieux agricoles extensifs. Sachant que tous les terrains repérés ne sont pas nécessairement agricoles (jardins particuliers, espaces naturels...)';
COMMENT ON COLUMN clm.referentiel_foncier.env_agricoleext_pct IS 'Pourcentage de env_agricoleext_surf';
COMMENT ON COLUMN clm.referentiel_foncier.env_ao_surf IS 'Surface des zones agricoles ouvert (champs, prairies)';
COMMENT ON COLUMN clm.referentiel_foncier.env_ao_pct IS 'Pourcentage de surface des zones agricoles ouvert (champs, prairies)';
COMMENT ON COLUMN clm.referentiel_foncier.env_bo_surf IS 'Surface des zones boisées';
COMMENT ON COLUMN clm.referentiel_foncier.env_bo_pct IS 'Pourcentage de surface des zones boisées';
COMMENT ON COLUMN clm.referentiel_foncier.env_ma_surf IS 'Surface des milieux aquatiques';
COMMENT ON COLUMN clm.referentiel_foncier.env_ma_pct IS 'Pourcentage des milieux aquatiques';
COMMENT ON COLUMN clm.referentiel_foncier.env_mh_surf IS 'Surface des milieux humides';
COMMENT ON COLUMN clm.referentiel_foncier.env_mh_pct IS 'Pourcentage des milieux humides';
COMMENT ON COLUMN clm.referentiel_foncier.env_mt_surf IS 'Surface des milieux thermophiles';
COMMENT ON COLUMN clm.referentiel_foncier.env_mt_pct IS 'Pourcentage des milieux thermophiles';
COMMENT ON COLUMN clm.referentiel_foncier.surface_amenageur_public IS 'Surface des parcelles appartenant à un aménageur public. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.env_score_total IS 'Score environnemental total';
COMMENT ON COLUMN clm.referentiel_foncier.risques_ppri IS 'Risques liés au Plan de Prévention des Risques d’Inondation (PPRI)';
COMMENT ON COLUMN clm.referentiel_foncier.risques_pprm IS 'Risques liés au Plan de Prévention des Risques Miniers (PPRM)';
COMMENT ON COLUMN clm.referentiel_foncier.risques_pprt IS 'Risques liés au Plan de Prévention des Risques Technologiques (PPRT)';
COMMENT ON COLUMN clm.referentiel_foncier.risques_argiles IS 'Risques liés aux retraits/gonflements d’argiles';
COMMENT ON COLUMN clm.referentiel_foncier.risques_cavites IS 'Risques liés aux cavités souterraines';
COMMENT ON COLUMN clm.referentiel_foncier.env_znieff IS 'Zones Naturelles d’Intérêt Écologique Faunistique et Floristique (ZNIEFF)';
COMMENT ON COLUMN clm.referentiel_foncier.surf_totale_maitrisee IS 'Surface totale des parcelles maîtrisées. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.pct_surf_maitrisee IS 'Pourcentage de la surface maîtrisée';
COMMENT ON COLUMN clm.referentiel_foncier.ndroit_non_maitrise IS 'Nombre de droits réels sur le site autre que commune et EPCI. MAJIC.';
COMMENT ON COLUMN clm.referentiel_foncier.note_morcellement IS 'Note sur le morcellement du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.note_occupation IS 'Note sur l’occupation du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.note_etat_bati IS 'Note sur l’état du bâti';
COMMENT ON COLUMN clm.referentiel_foncier.note_durete IS 'Note de synthese sur la dureté foncière';
COMMENT ON COLUMN clm.referentiel_foncier.classe_durete_fonciere IS 'Classe de la dureté foncière (faible/moyenne/forte)';
COMMENT ON COLUMN clm.referentiel_foncier.env_especes_protegees IS 'Présence d’espèces protégées sur le site';
COMMENT ON COLUMN clm.referentiel_foncier.env_especes_protegees_surf IS 'Surface occupée par des espèces protégées';
COMMENT ON COLUMN clm.referentiel_foncier.env_especes_protegees_pct IS 'Pourcentage de surface occupée par des espèces protégées';
COMMENT ON COLUMN clm.referentiel_foncier.site_priorise IS 'Indicateur si le site est priorisé';
COMMENT ON COLUMN clm.referentiel_foncier.typologie_commune_plh IS 'Typologie PLH de la commune';
COMMENT ON COLUMN clm.referentiel_foncier.basias_nb_sites IS 'Nombre de sites BASIAS sur la parcelle';
COMMENT ON COLUMN clm.referentiel_foncier.basias_detail IS 'Détails des sites BASIAS';
COMMENT ON COLUMN clm.referentiel_foncier.note_environnement IS 'Note environnementale du site';
COMMENT ON COLUMN clm.referentiel_foncier.note_ppri IS 'Note relative aux risques PPRI';
COMMENT ON COLUMN clm.referentiel_foncier.note_espace_protege IS 'Note relative aux espaces protégés';
COMMENT ON COLUMN clm.referentiel_foncier.commune_origine IS 'Commune d’origine avant regroupement communal';
COMMENT ON COLUMN clm.referentiel_foncier.vu_terrain IS 'Indicateur si le terrain a été visité (oui/non)';
COMMENT ON COLUMN clm.referentiel_foncier.outils_plu IS 'Outils d’urbanisme (PLU)';
COMMENT ON COLUMN clm.referentiel_foncier.etude_prealable IS 'Existence d’une étude préalable';
COMMENT ON COLUMN clm.referentiel_foncier.competence IS 'Compétence juridique';
COMMENT ON COLUMN clm.referentiel_foncier.intervention IS 'Type d’intervention prévue';
COMMENT ON COLUMN clm.referentiel_foncier.portage IS 'Type de portage foncier';
COMMENT ON COLUMN clm.referentiel_foncier.echeance_ct_lt IS 'Échéance à court ou long terme';
COMMENT ON COLUMN clm.referentiel_foncier.surface_creee IS 'Surface créée';
COMMENT ON COLUMN clm.referentiel_foncier.nb_logts_crees IS 'Nombre de logements créés';
COMMENT ON COLUMN clm.referentiel_foncier.couts_acquisition IS 'Coûts d’acquisition du terrain';
COMMENT ON COLUMN clm.referentiel_foncier.couts_travaux_deconstruction IS 'Coûts des travaux de déconstruction';
COMMENT ON COLUMN clm.referentiel_foncier.couts_travaux_depollution IS 'Coûts des travaux de dépollution';
COMMENT ON COLUMN clm.referentiel_foncier.couts_travaux IS 'Coûts des autres travaux';
COMMENT ON COLUMN clm.referentiel_foncier.couts_etudes IS 'Coûts des études préalables';
COMMENT ON COLUMN clm.referentiel_foncier.montant_total_couts IS 'Montant total des coûts';
COMMENT ON COLUMN clm.referentiel_foncier.montant_total_recettes IS 'Montant total des recettes';
COMMENT ON COLUMN clm.referentiel_foncier.solde IS 'Solde financier du projet';
COMMENT ON COLUMN clm.referentiel_foncier.filiere IS 'Filière de production envisagée';
