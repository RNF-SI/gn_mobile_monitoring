import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';

/// Widget de sélection de taxon pour les formulaires
class TaxonSelectorWidget extends ConsumerStatefulWidget {
  final String label;
  final Map<String, dynamic>? fieldConfig;
  final ValueChanged<int?> onChanged;
  final int? value; // cd_nom du taxon sélectionné
  final bool isRequired;
  final int moduleId;
  final String displayMode;

  const TaxonSelectorWidget({
    Key? key,
    required this.moduleId,
    required this.onChanged,
    this.label = 'Taxon',
    this.fieldConfig,
    this.value,
    this.isRequired = false,
    this.displayMode = 'nom_vern,lb_nom',
  }) : super(key: key);

  @override
  ConsumerState<TaxonSelectorWidget> createState() =>
      _TaxonSelectorWidgetState();
}

class _TaxonSelectorWidgetState extends ConsumerState<TaxonSelectorWidget> {
  final TextEditingController _searchController = TextEditingController();
  Taxon? _selectedTaxon;
  List<Taxon> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeSelectedTaxon();
  }

  Future<void> _initializeSelectedTaxon() async {
    if (widget.value != null) {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final taxon = await taxonService.getTaxonByCdNom(widget.value!);

      if (mounted && taxon != null) {
        setState(() {
          _selectedTaxon = taxon;
          _searchController.text = _formatDisplayName(taxon);
        });
      }
    }
  }

  @override
  void didUpdateWidget(TaxonSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _updateSelectedTaxon();
    }
  }

  Future<void> _updateSelectedTaxon() async {
    if (widget.value == null) {
      if (mounted) {
        setState(() {
          _selectedTaxon = null;
          _searchController.clear();
        });
      }
      return;
    }

    if (_selectedTaxon?.cdNom != widget.value) {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final taxon = await taxonService.getTaxonByCdNom(widget.value!);

      if (mounted && taxon != null) {
        setState(() {
          _selectedTaxon = taxon;
          _searchController.text = _formatDisplayName(taxon);
        });
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Format le nom d'affichage d'un taxon selon le format configuré
  String _formatDisplayName(Taxon taxon) {
    final String displayFormat;
    if (widget.fieldConfig != null) {
      displayFormat =
          FormConfigParser.getTaxonomyDisplayFormat(widget.fieldConfig!);
    } else {
      displayFormat = widget.displayMode;
    }

    final taxonService = ref.read(taxonServiceProvider.notifier);
    return taxonService.formatTaxonDisplay(taxon, displayFormat);
  }

  /// Recherche des taxons
  Future<void> _searchTaxons(String query) async {
    if (query.length < 3) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final results = await taxonService.searchTaxons(query);

      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Déterminer la liste taxonomique à utiliser
    int? listId;
    if (widget.fieldConfig != null) {
      listId = FormConfigParser.getTaxonListId(widget.fieldConfig!);
    }

    // Récupérer les taxons via le provider approprié
    final taxonsAsync = listId != null
        ? ref.watch(taxonsByListProvider(listId))
        : ref.watch(taxonsByModuleProvider(widget.moduleId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Champ de recherche/affichage
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: widget.isRequired ? '${widget.label} *' : widget.label,
            hintText: 'Rechercher un taxon...',
            suffixIcon: _selectedTaxon != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedTaxon = null;
                        _searchController.clear();
                        _searchResults = [];
                        widget.onChanged(null);
                      });
                    },
                  )
                : const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          readOnly: _selectedTaxon != null,
          onChanged: (value) {
            if (value.length >= 3) {
              _searchTaxons(value);
            } else {
              setState(() {
                _searchResults = [];
              });
            }
          },
          validator: widget.isRequired
              ? (value) =>
                  (_selectedTaxon == null) ? 'Ce champ est obligatoire' : null
              : null,
        ),

        // Résultats de recherche
        if (_isSearching)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 150),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final taxon = _searchResults[index];
                final displayName = _formatDisplayName(taxon);

                return ListTile(
                  title: Text(displayName),
                  dense: true,
                  onTap: () {
                    setState(() {
                      _selectedTaxon = taxon;
                      _searchController.text = displayName;
                      _searchResults = [];
                    });
                    widget.onChanged(taxon.cdNom);
                  },
                );
              },
            ),
          ),

        // Liste de suggestions basée sur module/liste
        if (_searchController.text.isEmpty && _selectedTaxon == null)
          taxonsAsync.when(
            data: (taxons) {
              if (taxons.isEmpty) {
                return const SizedBox.shrink();
              }

              final displayTaxons =
                  taxons.length > 10 ? taxons.sublist(0, 10) : taxons;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Suggestions:',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      children: displayTaxons.map((taxon) {
                        final displayName = _formatDisplayName(taxon);
                        return ChoiceChip(
                          label: Text(displayName,
                              style: const TextStyle(fontSize: 12)),
                          selected: false,
                          onSelected: (_) {
                            setState(() {
                              _selectedTaxon = taxon;
                              _searchController.text = displayName;
                            });
                            widget.onChanged(taxon.cdNom);
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
      ],
    );
  }
}
