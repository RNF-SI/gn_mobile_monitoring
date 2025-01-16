class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);

  @override
  String toString() {
    return 'DataParsingException: $message';
  }
}
