import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/presentation/model/moduleInfo.dart';
import 'package:gn_mobile_monitoring/presentation/state/module_download_status.dart';
import 'package:intl/intl.dart';

class ModuleDetailPage extends StatelessWidget {
  final ModuleInfo moduleInfo;

  const ModuleDetailPage({super.key, required this.moduleInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleInfo.module.moduleLabel ?? 'Module Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                moduleInfo.module.moduleLabel ?? 'No Label',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              // Description Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF598979),
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        moduleInfo.module.moduleDesc ?? 'No Description',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _buildInfoItems().length,
                itemBuilder: (context, index) {
                  final item = _buildInfoItems()[index];
                  return _buildInfoSection(context, item.title, item.content);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF598979), // Brand color
                  ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<_InfoItem> _buildInfoItems() {
    final items = <_InfoItem>[
      _InfoItem('Module Code', moduleInfo.module.moduleCode ?? 'N/A'),
      _InfoItem('Module Group', moduleInfo.module.moduleGroup ?? 'N/A'),
      _InfoItem('Module Path', moduleInfo.module.modulePath ?? 'N/A'),
      _InfoItem('Module ID', moduleInfo.module.id.toString()),
      _InfoItem(
          'Download Status',
          moduleInfo.downloadStatus == ModuleDownloadStatus.moduleDownloaded
              ? 'Downloaded'
              : 'Not Downloaded'),
    ];

    // Add optional items
    if (moduleInfo.module.moduleExternalUrl != null) {
      items
          .add(_InfoItem('External URL', moduleInfo.module.moduleExternalUrl!));
    }
    if (moduleInfo.module.moduleTarget != null) {
      items.add(_InfoItem('Target', moduleInfo.module.moduleTarget!));
    }
    if (moduleInfo.module.moduleComment != null) {
      items.add(_InfoItem('Comments', moduleInfo.module.moduleComment!));
    }
    if (moduleInfo.module.moduleDocUrl != null) {
      items
          .add(_InfoItem('Documentation URL', moduleInfo.module.moduleDocUrl!));
    }
    if (moduleInfo.module.ngModule != null) {
      items.add(_InfoItem('NG Module', moduleInfo.module.ngModule!));
    }
    if (moduleInfo.module.metaCreateDate != null) {
      items.add(_InfoItem(
          'Created',
          DateFormat('dd/MM/yyyy HH:mm')
              .format(moduleInfo.module.metaCreateDate!)));
    }
    if (moduleInfo.module.metaUpdateDate != null) {
      items.add(_InfoItem(
          'Last Updated',
          DateFormat('dd/MM/yyyy HH:mm')
              .format(moduleInfo.module.metaUpdateDate!)));
    }

    return items;
  }
}

class _InfoItem {
  final String title;
  final String content;

  _InfoItem(this.title, this.content);
}
