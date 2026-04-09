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

  /// ID de la liste taxonomique du module (niveau module)
  /// Cette liste est utilisée comme fallback si aucune liste n'est spécifiée au niveau du champ
  final int? idListTaxonomy;

  /// Indique si l'utilisateur a explicitement supprimé la valeur
  /// Cela empêche la restauration automatique des valeurs par défaut
  final bool userCleared;

  const TaxonSelectorWidget({
    super.key,
    required this.moduleId,
    required this.onChanged,
    this.label = 'Taxon',
    this.fieldConfig,
    this.value,
    this.isRequired = false,
    this.displayMode = 'nom_vern,lb_nom',
    this.idListTaxonomy,
    this.userCleared = false,
  });

  @override
  ConsumerState<TaxonSelectorWidget> createState() =>
      _TaxonSelectorWidgetState();
}

class _TaxonSelectorWidgetState extends ConsumerState<TaxonSelectorWidget> {
  final TextEditingController _searchController = TextEditingController();
  Taxon? _selectedTaxon;
  List<Taxon> _searchResults = [];
  bool _isSearching = false;
  bool _isInitializing = true;
  bool _userHasInteracted = false;

  /// Obtient l'ID de la liste taxonomique à utiliser
  /// Priorise la liste du champ (fieldConfig) sur celle du module
  int? _getEffectiveListId() {
    // 1. Vérifier d'abord si une liste est spécifiée au niveau du champ
    if (widget.fieldConfig != null) {
      final fieldListId = FormConfigParser.getTaxonListId(widget.fieldConfig!);
      if (fieldListId != null) return fieldListId;
    }

    // 2. Si pas de liste au niveau du champ, utiliser celle du module
    return widget.idListTaxonomy;
  }

  @override
  void initState() {
    super.initState();
    _initializeSelectedTaxon();
  }

  Future<void> _initializeSelectedTaxon() async {
    // Si l'utilisateur a explicitement supprimé la valeur, ne pas la restaurer
    if (widget.userCleared) {
      if (mounted) {
        setState(() {
          _selectedTaxon = null;
          _searchController.clear();
        });
        _isInitializing = false;
      }
      return;
    }

    // Déterminer la valeur à utiliser - priorité au widget.value, puis aux defaults du fieldConfig
    int? cdNomToLoad = widget.value;
    bool isLoadingFromConfig = false;
    
    // Si aucune valeur n'est fournie, essayer d'extraire depuis la configuration
    // MAIS seulement lors de la première initialisation
    if (cdNomToLoad == null && _isInitializing && widget.fieldConfig != null) {
      final defaultValue = widget.fieldConfig!['default'] ?? widget.fieldConfig!['value'];
      if (defaultValue is int) {
        cdNomToLoad = defaultValue;
        isLoadingFromConfig = true;
      } else if (defaultValue is Map && defaultValue['cd_nom'] != null) {
        cdNomToLoad = defaultValue['cd_nom'] as int?;
        isLoadingFromConfig = true;
      }
    }
    
    if (cdNomToLoad != null) {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final taxon = await taxonService.getTaxonByCdNom(cdNomToLoad);

      // Vérifier si le taxon appartient à la liste taxonomique appropriée
      if (taxon != null) {
        final effectiveListId = _getEffectiveListId();
        if (effectiveListId != null) {
          // Vérification légère via requête SQL ciblée (pas de chargement complet)
          final isInList =
              await taxonService.isTaxonInList(taxon.cdNom, effectiveListId);

          if (!isInList) {
            if (mounted) {
              setState(() {
                _selectedTaxon = null;
                _searchController.clear();
              });
              widget.onChanged(null);
            }
            return;
          }
        }
      }

      if (mounted && taxon != null) {
        setState(() {
          _selectedTaxon = taxon;
          _searchController.text = _formatDisplayName(taxon);
        });

        // Si la valeur provenait de la configuration et n'était pas déjà définie, notifier le parent
        // Mais seulement si on l'a chargée depuis la config ET que l'utilisateur n'a pas encore interagi
        if (widget.value == null && isLoadingFromConfig && !_userHasInteracted) {
          widget.onChanged(taxon.cdNom);
        }
      }

      // Marquer la fin de l'initialisation après le premier chargement
      if (_isInitializing) {
        _isInitializing = false;
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
    // Si l'utilisateur a explicitement supprimé la valeur, ne pas la restaurer
    if (widget.userCleared) {
      if (mounted) {
        setState(() {
          _selectedTaxon = null;
          _searchController.clear();
        });
        _isInitializing = false;
      }
      return;
    }

    // Déterminer la valeur effective - widget.value en priorité
    int? effectiveValue = widget.value;
    
    // Seulement restaurer les valeurs par défaut pendant l'initialisation,
    // pas quand l'utilisateur efface explicitement le champ
    if (effectiveValue == null && _isInitializing && widget.fieldConfig != null) {
      final defaultValue = widget.fieldConfig!['default'] ?? widget.fieldConfig!['value'];
      if (defaultValue is int) {
        effectiveValue = defaultValue;
      } else if (defaultValue is Map && defaultValue['cd_nom'] != null) {
        effectiveValue = defaultValue['cd_nom'] as int?;
      }
    }
    
    if (effectiveValue == null) {
      if (mounted) {
        setState(() {
          _selectedTaxon = null;
          _searchController.clear();
        });
      }
      
      // Marquer la fin de l'initialisation même si aucune valeur n'est trouvée
      if (_isInitializing) {
        _isInitializing = false;
      }
      return;
    }

    if (_selectedTaxon?.cdNom != effectiveValue) {
      final taxonService = ref.read(taxonServiceProvider.notifier);
      final taxon = await taxonService.getTaxonByCdNom(effectiveValue);

      // Vérifier si le taxon appartient à la liste taxonomique appropriée
      if (taxon != null) {
        final effectiveListId = _getEffectiveListId();
        if (effectiveListId != null) {
          // Vérification légère via requête SQL ciblée (pas de chargement complet)
          final isInList =
              await taxonService.isTaxonInList(taxon.cdNom, effectiveListId);

          if (!isInList) {
            if (mounted) {
              setState(() {
                _selectedTaxon = null;
                _searchController.clear();
              });
              widget.onChanged(null);
            }
            return;
          }
        }
      }

      if (mounted && taxon != null) {
        setState(() {
          _selectedTaxon = taxon;
          _searchController.text = _formatDisplayName(taxon);
        });
      }

      // Marquer la fin de l'initialisation après la mise à jour
      if (_isInitializing) {
        _isInitializing = false;
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

      // Utiliser la liste effective (champ > module) pour filtrer la recherche
      final listId = _getEffectiveListId();

      // Effectuer la recherche avec l'id_list si disponible
      final results = await taxonService.searchTaxons(query, idListe: listId);

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
    // Utiliser la liste taxonomique appropriée
    final effectiveListId = _getEffectiveListId();

    // Récupérer uniquement les suggestions (nombre limité) au lieu de la liste complète
    final suggestionsAsync = effectiveListId != null
        ? ref.watch(suggestionTaxonsProvider(effectiveListId))
        : null;

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
                        // Marquer explicitement que ce n'est plus l'initialisation
                        _isInitializing = false;
                        // Marquer que l'utilisateur a interagi (suppression)
                        _userHasInteracted = true;
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
              ? (value) {
                  if (_selectedTaxon == null) {
                    return 'Ce champ est obligatoire';
                  }

                  // Vérifier si un id_list est spécifié
                  if (widget.fieldConfig != null) {
                    final listId =
                        FormConfigParser.getTaxonListId(widget.fieldConfig!);
                    if (listId != null) {
                      // La validation de l'appartenance à la liste est déjà faite lors de la sélection
                      // Si nous avons un _selectedTaxon, c'est qu'il est valide
                      return null;
                    }
                  }

                  return null;
                }
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
                      _userHasInteracted = true;
                    });
                    widget.onChanged(taxon.cdNom);
                  },
                );
              },
            ),
          ),

        // Liste de suggestions basée sur la liste taxonomique (nombre limité)
        if (_searchController.text.isEmpty &&
            _selectedTaxon == null &&
            suggestionsAsync != null)
          suggestionsAsync.when(
            data: (taxons) {
              if (taxons.isEmpty) {
                return const SizedBox.shrink();
              }

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
                      children: taxons.map((taxon) {
                        final displayName = _formatDisplayName(taxon);
                        return ChoiceChip(
                          label: Text(displayName,
                              style: const TextStyle(fontSize: 12)),
                          selected: false,
                          onSelected: (_) {
                            setState(() {
                              _selectedTaxon = taxon;
                              _searchController.text = displayName;
                              _userHasInteracted = true;
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
