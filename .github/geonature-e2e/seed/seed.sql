-- Liste taxonomique des protocoles (amphibiens et reptiles de TAXREF).
INSERT INTO taxonomie.bib_listes (code_liste, nom_liste, regne)
SELECT 'E2E_HERPETO', 'Herpéto test', 'Animalia'
WHERE NOT EXISTS (SELECT 1 FROM taxonomie.bib_listes WHERE code_liste = 'E2E_HERPETO');

INSERT INTO taxonomie.cor_nom_liste (id_liste, cd_nom)
SELECT l.id_liste, t.cd_nom
FROM taxonomie.taxref t, taxonomie.bib_listes l
WHERE l.code_liste = 'E2E_HERPETO'
  AND t.cd_nom = t.cd_ref AND t.id_rang = 'ES'
  AND t.classe IN ('Amphibia', 'Reptilia')
ON CONFLICT DO NOTHING;

-- Protocoles : liste taxonomique, observateurs (liste UsersHub 1), synthèse.
UPDATE gn_monitoring.t_module_complements mc
SET id_list_taxonomy = (SELECT id_liste FROM taxonomie.bib_listes WHERE code_liste = 'E2E_HERPETO'),
    id_list_observer = 1
FROM gn_commons.t_modules m
WHERE m.id_module = mc.id_module AND m.module_code IN (:codes);

-- Un seul jeu de données ouvert aux protocoles : l'app le présélectionne
-- alors dans les formulaires, comme sur une install type.
INSERT INTO gn_commons.cor_module_dataset (id_module, id_dataset)
SELECT m.id_module, d.id_dataset
FROM gn_commons.t_modules m, gn_meta.t_datasets d
WHERE m.module_code IN (:codes)
  AND d.id_dataset = (SELECT min(id_dataset) FROM gn_meta.t_datasets WHERE active)
ON CONFLICT DO NOTHING;
