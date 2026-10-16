import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';

/// Famille de routes d'écriture exposées par le module serveur monitoring.
enum MonitoringApiMode {
  /// Routes génériques `/monitorings/object/<module>/<type>` (monitoring
  /// ≤ 1.3.x). Dépréciées par la refonte (gn_module_monitoring#513).
  legacy,

  /// Nouvelle API : `<base>/<module>/<types>` et `<base>/<module>/<types>/<id>`,
  /// corps JSON à plat (base résolue par [MonitoringApiModeResolver]).
  current,
}

/// Types d'objets écrits par l'app (noms des routes génériques legacy).
enum MonitoringObjectType {
  site('site', 'sites', 'id_base_site'),
  sitesGroup('sites_group', 'sites_groups', 'id_sites_group'),
  visit('visit', 'visits', 'id_base_visit'),
  observation('observation', 'observations', 'id_observation'),
  observationDetail(
      'observation_detail', 'observation_details', 'id_observation_detail');

  const MonitoringObjectType(this.legacyName, this.currentName, this.pk);

  final String legacyName;
  final String currentName;

  /// Clé primaire renvoyée par les nouvelles routes (elles ne renvoient plus
  /// de clé `id`).
  final String pk;
}

/// Routes monitoring retenues pour un serveur : famille d'écriture et
/// préfixes de la nouvelle API.
class MonitoringApiRoutes {
  final MonitoringApiMode mode;

  /// Base des lectures `<readBase>/<module>/sites`, `/sites_groups`…
  final String readBase;

  /// Base des écritures `<writeBase>/<module>/<types>` en mode
  /// [MonitoringApiMode.current] (inutilisée en legacy).
  final String writeBase;

  const MonitoringApiRoutes({
    required this.mode,
    this.readBase = MonitoringApiModeResolver.refactoBase,
    this.writeBase = MonitoringApiModeResolver.refactoBase,
  });

  /// Monitoring ≤ 1.3.x : écritures `/object/...`, lectures sous `/refacto`.
  static const legacy = MonitoringApiRoutes(mode: MonitoringApiMode.legacy);
}

/// Détecte, une fois par serveur, où se trouvent les routes de la nouvelle
/// API.
///
/// La nouvelle API est servie sous un préfixe (`/monitorings/refacto`,
/// gn_module_monitoring#748) appelé à disparaître (`/monitorings`, annoncé
/// pour GeoNature 2.18.1). Plutôt que de déduire le préfixe d'une version,
/// on demande au serveur les méthodes acceptées (`OPTIONS`, en-tête `Allow`)
/// sur `<base>/<module>/sites` pour chaque base candidate :
/// - lectures : première base qui accepte GET ;
/// - écritures : première base qui accepte POST, sinon routes legacy.
///
/// | Serveur                 | lectures                 | écritures            |
/// |-------------------------|--------------------------|----------------------|
/// | monitoring 1.3.x        | /monitorings/refacto     | legacy `/object/...` |
/// | develop avant #748      | /monitorings/refacto     | /monitorings         |
/// | refact-hotfixes (#748)  | /monitorings/refacto     | /monitorings/refacto |
/// | 2.18.1 (préfixe retiré) | /monitorings             | /monitorings         |
class MonitoringApiModeResolver {
  static const refactoBase = '/monitorings/refacto';
  static const rootBase = '/monitorings';

  /// Ordre de préférence des bases de la nouvelle API.
  static const candidateBases = [refactoBase, rootBase];

  static final Map<String, MonitoringApiRoutes> _cache = {};

  const MonitoringApiModeResolver();

  Future<MonitoringApiRoutes> resolve(
      Dio dio, String token, String moduleCode) async {
    final key = Config.apiBase;
    final cached = _cache[key];
    if (cached != null) return cached;

    String? readBase;
    String? writeBase;
    var conclusive = true;
    for (final base in candidateBases) {
      final allowed = await _allowedMethods(dio, token, '$base/$moduleCode/sites');
      if (allowed == null) {
        conclusive = false;
        continue;
      }
      if (readBase == null && allowed.contains('GET')) readBase = base;
      if (writeBase == null && allowed.contains('POST')) writeBase = base;
    }

    final routes = writeBase != null
        ? MonitoringApiRoutes(
            mode: MonitoringApiMode.current,
            readBase: readBase ?? writeBase,
            writeBase: writeBase,
          )
        : MonitoringApiRoutes(
            mode: MonitoringApiMode.legacy,
            readBase: readBase ?? refactoBase,
          );

    // Erreur réseau ou serveur muet : on n'en tire rien de définitif.
    if (!conclusive && writeBase == null) return routes;
    _cache[key] = routes;
    AppLogger().i(
        '[API] Routes monitoring : ${routes.mode.name}, lectures '
        '${routes.readBase}, écritures ${routes.writeBase} ($key)',
        tag: 'sync');
    return routes;
  }

  /// Méthodes acceptées par [path] : ensemble vide si la route n'existe pas
  /// (404/405), `null` si la réponse ne permet pas de conclure.
  Future<Set<String>?> _allowedMethods(
      Dio dio, String token, String path) async {
    try {
      final response = await dio.request(
        path,
        options: Options(
          method: 'OPTIONS',
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      final allow = response.headers.value('allow');
      if (allow == null) return null;
      return allow.split(',').map((m) => m.trim().toUpperCase()).toSet();
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404 || status == 405) return const {};
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Pour les tests, et après un changement de serveur.
  static void clearCache() => _cache.clear();
}

/// Requête d'écriture (chemin + corps) adaptée au mode du serveur.
class MonitoringWriteRequest {
  final String path;
  final Map<String, dynamic> body;

  const MonitoringWriteRequest(this.path, this.body);

  /// [legacyBody] est le corps historique du mobile :
  /// `{properties: {...}, geometry?, type?, module_code?, data?}`.
  /// En mode [MonitoringApiMode.current], il est aplati comme le fait le
  /// formulaire web : `{...properties, geom}`, plus la clé primaire pour un
  /// PATCH (sans elle, certaines routes créent un nouvel objet).
  factory MonitoringWriteRequest.build({
    required MonitoringApiRoutes routes,
    required String moduleCode,
    required MonitoringObjectType type,
    required Map<String, dynamic> legacyBody,
    int? id,
  }) {
    if (routes.mode == MonitoringApiMode.legacy) {
      final path = '/monitorings/object/$moduleCode/${type.legacyName}'
          '${id != null ? '/$id' : ''}';
      return MonitoringWriteRequest(path, legacyBody);
    }

    final path = '${routes.writeBase}/$moduleCode/${type.currentName}'
        '${id != null ? '/$id' : ''}';
    return MonitoringWriteRequest(path, flattenBody(type, legacyBody, id: id));
  }

  static Map<String, dynamic> flattenBody(
      MonitoringObjectType type, Map<String, dynamic> legacyBody,
      {int? id}) {
    final properties = legacyBody['properties'];
    final body = <String, dynamic>{
      if (properties is Map) ...Map<String, dynamic>.from(properties),
    };
    if (legacyBody.containsKey('geometry')) {
      body['geom'] = legacyBody['geometry'];
    }
    // Les nouvelles routes valident `first_use_date` comme une date seule
    // (422 « Not a valid date » sur une date-heure ISO).
    final firstUseDate = body['first_use_date'];
    if (firstUseDate is String && firstUseDate.length > 10) {
      body['first_use_date'] = firstUseDate.substring(0, 10);
    }
    if (id != null) body[type.pk] = id;
    return body;
  }
}

/// Garantit la clé `id` attendue par la synchro, absente des réponses des
/// nouvelles routes (qui renvoient `id_base_visit`, `id_observation`…).
Map<String, dynamic> normalizeWriteResponse(
    MonitoringObjectType type, Map<String, dynamic> data) {
  if (data['id'] != null || data[type.pk] == null) return data;
  return {...data, 'id': data[type.pk]};
}
