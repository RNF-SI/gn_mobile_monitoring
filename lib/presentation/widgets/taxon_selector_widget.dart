import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/form_config_parser.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';

// On utilise les providers existants définis dans taxon_service.dart

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
  List<Taxon> _allTaxons = [];
  List<Taxon> _filteredTaxons = [];
  Taxon? _selectedTaxon;
  bool _isLoading = false;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _loadInitialTaxons();
  }

  Future<void> _loadInitialTaxons() async {
    setState(() {
      _isLoading = true;
    });

    // Charger les taxons pour le module ou la liste
    final taxonService = ref.read(taxonServiceProvider.notifier);

    // Déterminer si on doit charger par liste ou par module
    int? listId;
    if (widget.fieldConfig != null) {
      listId = FormConfigParser.getTaxonListId(widget.fieldConfig!);
    }

    final List<Taxon> taxons;
    if (listId != null) {
      taxons = await taxonService.getTaxonsByListId(listId);
    } else {
      taxons = await taxonService.getTaxonsByModuleId(widget.moduleId);
    }

    // Initialiser avec la valeur existante si disponible
    if (widget.value != null) {
      final selectedTaxon =
          taxons.where((t) => t.cdNom == widget.value).firstOrNull;

      if (selectedTaxon != null) {
        _selectedTaxon = selectedTaxon;
        _searchController.text = _formatDisplayName(selectedTaxon);
      } else {
        // Si le taxon n'est pas dans la liste, essayer de le récupérer directement
        final taxon = await taxonService.getTaxonByCdNom(widget.value!);
        if (taxon != null) {
          _selectedTaxon = taxon;
          _searchController.text = _formatDisplayName(taxon);
        }
      }
    }

    if (mounted) {
      setState(() {
        _allTaxons = taxons;
        _filteredTaxons = _searchController.text.isNotEmpty
            ? _filterTaxonsBySearchTerm(_searchController.text)
            : [];
        _isLoading = false;
      });
    }
  }

  @override
  void didUpdateWidget(TaxonSelectorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Si la valeur change dans le parent, mettre à jour le taxon sélectionné
    if (oldWidget.value != widget.value) {
      if (widget.value == null) {
        setState(() {
          _selectedTaxon = null;
          _searchController.clear();
        });
      } else if (_selectedTaxon?.cdNom != widget.value) {
        _updateSelectedTaxon();
      }
    }
  }

  Future<void> _updateSelectedTaxon() async {
    if (widget.value == null) return;

    // D'abord chercher dans la liste des taxons déjà chargés
    final existingTaxon =
        _allTaxons.where((t) => t.cdNom == widget.value).firstOrNull;

    if (existingTaxon != null) {
      setState(() {
        _selectedTaxon = existingTaxon;
        _searchController.text = _formatDisplayName(existingTaxon);
      });
      return;
    }

    // Sinon, récupérer le taxon depuis la base de données
    final taxonService = ref.read(taxonServiceProvider.notifier);
    final taxon = await taxonService.getTaxonByCdNom(widget.value!);

    if (mounted && taxon != null) {
      setState(() {
        _selectedTaxon = taxon;
        _searchController.text = _formatDisplayName(taxon);
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Formatte le nom d'affichage d'un taxon selon le format configuré
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

  /// Filtre les taxons par terme de recherche
  List<Taxon> _filterTaxonsBySearchTerm(String searchTerm) {
    if (searchTerm.isEmpty) return [];

    final searchLower = searchTerm.toLowerCase();

    return _allTaxons
        .where((taxon) {
          return (taxon.nomComplet.toLowerCase().contains(searchLower)) ||
              (taxon.lbNom?.toLowerCase().contains(searchLower) ?? false) ||
              (taxon.nomVern?.toLowerCase().contains(searchLower) ?? false);
        })
        .take(50)
        .toList(); // Limiter les résultats pour des performances
  }

  /// Effectue une recherche dans la base de données pour trouver des taxons
  Future<void> _searchTaxonsInDatabase(String searchTerm) async {
    if (searchTerm.length < 3) {
      setState(() {
        _filteredTaxons = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final results = await taxonService.searchTaxons(searchTerm);

      if (mounted) {
        setState(() {
          _filteredTaxons = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _filteredTaxons = [];
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isRequired ? '${widget.label} *' : widget.label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Champ de recherche
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher un taxon...',
            suffixIcon: _selectedTaxon != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedTaxon = null;
                        _searchController.clear();
                        _filteredTaxons = [];
                        widget.onChanged(null);
                      });
                    },
                  )
                : const Icon(Icons.search),
            border: const OutlineInputBorder(),
          ),
          readOnly: _selectedTaxon != null,
          onChanged: (value) {
            // Si on a déjà beaucoup de taxons chargés, filtrer localement
            if (_allTaxons.length > 100) {
              setState(() {
                _filteredTaxons = _filterTaxonsBySearchTerm(value);
              });
            } else if (value.length >= 3) {
              // Sinon faire une recherche en base de données
              _searchTaxonsInDatabase(value);
            } else if (value.isEmpty) {
              setState(() {
                _filteredTaxons = [];
              });
            }
          },
          onTap: () {
            setState(() {
              _isSearchFocused = true;
            });
          },
          validator: widget.isRequired
              ? (value) =>
                  (_selectedTaxon == null) ? 'Ce champ est obligatoire' : null
              : null,
        ),

        // Affichage du message de chargement ou de la liste de résultats
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_filteredTaxons.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredTaxons.length,
              itemBuilder: (context, index) {
                final taxon = _filteredTaxons[index];
                final displayName = _formatDisplayName(taxon);

                return ListTile(
                  title: Text(displayName),
                  subtitle: Text('CD_NOM: ${taxon.cdNom}'),
                  dense: true,
                  onTap: () {
                    setState(() {
                      _selectedTaxon = taxon;
                      _searchController.text = displayName;
                      _filteredTaxons = [];
                      _isSearchFocused = false;
                    });
                    widget.onChanged(taxon.cdNom);
                  },
                );
              },
            ),
          ),

        // Si on n'a pas de résultats et qu'on est en recherche
        if (_searchController.text.isNotEmpty &&
            _filteredTaxons.isEmpty &&
            !_isLoading &&
            _isSearchFocused)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              'Aucun taxon trouvé, essayez un autre terme ou contactez l\'administrateur',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ),
      ],
    );
  }
}
