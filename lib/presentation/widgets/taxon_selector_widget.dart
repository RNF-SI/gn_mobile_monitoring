import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/taxon.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/taxon_service.dart';

class TaxonSelectorWidget extends ConsumerStatefulWidget {
  final int moduleId;
  final int? initialValue;
  final String displayMode;
  final Function(int?) onTaxonSelected;

  const TaxonSelectorWidget({
    super.key,
    required this.moduleId,
    this.initialValue,
    required this.onTaxonSelected,
    this.displayMode = 'nom_vern,lb_nom',
  });

  @override
  ConsumerState<TaxonSelectorWidget> createState() =>
      _TaxonSelectorWidgetState();
}

class _TaxonSelectorWidgetState extends ConsumerState<TaxonSelectorWidget> {
  List<Taxon> _taxons = [];
  Taxon? _selectedTaxon;
  bool _isLoading = true;
  String _searchQuery = '';
  List<Taxon> _filteredTaxons = [];

  @override
  void initState() {
    super.initState();
    _loadTaxons();
  }

  Future<void> _loadTaxons() async {
    setState(() {
      _isLoading = true;
    });

    final taxonService = ref.read(taxonServiceProvider.notifier);
    final taxons = await taxonService.getModuleTaxons(widget.moduleId);

    setState(() {
      _taxons = taxons;
      _filteredTaxons = taxons;

      if (widget.initialValue != null) {
        _selectedTaxon =
            _taxons.where((t) => t.cdNom == widget.initialValue).firstOrNull;
      }

      _isLoading = false;
    });
  }

  void _filterTaxons(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTaxons = _taxons;
      } else {
        _filteredTaxons = _taxons.where((taxon) {
          final searchLower = query.toLowerCase();
          return (taxon.nomComplet?.toLowerCase().contains(searchLower) ??
                  false) ||
              (taxon.lbNom?.toLowerCase().contains(searchLower) ?? false) ||
              (taxon.nomVern?.toLowerCase().contains(searchLower) ?? false);
        }).toList();
      }
    });
  }

  Future<String> _getTaxonDisplayName(Taxon taxon) async {
    final taxonService = ref.read(taxonServiceProvider.notifier);
    return await taxonService.getTaxonDisplayName(taxon, widget.displayMode) ??
        taxon.cdNom.toString();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_taxons.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Aucun taxon disponible pour ce module',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Les taxons sont automatiquement téléchargés avec le module. Si aucun taxon n\'est disponible, ce module n\'utilise peut-être pas de taxons.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(
            labelText: 'Rechercher un taxon',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
          ),
          onChanged: _filterTaxons,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _filteredTaxons.isEmpty
              ? const Center(child: Text('Aucun taxon trouvé'))
              : ListView.builder(
                  itemCount: _filteredTaxons.length,
                  itemBuilder: (context, index) {
                    final taxon = _filteredTaxons[index];
                    return FutureBuilder<String>(
                      future: _getTaxonDisplayName(taxon),
                      builder: (context, snapshot) {
                        final displayName = snapshot.data ?? '...';
                        return RadioListTile<Taxon>(
                          title: Text(displayName),
                          subtitle: Text('Code: ${taxon.cdNom}'),
                          value: taxon,
                          groupValue: _selectedTaxon,
                          onChanged: (Taxon? value) {
                            setState(() {
                              _selectedTaxon = value;
                            });
                            widget.onTaxonSelected(value?.cdNom);
                          },
                        );
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }
}

final taxonRepositoryProvider = Provider((ref) {
  // Ces dépendances devraient être définies ailleurs dans l'application
  // et référencées ici
  throw UnimplementedError(
      'Le provider taxonRepositoryProvider doit être remplacé avec une implémentation réelle');
});
