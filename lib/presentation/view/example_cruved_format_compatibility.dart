import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/domain/model/cruved_response.dart';

/// Page d'exemple pour démontrer la compatibilité avec les deux formats CRUVED
class CruvedFormatCompatibilityExamplePage extends StatelessWidget {
  const CruvedFormatCompatibilityExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUVED Format Compatibility'),
        backgroundColor: Colors.teal,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderSection(),
            SizedBox(height: 20),
            _BooleanFormatSection(),
            SizedBox(height: 20),
            _NumericFormatSection(),
            SizedBox(height: 20),
            _MixedFormatSection(),
            SizedBox(height: 20),
            _ConversionExampleSection(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CRUVED Format Compatibility',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Cette page démontre comment CruvedResponse peut maintenant '
              'gérer à la fois les formats booléens et numériques des '
              'permissions CRUVED retournées par les différents endpoints de l\'API.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class _BooleanFormatSection extends StatelessWidget {
  const _BooleanFormatSection();

  @override
  Widget build(BuildContext context) {
    // Format booléen comme retourné par /monitorings/object/{module}/site/{id}
    const jsonString = '''
    {
      "C": true,
      "D": true,
      "E": false,
      "R": true,
      "U": true,
      "V": false
    }
    ''';

    final Map<String, dynamic> json = jsonDecode(jsonString);
    final cruved = CruvedResponse.fromJson(json);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Format Booléen (Site spécifique)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Endpoint: /monitorings/object/{module}/site/{id}',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                jsonString.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            _PermissionResults(cruved: cruved),
          ],
        ),
      ),
    );
  }
}

class _NumericFormatSection extends StatelessWidget {
  const _NumericFormatSection();

  @override
  Widget build(BuildContext context) {
    // Format numérique comme retourné par /monitorings/modules
    const jsonString = '''
    {
      "C": 0,
      "D": 0,
      "E": 3,
      "R": 3,
      "U": 3,
      "V": 0
    }
    ''';

    final Map<String, dynamic> json = jsonDecode(jsonString);
    final cruved = CruvedResponse.fromJson(json);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.numbers, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Format Numérique (Module global)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Endpoint: /monitorings/modules',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 4),
            const Text(
              'Valeurs: 0=aucun accès, 1=mes données, 2=mon organisme, 3=toutes données',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                jsonString.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            _PermissionResults(cruved: cruved),
          ],
        ),
      ),
    );
  }
}

class _MixedFormatSection extends StatelessWidget {
  const _MixedFormatSection();

  @override
  Widget build(BuildContext context) {
    // Format mixte pour démontrer la robustesse
    const jsonString = '''
    {
      "C": true,
      "D": 0,
      "E": "false",
      "R": 3,
      "U": 1,
      "V": false
    }
    ''';

    final Map<String, dynamic> json = jsonDecode(jsonString);
    final cruved = CruvedResponse.fromJson(json);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.shuffle, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Format Mixte (Robustesse)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Gère gracieusement les formats mixtes (booléen, numérique, string)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                jsonString.trim(),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(height: 12),
            _PermissionResults(cruved: cruved),
          ],
        ),
      ),
    );
  }
}

class _ConversionExampleSection extends StatelessWidget {
  const _ConversionExampleSection();

  @override
  Widget build(BuildContext context) {
    const cruved = CruvedResponse(
      create: true,
      read: false,
      update: true,
      validate: false,
      export: true,
      delete: false,
    );

    final scopeMap = cruved.toScopeMap();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.transform, color: Colors.purple),
                SizedBox(width: 8),
                Text(
                  'Conversion vers format numérique',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Permissions booléennes:'),
            const SizedBox(height: 8),
            _PermissionResults(cruved: cruved),
            const SizedBox(height: 16),
            const Text('Converties en valeurs de scope:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                scopeMap.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n'),
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionResults extends StatelessWidget {
  const _PermissionResults({required this.cruved});

  final CruvedResponse cruved;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _PermissionChip('Create', cruved.create),
        _PermissionChip('Read', cruved.read),
        _PermissionChip('Update', cruved.update),
        _PermissionChip('Validate', cruved.validate),
        _PermissionChip('Export', cruved.export),
        _PermissionChip('Delete', cruved.delete),
      ],
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.label, this.hasPermission);

  final String label;
  final bool hasPermission;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: hasPermission ? Colors.white : Colors.grey[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: hasPermission ? Colors.green : Colors.grey[300],
      avatar: Icon(
        hasPermission ? Icons.check : Icons.close,
        size: 16,
        color: hasPermission ? Colors.white : Colors.grey[700],
      ),
    );
  }
}