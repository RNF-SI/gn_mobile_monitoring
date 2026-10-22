import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Version de l'application installée (ex: "1.1.1"), lue depuis pubspec.yaml
/// via package_info_plus.
final appVersionProvider = FutureProvider<String>((ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
});

/// Affiche « Monitoring v<version> ». N'affiche rien tant que la version
/// n'est pas chargée ou si elle est indisponible (ex: tests sans plugin).
class AppVersionText extends ConsumerWidget {
  const AppVersionText({super.key, this.style});

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final version = ref.watch(appVersionProvider).valueOrNull;
    if (version == null) return const SizedBox.shrink();
    return Text(
      'Monitoring v$version',
      key: const Key('app-version-text'),
      style: style,
    );
  }
}
