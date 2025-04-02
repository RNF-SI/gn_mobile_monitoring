import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';

// Provider pour récupérer les nomenclatures par type de code
final nomenclaturesByTypeProvider =
    FutureProvider.family<List<Nomenclature>, String>(
  (ref, typeCode) async {
    final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);
    return await nomenclatureService.getNomenclaturesByTypeCode(typeCode);
  },
);

class NomenclatureSelectorWidget extends ConsumerWidget {
  final String label;
  final Map<String, dynamic> fieldConfig;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final Map<String, dynamic>? value;
  final bool isRequired;

  const NomenclatureSelectorWidget({
    Key? key,
    required this.label,
    required this.fieldConfig,
    required this.onChanged,
    this.value,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typeCode = FormConfigParser.getNomenclatureTypeCode(fieldConfig);
    if (typeCode == null) {
      return const Text('Type de nomenclature non spécifié');
    }

    final cdNomenclature = value != null
        ? value!['cd_nomenclature'] as String?
        : FormConfigParser.getSelectedNomenclatureCode(fieldConfig);

    final nomenclaturesAsync = ref.watch(nomenclaturesByTypeProvider(typeCode));

    return nomenclaturesAsync.when(
      data: (nomenclatures) {
        // Construction des éléments de la liste déroulante
        final items = <DropdownMenuItem<String>>[];

        if (!isRequired) {
          // Ajouter un élément vide si le champ n'est pas requis
          items.add(const DropdownMenuItem<String>(
            value: null,
            child: Text('-- Sélectionner --'),
          ));
        }

        // Ajouter les éléments de nomenclature
        // Créer un mapping entre cd_nomenclature et nomenclature complète
        final nomenclatureMap = {
          for (var n in nomenclatures) n.cdNomenclature: n
        };
        
        for (final nomenclature in nomenclatures) {
          final label = nomenclature.labelFr ??
              nomenclature.labelDefault ??
              nomenclature.cdNomenclature;

          items.add(DropdownMenuItem<String>(
            value: nomenclature.cdNomenclature,
            child: Text(label),
          ));
        }

        return DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          isExpanded: true,
          value: cdNomenclature,
          items: items,
          onChanged: (value) {
            if (value == null) {
              onChanged(null);
            } else {
              // Récupérer la nomenclature complète pour obtenir son ID
              final selectedNomenclature = nomenclatureMap[value];
              
              if (selectedNomenclature != null) {
                onChanged({
                  'id': selectedNomenclature.id,
                  'code_nomenclature_type': typeCode,
                  'cd_nomenclature': value,
                  'label': selectedNomenclature.labelFr ?? 
                           selectedNomenclature.labelDefault ?? 
                           selectedNomenclature.cdNomenclature,
                });
              } else {
                onChanged({
                  'code_nomenclature_type': typeCode,
                  'cd_nomenclature': value,
                });
              }
            }
          },
          validator: isRequired
              ? (value) => value == null ? 'Ce champ est obligatoire' : null
              : null,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Text('Erreur: $error'),
    );
  }
}
