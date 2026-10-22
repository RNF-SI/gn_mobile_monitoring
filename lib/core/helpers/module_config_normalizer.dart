/// Ramène la configuration d'un module servie par la nouvelle API monitoring
/// au format historique lu par l'application.
///
/// Depuis la refonte (route `<base>/<module>/config`), le serveur fusionne
/// lui-même `generic` et `specific` de chaque objet dans `fields` (surcharge
/// generic → type de site → specific déjà résolue). Les attributs des champs
/// sont inchangés. On re-scinde `fields` : un champ du catalogue générique
/// (fichiers `config/generic/<objet>.json` du module) va dans `generic`, les
/// autres dans `specific`. Sur les configs réelles de 11 protocoles, le
/// résultat est identique à celui de l'ancienne route `/config/<module>`.
///
/// `custom['__MODULE.TYPES_SITE']`, supprimé par la nouvelle route, est
/// reconstruit depuis `module.types_site`.
///
/// Une configuration déjà au format historique est renvoyée telle quelle.
Map<String, dynamic> normalizeModuleConfig(Map<String, dynamic> config) {
  if (!_hasFieldsFormat(config)) return config;

  final result = Map<String, dynamic>.from(config);
  for (final entry in config.entries) {
    final objectConfig = entry.value;
    if (objectConfig is! Map || objectConfig['fields'] is! Map) continue;
    if (objectConfig.containsKey('generic') ||
        objectConfig.containsKey('specific')) {
      continue;
    }

    final catalog = genericFieldCatalog[entry.key] ?? const <String>{};
    final generic = <String, dynamic>{};
    final specific = <String, dynamic>{};
    (objectConfig['fields'] as Map).forEach((name, field) {
      (catalog.contains(name) ? generic : specific)[name as String] = field;
    });
    result[entry.key] = {
      ...Map<String, dynamic>.from(objectConfig),
      'generic': generic,
      'specific': specific,
    };
  }

  _restoreTypesSite(result);
  return result;
}

bool _hasFieldsFormat(Map<String, dynamic> config) => config.values.any((v) =>
    v is Map &&
    v['fields'] is Map &&
    !v.containsKey('generic') &&
    !v.containsKey('specific'));

void _restoreTypesSite(Map<String, dynamic> config) {
  final custom = config['custom'];
  final module = config['module'];
  if (custom is! Map || custom.containsKey('__MODULE.TYPES_SITE')) return;
  final typesSite = module is Map ? module['types_site'] : null;
  if (typesSite is! Map) return;

  final ids = typesSite.keys
      .map((id) => int.tryParse(id.toString()))
      .whereType<int>()
      .toList();
  config['custom'] = {
    ...Map<String, dynamic>.from(custom),
    '__MODULE.TYPES_SITE': [
      for (final id in ids) {'config': null, 'id_nomenclature_type_site': id},
    ],
  };
}

/// Champs génériques de chaque objet, tels que servis par le module
/// `generic` de monitoring (refact-hotfixes, 16/10/2026).
const Map<String, Set<String>> genericFieldCatalog = {
  'module': {
    'active_frontend', 'b_draw_sites_group', 'b_synthese', 'cd_nom',
    'datasets', 'id_list_observer', 'id_list_taxonomy', 'id_module',
    'medias', 'module_code', 'module_desc', 'module_label', 'module_path',
    'module_picto', 'taxonomy_display_field_name', 'types_site',
    'uuid_module_complement',
  },
  'sites_group': {
    'altitude_max', 'altitude_min', 'comments', 'id_digitiser',
    'id_sites_group', 'medias', 'modules', 'nb_sites', 'nb_visits',
    'sites_group_code', 'sites_group_description', 'sites_group_name',
    'uuid_sites_group',
  },
  'site': {
    'altitude_max', 'altitude_min', 'base_site_code',
    'base_site_description', 'base_site_name', 'first_use_date',
    'id_base_site', 'id_digitiser', 'id_inventor', 'id_sites_group',
    'last_visit', 'medias', 'nb_individuals', 'nb_visits', 'types_site',
    'uuid_base_site',
  },
  'visit': {
    'comments', 'id_base_site', 'id_base_visit', 'id_dataset',
    'id_digitiser', 'id_module', 'medias', 'nb_observations', 'observers',
    'observers_txt', 'uuid_base_visit', 'visit_date_max', 'visit_date_min',
  },
  'observation': {
    'cd_nom', 'comments', 'id_base_visit', 'id_digitiser',
    'id_individual', 'id_observation', 'medias', 'uuid_observation',
  },
  'observation_detail': {
    'id_observation', 'id_observation_detail', 'medias',
    'uuid_observation_detail',
  },
};
