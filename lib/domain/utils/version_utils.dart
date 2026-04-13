/// Utilitaires de parsing et comparaison de versions pour le module monitoring.

class MonitoringVersion implements Comparable<MonitoringVersion> {
  final int major;
  final int minor;
  final int patch;
  final String? preRelease; // rc, dev, beta, etc.

  const MonitoringVersion(this.major, this.minor, this.patch,
      {this.preRelease});

  /// Parse une chaîne de version comme "1.2.0", "1.2.0rc1", "1.2", "1"
  /// Retourne null si la chaîne est vide ou ne peut pas être parsée.
  static MonitoringVersion? tryParse(String? versionString) {
    if (versionString == null || versionString.trim().isEmpty) {
      return null;
    }

    final trimmed = versionString.trim();

    // Séparer la partie numérique du suffixe pre-release
    // Ex: "1.2.0rc1" → numérique="1.2.0", preRelease="rc1"
    final preReleaseMatch = RegExp(r'^([\d.]+)(.+)?$').firstMatch(trimmed);
    if (preReleaseMatch == null) return null;

    final numericPart = preReleaseMatch.group(1)!;
    final preReleasePart = preReleaseMatch.group(2);

    final parts = numericPart.split('.');
    if (parts.isEmpty) return null;

    try {
      final major = int.parse(parts[0]);
      final minor = parts.length > 1 ? int.parse(parts[1]) : 0;
      final patch = parts.length > 2 ? int.parse(parts[2]) : 0;

      return MonitoringVersion(
        major,
        minor,
        patch,
        preRelease: preReleasePart,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  int compareTo(MonitoringVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);

    // Une version avec pre-release est inférieure à la même sans
    // Ex: 1.2.0rc1 < 1.2.0
    if (preRelease != null && other.preRelease == null) return -1;
    if (preRelease == null && other.preRelease != null) return 1;

    return 0;
  }

  bool operator <(MonitoringVersion other) => compareTo(other) < 0;
  bool operator >(MonitoringVersion other) => compareTo(other) > 0;
  bool operator <=(MonitoringVersion other) => compareTo(other) <= 0;
  bool operator >=(MonitoringVersion other) => compareTo(other) >= 0;

  @override
  bool operator ==(Object other) =>
      other is MonitoringVersion &&
      major == other.major &&
      minor == other.minor &&
      patch == other.patch &&
      preRelease == other.preRelease;

  @override
  int get hashCode => Object.hash(major, minor, patch, preRelease);

  @override
  String toString() => '$major.$minor.$patch${preRelease ?? ''}';
}

/// Source unique de vérité pour les exigences de version
class VersionRequirements {
  /// Version minimale du module monitoring requise par l'application
  static const minimumMonitoring = MonitoringVersion(1, 2, 0);
}
