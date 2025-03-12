import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';

class SiteDetailPage extends StatelessWidget {
  final BaseSite site;

  const SiteDetailPage({
    super.key,
    required this.site,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(site.baseSiteName ?? 'Détails du site'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Propriétés',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildPropertyRow('Nom', site.baseSiteName ?? ''),
                  _buildPropertyRow('Code', site.baseSiteCode ?? ''),
                  _buildPropertyRow(
                      'Description', site.baseSiteDescription ?? ''),
                  _buildPropertyRow(
                    'Altitude',
                    site.altitudeMin != null &&
                            site.altitudeMax != null
                        ? '${site.altitudeMin}-${site.altitudeMax}m'
                        : site.altitudeMin?.toString() ??
                            site.altitudeMax?.toString() ??
                            '',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
