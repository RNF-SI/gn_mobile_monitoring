import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/presentation/state/sync_status.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatus = ref.watch(syncStatusProvider);
    
    // Ne pas afficher ce widget si la synchronisation n'est pas en cours ou terminée récemment
    if (syncStatus.step == SyncStep.initial) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _getBackgroundColor(syncStatus),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _getIcon(syncStatus),
              const SizedBox(width: 12.0),
              Expanded(
                child: Text(
                  syncStatus.message,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              if (syncStatus.isInProgress)
                const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8AAC3E)),
                  ),
                ),
              if (syncStatus.step == SyncStep.complete || syncStatus.step == SyncStep.error)
                IconButton(
                  icon: const Icon(Icons.close, size: 16.0),
                  onPressed: () {
                    ref.read(syncServiceProvider).resetStatus();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          if (syncStatus.errorDetails != null) ...[
            const SizedBox(height: 8.0),
            Text(
              syncStatus.errorDetails!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 12.0,
              ),
            ),
          ],
          if (syncStatus.isInProgress && syncStatus.progress != null) ...[
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: syncStatus.progress,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8AAC3E)),
            ),
          ],
        ],
      ),
    );
  }

  Color _getBackgroundColor(SyncStatus status) {
    switch (status.step) {
      case SyncStep.error:
        return Colors.red[100]!;
      case SyncStep.complete:
        return Colors.green[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  Widget _getIcon(SyncStatus status) {
    switch (status.step) {
      case SyncStep.error:
        return Icon(Icons.error_outline, color: Colors.red[700]);
      case SyncStep.complete:
        return Icon(Icons.check_circle_outline, color: Colors.green[700]);
      case SyncStep.syncingModules:
      case SyncStep.syncingSites:
      case SyncStep.syncingSiteGroups:
        return const Icon(Icons.sync, color: Color(0xFF8AAC3E));
      default:
        return const Icon(Icons.info_outline, color: Colors.grey);
    }
  }
}