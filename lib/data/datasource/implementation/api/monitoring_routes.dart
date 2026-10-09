import 'package:dio/dio.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';

/// Famille de routes d'écriture exposées par le module serveur monitoring.
enum MonitoringApiMode {
  /// Routes génériques `/monitorings/object/<module>/<type>` (monitoring
  /// ≤ 1.3.x). Dépréciées par la refonte (gn_module_monitoring#513).
  legacy,

  /// Routes de la refonte : `/monitorings/<module>/<types>` et
  /// `/monitorings/<module>/<types>/<id>`, corps JSON à plat.
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

/// Détecte, une fois par serveur, si les routes de la refonte sont
/// disponibles.
///
/// Sonde : `GET /monitorings/module/<module_code>?field_name=module_code`.
/// Monitoring ≤ 1.3.x n'expose que `/module/<int>` (404), la refonte accepte
/// un code (200). La version déclarée du module ne suffit pas : develop
/// annonce encore 1.3.2.
class MonitoringApiModeResolver {
  static final Map<String, MonitoringApiMode> _cache = {};

  const MonitoringApiModeResolver();

  Future<MonitoringApiMode> resolve(
      Dio dio, String token, String moduleCode) async {
    final key = Config.apiBase;
    final cached = _cache[key];
    if (cached != null) return cached;

    try {
      final response = await dio.get(
        '/monitorings/module/$moduleCode',
        queryParameters: {'field_name': 'module_code', 'depth': 0},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        return _remember(key, MonitoringApiMode.current);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return _remember(key, MonitoringApiMode.legacy);
      }
    } catch (_) {
      // Réponse inattendue : on retombe sur les routes legacy sans mémoriser.
    }
    // Erreur réseau ou statut inattendu : les routes legacy existent sur toutes
    // les versions connues, on les utilise sans figer le choix.
    return MonitoringApiMode.legacy;
  }

  MonitoringApiMode _remember(String key, MonitoringApiMode mode) {
    _cache[key] = mode;
    AppLogger().i('[API] Routes monitoring : ${mode.name} ($key)', tag: 'sync');
    return mode;
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
    required MonitoringApiMode mode,
    required String moduleCode,
    required MonitoringObjectType type,
    required Map<String, dynamic> legacyBody,
    int? id,
  }) {
    if (mode == MonitoringApiMode.legacy) {
      final path = '/monitorings/object/$moduleCode/${type.legacyName}'
          '${id != null ? '/$id' : ''}';
      return MonitoringWriteRequest(path, legacyBody);
    }

    final path =
        '/monitorings/$moduleCode/${type.currentName}${id != null ? '/$id' : ''}';
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
