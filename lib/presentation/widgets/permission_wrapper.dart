import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/constants/permission_constants.dart';
import 'package:gn_mobile_monitoring/domain/usecase/check_permission_usecase.dart';

class PermissionWrapper extends ConsumerWidget {
  final Widget child;
  final Widget? fallback;
  final int idModule;
  final String objectCode;
  final String actionCode;

  const PermissionWrapper({
    super.key,
    required this.child,
    required this.idModule,
    required this.objectCode,
    required this.actionCode,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(
        checkPermissionUseCaseProvider(idModule, objectCode, actionCode));

    return permission.when(
      data: (hasPermission) => hasPermission ? child : (fallback ?? const SizedBox.shrink()),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => fallback ?? const SizedBox.shrink(),
    );
  }
}

class PermissionButton extends ConsumerWidget {
  final VoidCallback? onPressed;
  final String label;
  final int idModule;
  final String objectCode;
  final String actionCode;
  final IconData? icon;

  const PermissionButton({
    super.key,
    this.onPressed,
    required this.label,
    required this.idModule,
    required this.objectCode,
    required this.actionCode,
    this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(
        checkPermissionUseCaseProvider(idModule, objectCode, actionCode));

    return permission.when(
      data: (hasPermission) {
        if (!hasPermission) return const SizedBox.shrink();
        
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: Icon(icon),
                label: Text(label),
              )
            : ElevatedButton(
                onPressed: onPressed,
                child: Text(label),
              );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }
}

// Extension pour faciliter l'utilisation
extension PermissionWidgetExtensions on Widget {
  Widget withPermission({
    required int idModule,
    required String objectCode,
    required String actionCode,
    Widget? fallback,
  }) {
    return PermissionWrapper(
      idModule: idModule,
      objectCode: objectCode,
      actionCode: actionCode,
      fallback: fallback,
      child: this,
    );
  }
}

// Exemples d'utilisation spécifique
class SitePermissionButtons extends StatelessWidget {
  final int idModule;
  final VoidCallback? onCreateSite;
  final VoidCallback? onEditSite;
  final VoidCallback? onDeleteSite;

  const SitePermissionButtons({
    super.key,
    required this.idModule,
    this.onCreateSite,
    this.onEditSite,
    this.onDeleteSite,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PermissionButton(
          idModule: idModule,
          objectCode: PermissionConstants.monitoringSites,
          actionCode: PermissionConstants.actionCreate,
          label: 'Créer site',
          icon: Icons.add,
          onPressed: onCreateSite,
        ),
        const SizedBox(width: 8),
        PermissionButton(
          idModule: idModule,
          objectCode: PermissionConstants.monitoringSites,
          actionCode: PermissionConstants.actionUpdate,
          label: 'Modifier',
          icon: Icons.edit,
          onPressed: onEditSite,
        ),
        const SizedBox(width: 8),
        PermissionButton(
          idModule: idModule,
          objectCode: PermissionConstants.monitoringSites,
          actionCode: PermissionConstants.actionDelete,
          label: 'Supprimer',
          icon: Icons.delete,
          onPressed: onDeleteSite,
        ),
      ],
    );
  }
}