import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/nomenclature.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/nomenclature_service.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/sync_service.dart';

/// Widget pour la sélection multiple de nomenclatures
/// Stocke les valeurs sous forme de liste d'IDs [id1, id2, id3]
/// Compatible avec le format utilisé par le backend GeoNature
class MultipleNomenclatureSelectorWidget extends ConsumerStatefulWidget {
  final String label;
  final Map<String, dynamic> fieldConfig;
  final ValueChanged<List<int>?> onChanged;
  final List<int>? value;
  final bool isRequired;
  final String? description;

  const MultipleNomenclatureSelectorWidget({
    super.key,
    required this.label,
    required this.fieldConfig,
    required this.onChanged,
    this.value,
    this.isRequired = false,
    this.description,
  });

  @override
  ConsumerState<MultipleNomenclatureSelectorWidget> createState() =>
      _MultipleNomenclatureSelectorWidgetState();
}

class _MultipleNomenclatureSelectorWidgetState
    extends ConsumerState<MultipleNomenclatureSelectorWidget> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.value?.toSet() ?? {};
  }

  @override
  void didUpdateWidget(MultipleNomenclatureSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Mettre à jour les sélections si la valeur externe change
    if (widget.value != oldWidget.value) {
      setState(() {
        _selectedIds = widget.value?.toSet() ?? {};
      });
    }
  }

  void _toggleNomenclature(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });

    // Notifier le parent du changement
    final selectedList = _selectedIds.toList();
    widget.onChanged(selectedList.isEmpty ? null : selectedList);
  }

  @override
  Widget build(BuildContext context) {
    final typeCode = FormConfigParser.getNomenclatureTypeCode(widget.fieldConfig);
    if (typeCode == null) {
      return const Text('Type de nomenclature non spécifié');
    }

    final nomenclaturesAsync = ref.watch(nomenclaturesByTypeProvider(typeCode));

    return nomenclaturesAsync.when(
      data: (nomenclatures) {
        if (nomenclatures.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isRequired ? '${widget.label} *' : widget.label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (widget.description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                    child: Text(
                      widget.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                const Text(
                  'Aucune nomenclature disponible',
                  style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label et description
              Text(
                widget.isRequired ? '${widget.label} *' : widget.label,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (widget.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Text(
                    widget.description!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Container avec bordure pour regrouper les checkboxes
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: [
                    // En-tête avec compteur
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.checklist, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${_selectedIds.length} sélectionné(s)',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          if (_selectedIds.isNotEmpty)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIds.clear();
                                });
                                widget.onChanged(null);
                              },
                              child: const Text('Tout désélectionner'),
                            ),
                        ],
                      ),
                    ),

                    // Liste des nomenclatures avec checkboxes
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 300, // Hauteur max pour éviter un widget trop grand
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: nomenclatures.length,
                        itemBuilder: (context, index) {
                          final nomenclature = nomenclatures[index];
                          final label = nomenclature.labelFr ??
                              nomenclature.labelDefault ??
                              nomenclature.cdNomenclature;
                          final isSelected = _selectedIds.contains(nomenclature.id);

                          return CheckboxListTile(
                            dense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            title: Text(label),
                            value: isSelected,
                            onChanged: (bool? checked) {
                              _toggleNomenclature(nomenclature.id);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),

                    // Message de validation si requis et vide
                    if (widget.isRequired && _selectedIds.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border(
                            top: BorderSide(color: Colors.red.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                              size: 16,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Au moins une sélection est requise',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.only(bottom: 13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRequired ? '${widget.label} *' : widget.label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.only(bottom: 13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isRequired ? '${widget.label} *' : widget.label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Erreur de chargement: $error',
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

// Provider pour récupérer les nomenclatures par type de code
// (réutilisé depuis nomenclature_selector_widget.dart)
final nomenclaturesByTypeProvider =
    FutureProvider.autoDispose.family<List<Nomenclature>, String>(
  (ref, typeCode) async {
    // Observer la version du cache pour forcer le rafraîchissement après sync
    ref.watch(cacheVersionProvider);

    final nomenclatureService = ref.read(nomenclatureServiceProvider.notifier);
    return await nomenclatureService.getNomenclaturesByTypeCode(typeCode);
  },
);
