import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:gn_mobile_monitoring/core/errors/app_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Service pour exporter et copier les logs de l'application
class LogExportService {
  static final LogExportService _instance = LogExportService._internal();
  factory LogExportService() => _instance;
  LogExportService._internal();

  final AppLogger _logger = AppLogger();

  /// Copie tous les logs dans le presse-papiers avec les métadonnées
  Future<bool> copyLogsToClipboard({
    bool includeSystemInfo = true,
    int? maxLines,
    List<String>? filterTags,
  }) async {
    try {
      final logContent = await _generateLogReport(
        includeSystemInfo: includeSystemInfo,
        maxLines: maxLines,
        filterTags: filterTags,
      );

      await Clipboard.setData(ClipboardData(text: logContent));
      
      _logger.i('Logs copied to clipboard successfully', tag: 'LOG_EXPORT');
      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to copy logs to clipboard',
        tag: 'LOG_EXPORT',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Génère un rapport complet des logs
  Future<String> _generateLogReport({
    bool includeSystemInfo = true,
    int? maxLines,
    List<String>? filterTags,
  }) async {
    final buffer = StringBuffer();
    
    // En-tête du rapport
    buffer.writeln('=' * 60);
    buffer.writeln('RAPPORT DE LOGS - GEONATURE MOBILE');
    buffer.writeln('=' * 60);
    buffer.writeln('Date d\'export: ${DateTime.now().toIso8601String()}');
    buffer.writeln();

    // Informations système si demandées
    if (includeSystemInfo) {
      buffer.writeln(await _getSystemInfo());
      buffer.writeln();
    }

    // Logs principal
    buffer.writeln('LOGS DE L\'APPLICATION:');
    buffer.writeln('-' * 40);
    
    final logs = await _getFilteredLogs(maxLines: maxLines, filterTags: filterTags);
    buffer.writeln(logs);

    // Logs d'archives si disponibles
    final archiveLogs = await _getArchiveLogs();
    if (archiveLogs.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('LOGS ARCHIVÉS:');
      buffer.writeln('-' * 40);
      buffer.writeln(archiveLogs);
    }

    buffer.writeln();
    buffer.writeln('=' * 60);
    buffer.writeln('FIN DU RAPPORT');
    buffer.writeln('=' * 60);

    return buffer.toString();
  }

  /// Récupère les logs filtrés
  Future<String> _getFilteredLogs({
    int? maxLines,
    List<String>? filterTags,
  }) async {
    try {
      String logContent = await _logger.getLogContent();
      
      if (logContent == 'Logs non disponibles' || logContent == 'Fichier de log vide') {
        return logContent;
      }

      final lines = logContent.split('\n');
      
      // Filtrer par tags si spécifiés
      List<String> filteredLines = lines;
      if (filterTags != null && filterTags.isNotEmpty) {
        filteredLines = lines.where((line) {
          return filterTags.any((tag) => line.contains('$tag:'));
        }).toList();
      }

      // Limiter le nombre de lignes si spécifié
      if (maxLines != null && filteredLines.length > maxLines) {
        filteredLines = filteredLines.take(maxLines).toList();
        filteredLines.add('... (${lines.length - maxLines} lignes supprimées)');
      }

      return filteredLines.join('\n');
    } catch (e) {
      return 'Erreur lors de la récupération des logs: $e';
    }
  }

  /// Récupère les logs d'archives
  Future<String> _getArchiveLogs() async {
    if (kIsWeb) return '';

    try {
      final directory = await getApplicationDocumentsDirectory();
      final dir = Directory(directory.path);
      
      final archiveFiles = await dir
          .list()
          .where((file) => file.path.contains('app_logs.txt.archive'))
          .cast<File>()
          .toList();

      if (archiveFiles.isEmpty) return '';

      // Prendre seulement le fichier d'archive le plus récent
      archiveFiles.sort((a, b) => b.path.compareTo(a.path));
      final latestArchive = archiveFiles.first;

      final content = await latestArchive.readAsString();
      final lines = content.split('\n');
      
      // Limiter à 100 lignes pour les archives
      if (lines.length > 100) {
        return '${lines.take(100).join('\n')}\n... (${lines.length - 100} lignes archivées supprimées)';
      }
      
      return content;
    } catch (e) {
      return 'Erreur lors de la récupération des logs archivés: $e';
    }
  }

  /// Récupère les informations système
  Future<String> _getSystemInfo() async {
    final buffer = StringBuffer();
    
    try {
      // Informations de l'application
      final packageInfo = await PackageInfo.fromPlatform();
      buffer.writeln('INFORMATIONS APPLICATION:');
      buffer.writeln('- Nom: ${packageInfo.appName}');
      buffer.writeln('- Version: ${packageInfo.version}');
      buffer.writeln('- Build: ${packageInfo.buildNumber}');
      buffer.writeln('- Package: ${packageInfo.packageName}');
      buffer.writeln();

      // Informations de l'appareil
      final deviceInfo = DeviceInfoPlugin();
      buffer.writeln('INFORMATIONS APPAREIL:');
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        buffer.writeln('- Plateforme: Android ${androidInfo.version.release}');
        buffer.writeln('- API Level: ${androidInfo.version.sdkInt}');
        buffer.writeln('- Modèle: ${androidInfo.model}');
        buffer.writeln('- Fabricant: ${androidInfo.manufacturer}');
        buffer.writeln('- Appareil: ${androidInfo.device}');
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        buffer.writeln('- Plateforme: iOS ${iosInfo.systemVersion}');
        buffer.writeln('- Modèle: ${iosInfo.model}');
        buffer.writeln('- Nom: ${iosInfo.name}');
        buffer.writeln('- Identifiant: ${iosInfo.identifierForVendor}');
      } else if (Platform.isLinux) {
        final linuxInfo = await deviceInfo.linuxInfo;
        buffer.writeln('- Plateforme: Linux');
        buffer.writeln('- Distribution: ${linuxInfo.prettyName}');
        buffer.writeln('- Version: ${linuxInfo.version}');
      } else if (Platform.isWindows) {
        final windowsInfo = await deviceInfo.windowsInfo;
        buffer.writeln('- Plateforme: Windows');
        buffer.writeln('- Version: ${windowsInfo.displayVersion}');
        buffer.writeln('- Build: ${windowsInfo.buildNumber}');
      } else if (Platform.isMacOS) {
        final macInfo = await deviceInfo.macOsInfo;
        buffer.writeln('- Plateforme: macOS ${macInfo.osRelease}');
        buffer.writeln('- Modèle: ${macInfo.model}');
        buffer.writeln('- Architecture: ${macInfo.arch}');
      }
      
      buffer.writeln('- Mode debug: ${kDebugMode ? 'Activé' : 'Désactivé'}');
      buffer.writeln();

      // Informations de configuration
      buffer.writeln('CONFIGURATION:');
      // TODO: Ajouter ici des informations de configuration de l'app
      // comme l'URL de l'API, etc. (sans données sensibles)
      
    } catch (e) {
      buffer.writeln('Erreur lors de la récupération des informations système: $e');
    }

    return buffer.toString();
  }

  /// Copie seulement les logs d'erreur (niveaux ERROR et WTF)
  Future<bool> copyErrorLogsToClipboard() async {
    try {
      final logContent = await _logger.getLogContent();
      final lines = logContent.split('\n');
      
      // Filtrer seulement les lignes d'erreur
      final errorLines = lines.where((line) => 
        line.contains('[ERROR]') || line.contains('[WTF]')
      ).toList();

      if (errorLines.isEmpty) {
        await Clipboard.setData(const ClipboardData(
          text: 'Aucune erreur trouvée dans les logs.'
        ));
        return true;
      }

      final buffer = StringBuffer();
      buffer.writeln('LOGS D\'ERREUR - GEONATURE MOBILE');
      buffer.writeln('=' * 50);
      buffer.writeln('Date d\'export: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Nombre d\'erreurs: ${errorLines.length}');
      buffer.writeln();
      buffer.writeln(errorLines.join('\n'));

      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      
      _logger.i('Error logs copied to clipboard successfully', tag: 'LOG_EXPORT');
      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to copy error logs to clipboard',
        tag: 'LOG_EXPORT',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Copie les logs filtrés par tags spécifiques
  Future<bool> copyLogsByTags(List<String> tags) async {
    return await copyLogsToClipboard(
      filterTags: tags,
      includeSystemInfo: false,
      maxLines: 1000,
    );
  }

  /// Copie les logs récents (dernières 24h)
  Future<bool> copyRecentLogsToClipboard() async {
    try {
      final logContent = await _logger.getLogContent();
      final lines = logContent.split('\n');
      
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      
      // Filtrer les lignes des dernières 24h
      final recentLines = lines.where((line) {
        final dateMatch = RegExp(r'(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})').firstMatch(line);
        if (dateMatch != null) {
          try {
            final logDate = DateTime.parse(dateMatch.group(1)!);
            return logDate.isAfter(yesterday);
          } catch (e) {
            return false;
          }
        }
        return false;
      }).toList();

      final buffer = StringBuffer();
      buffer.writeln('LOGS RÉCENTS (24H) - GEONATURE MOBILE');
      buffer.writeln('=' * 50);
      buffer.writeln('Date d\'export: ${DateTime.now().toIso8601String()}');
      buffer.writeln('Période: ${yesterday.toIso8601String()} à ${now.toIso8601String()}');
      buffer.writeln('Nombre de lignes: ${recentLines.length}');
      buffer.writeln();
      buffer.writeln(recentLines.join('\n'));

      await Clipboard.setData(ClipboardData(text: buffer.toString()));
      
      _logger.i('Recent logs copied to clipboard successfully', tag: 'LOG_EXPORT');
      return true;
    } catch (e, stackTrace) {
      _logger.e(
        'Failed to copy recent logs to clipboard',
        tag: 'LOG_EXPORT',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  /// Obtient des statistiques sur les logs
  Future<Map<String, int>> getLogStatistics() async {
    try {
      final logContent = await _logger.getLogContent();
      final lines = logContent.split('\n');
      
      final stats = <String, int>{
        'total': lines.length,
        'verbose': 0,
        'debug': 0,
        'info': 0,
        'warning': 0,
        'error': 0,
        'wtf': 0,
      };

      for (final line in lines) {
        if (line.contains('[VERBOSE]')) {
          stats['verbose'] = stats['verbose']! + 1;
        } else if (line.contains('[DEBUG]')) {
          stats['debug'] = stats['debug']! + 1;
        } else if (line.contains('[INFO]')) {
          stats['info'] = stats['info']! + 1;
        } else if (line.contains('[WARNING]')) {
          stats['warning'] = stats['warning']! + 1;
        } else if (line.contains('[ERROR]')) {
          stats['error'] = stats['error']! + 1;
        } else if (line.contains('[WTF]')) {
          stats['wtf'] = stats['wtf']! + 1;
        }
      }

      return stats;
    } catch (e) {
      _logger.e('Failed to get log statistics', tag: 'LOG_EXPORT', error: e);
      return {};
    }
  }
}