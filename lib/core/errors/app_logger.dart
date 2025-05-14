import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stack_trace/stack_trace.dart';

// Niveaux de log
enum LogLevel { verbose, debug, info, warning, error, wtf }

/// Un service de journalisation pour gérer et enregistrer les erreurs dans toute l'application.
/// Implémente une approche singleton pour assurer une instance unique.
class AppLogger {
  // Singleton
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  // Constantes pour formater
  static const String _tagFormat = '{tag}';
  static const String _messageFormat = '{message}';
  static const String _logLevelFormat = '{level}';
  static const String _timeFormat = '{time}';
  static const String _fileFormat = '{file}';
  static const String _lineFormat = '{line}';
  
  // Format du log
  static const String _format =
      '$_timeFormat [$_logLevelFormat] ($_fileFormat:$_lineFormat) $_tagFormat: $_messageFormat';

  // Limitation de taille du fichier de log
  static const int _maxLogSize = 5 * 1024 * 1024; // 5 MB

  // Chemin du fichier de log
  String? _logFilePath;

  /// Initialiser le logger
  Future<void> initialize() async {
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      _logFilePath = '${directory.path}/app_logs.txt';
      
      // Vérifier la taille du fichier et archiver si nécessaire
      await _checkAndArchiveLogFile();
    }
  }

  /// Vérifier la taille du fichier de log et l'archiver si nécessaire
  Future<void> _checkAndArchiveLogFile() async {
    if (_logFilePath == null) return;
    
    final file = File(_logFilePath!);
    if (await file.exists()) {
      final fileSize = await file.length();
      if (fileSize > _maxLogSize) {
        // Créer un fichier d'archive avec timestamp
        final now = DateTime.now().millisecondsSinceEpoch;
        final archiveFilePath = '${_logFilePath!}.archive.$now';
        await file.copy(archiveFilePath);
        await file.delete();
      }
    }
  }

  /// Log général avec niveau spécifié
  void log(
    LogLevel level,
    String message, {
    String tag = '',
    dynamic error,
    StackTrace? stackTrace,
  }) {
    // Capturer la stack trace si non fournie
    stackTrace ??= StackTrace.current;
    
    // Obtenir les informations de fichier et ligne
    final frame = Trace.from(stackTrace).frames.first;
    final fileName = frame.uri.pathSegments.last;
    final lineNumber = frame.line;

    // Format du texte de log
    final formattedLog = _format
        .replaceAll(_tagFormat, tag)
        .replaceAll(_messageFormat, message)
        .replaceAll(_logLevelFormat, level.toString().split('.').last.toUpperCase())
        .replaceAll(_timeFormat, DateTime.now().toIso8601String())
        .replaceAll(_fileFormat, fileName)
        .replaceAll(_lineFormat, lineNumber.toString());

    // Erreur formatée si présente
    String? errorLog;
    if (error != null) {
      errorLog = 'ERROR DETAILS: $error';
    }

    // Afficher dans la console
    switch (level) {
      case LogLevel.verbose:
      case LogLevel.debug:
      case LogLevel.info:
        debugPrint(formattedLog);
        if (errorLog != null) debugPrint(errorLog);
        break;
      case LogLevel.warning:
      case LogLevel.error:
      case LogLevel.wtf:
        debugPrint('\x1B[31m$formattedLog\x1B[0m'); // Rouge
        if (errorLog != null) debugPrint('\x1B[31m$errorLog\x1B[0m');
        break;
    }

    // Écrire dans le fichier log
    _writeToLogFile(formattedLog, errorLog, stackTrace);
  }

  /// Écrire dans le fichier log
  Future<void> _writeToLogFile(
    String logMessage, 
    String? errorDetails,
    StackTrace stackTrace
  ) async {
    if (_logFilePath == null || kIsWeb) return;

    try {
      final file = File(_logFilePath!);
      final exists = await file.exists();
      
      final sink = file.openWrite(
        mode: exists ? FileMode.append : FileMode.write,
      );
      
      // Écrire le message principal
      sink.writeln(logMessage);
      
      // Écrire les détails d'erreur si présents
      if (errorDetails != null) {
        sink.writeln(errorDetails);
      }
      
      // Écrire la stack trace
      sink.writeln('STACK TRACE:');
      sink.writeln(stackTrace.toString());
      sink.writeln('-' * 80); // Séparateur
      
      await sink.flush();
      await sink.close();
    } catch (e) {
      debugPrint('Failed to write to log file: $e');
    }
  }

  /// Récupérer le contenu du fichier log
  Future<String> getLogContent() async {
    if (_logFilePath == null || kIsWeb) return 'Logs non disponibles';
    
    try {
      final file = File(_logFilePath!);
      if (await file.exists()) {
        return await file.readAsString();
      }
      return 'Fichier de log vide';
    } catch (e) {
      return 'Erreur lors de la lecture du fichier de log: $e';
    }
  }

  // Méthodes pratiques pour différents niveaux de log
  void v(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.verbose, message, tag: tag, error: error, stackTrace: stackTrace);
      
  void d(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.debug, message, tag: tag, error: error, stackTrace: stackTrace);
      
  void i(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.info, message, tag: tag, error: error, stackTrace: stackTrace);
      
  void w(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.warning, message, tag: tag, error: error, stackTrace: stackTrace);
      
  void e(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.error, message, tag: tag, error: error, stackTrace: stackTrace);
      
  void wtf(String message, {String tag = '', dynamic error, StackTrace? stackTrace}) =>
      log(LogLevel.wtf, message, tag: tag, error: error, stackTrace: stackTrace);
}