String formatDateTime(DateTime dateTime) {
  DateTime utcDateTime = dateTime.toUtc();
  return "${utcDateTime.year.toString().padLeft(4, '0')}-"
      "${utcDateTime.month.toString().padLeft(2, '0')}-"
      "${utcDateTime.day.toString().padLeft(2, '0')} "
      "${utcDateTime.hour.toString().padLeft(2, '0')}:"
      "${utcDateTime.minute.toString().padLeft(2, '0')}:"
      "${utcDateTime.second.toString().padLeft(2, '0')}."
      "${utcDateTime.millisecond.toString().padLeft(3, '0')}";
}
