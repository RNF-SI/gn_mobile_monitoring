import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

/// Un service qui permet d'envoyer des rapports d'erreur détaillés
/// avec des informations sur l'appareil, la version de l'application et les journaux.
class AppErrorReporter {
  static final AppErrorReporter _instance = AppErrorReporter._internal();
  factory AppErrorReporter() => _instance;
  AppErrorReporter._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  PackageInfo? _packageInfo;
  
  /// Initialiser le reporter
  Future<void> initialize() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (e) {
      debugPrint('Erreur lors de l\'initialisation du reporter: $e');
    }
  }

  /// Envoyer un rapport d'erreur
  Future<bool> sendErrorReport({
    required String userDescription,
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      // Récupérer les informations sur l'appareil
      final deviceData = await _getDeviceInfo();
      
      // Récupérer les logs
      final String logs = await AppLogger().getLogContent();
      
      // Créer le rapport
      final Map<String, dynamic> report = {
        'timestamp': DateTime.now().toIso8601String(),
        'appInfo': _getAppInfo(),
        'deviceInfo': deviceData,
        'userDescription': userDescription,
        'error': error?.toString(),
        'stackTrace': stackTrace?.toString(),
        'logs': logs,
        'additionalData': additionalData,
        'apiUrl': Config.apiBase,
      };
      
      // Enregistrer le rapport dans un fichier local
      final bool saved = await _saveReportLocally(report);
      
      // Log une note indiquant que l'envoi direct par e-mail est préféré
      AppLogger().i(
        'Rapport enregistré localement. Pour un traitement plus rapide, utilisez plutôt l\'option "Email" pour envoyer directement à antoine.schlegel@rnfrance.org',
        tag: 'ERROR_REPORTER',
      );
      
      return saved;
    } catch (e) {
      debugPrint('Erreur lors de l\'envoi du rapport: $e');
      return false;
    }
  }

  /// Récupérer les informations sur l'appareil
  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      if (kIsWeb) {
        return {'platform': 'web'};
      } else if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return {
          'platform': 'android',
          'version.release': info.version.release,
          'version.sdkInt': info.version.sdkInt,
          'manufacturer': info.manufacturer,
          'model': info.model,
        };
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return {
          'platform': 'ios',
          'systemName': info.systemName,
          'systemVersion': info.systemVersion,
          'model': info.model,
          'localizedModel': info.localizedModel,
        };
      } else if (Platform.isLinux) {
        final info = await _deviceInfo.linuxInfo;
        return {
          'platform': 'linux',
          'name': info.name,
          'version': info.version,
          'id': info.id,
        };
      }
      return {'platform': 'unknown'};
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
  }

  /// Récupérer les informations sur l'application
  Map<String, dynamic> _getAppInfo() {
    if (_packageInfo != null) {
      return {
        'appName': _packageInfo!.appName,
        'packageName': _packageInfo!.packageName,
        'version': _packageInfo!.version,
        'buildNumber': _packageInfo!.buildNumber,
      };
    }
    return {'appName': 'GN Mobile Monitoring'};
  }

  /// Enregistrer le rapport dans un fichier local
  Future<bool> _saveReportLocally(Map<String, dynamic> report) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final file = File('${directory.path}/error_report_$timestamp.json');
      
      await file.writeAsString(jsonEncode(report));
      
      // Log l'emplacement du fichier
      AppLogger().i(
        'Rapport d\'erreur enregistré: ${file.path}',
        tag: 'ERROR_REPORTER',
      );
      
      return true;
    } catch (e) {
      AppLogger().e(
        'Erreur lors de l\'enregistrement du rapport',
        tag: 'ERROR_REPORTER',
        error: e,
      );
      return false;
    }
  }

  /// Récupérer la liste des rapports enregistrés
  Future<List<String>> getErrorReportFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      
      final List<FileSystemEntity> files = await dir.list().toList();
      return files
          .whereType<File>()
          .where((file) => file.path.contains('error_report_'))
          .map((file) => file.path)
          .toList();
    } catch (e) {
      AppLogger().e(
        'Erreur lors de la récupération des rapports',
        tag: 'ERROR_REPORTER',
        error: e,
      );
      return [];
    }
  }
}