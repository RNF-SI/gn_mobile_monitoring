import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

class VisitFormPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final CustomConfig? customConfig;
  final BaseVisit? visit; // En mode édition, visite existante

  const VisitFormPage({
    super.key,
    required this.site,
    required this.visitConfig,
    this.customConfig,
    this.visit,
  });

  @override
  VisitFormPageState createState() => VisitFormPageState();
}

class VisitFormPageState extends ConsumerState<VisitFormPage> {
  late bool _isEditMode;
  bool _isLoading = false;
  bool _chainInput = false; // pour "enchaîner les saisies"
  final _formBuilderKey = GlobalKey<DynamicFormBuilderState>();
  Map<String, dynamic>? _initialValues;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.visit != null;
    // Si la config indique que l'enchaînement est possible, on initialise la bascule
    _chainInput = widget.visitConfig.chained ?? false;

    // En mode édition, préparer les valeurs initiales
    if (_isEditMode && widget.visit != null) {
      _initialValues = _prepareInitialValues(widget.visit!);
    }

    // Log pour vérifier si displayProperties est correctement rempli
    print("Display properties: ${widget.visitConfig.displayProperties}");
  }

  /// Prépare les valeurs initiales pour le formulaire à partir d'une visite existante
  Map<String, dynamic> _prepareInitialValues(BaseVisit visit) {
    final values = <String, dynamic>{};

    // Champs génériques
    if (visit.visitDateMin != null) {
      values['visit_date_min'] = visit.visitDateMin;
    }
    if (visit.visitDateMax != null) {
      values['visit_date_max'] = visit.visitDateMax;
    }
    if (visit.comments != null) {
      values['comments'] = visit.comments;
    }
    if (visit.observers != null && visit.observers!.isNotEmpty) {
      values['observers'] = visit.observers;
    }

    // Champs spécifiques (on suppose qu'ils sont dans visit.data)
    if (visit.data != null) {
      for (final entry in visit.data!.entries) {
        values[entry.key] = entry.value;
      }
    }

    return values;
  }

  // Simulation d'une suppression avec confirmation
  Future<void> _deleteVisit() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content:
            const Text("Êtes-vous sûr de vouloir supprimer cette visite ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Annuler')),
          ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Supprimer')),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });
      // Simuler la suppression (remplacer par votre appel API)
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Visite supprimée avec succès (Simulation)'),
          ),
        );
      }
    }
  }

  // Sauvegarde (création ou mise à jour)
  Future<void> _saveForm() async {
    if (_formBuilderKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Récupérer les valeurs du formulaire
      final formValues = _formBuilderKey.currentState?.getFormValues() ?? {};

      // Ajouter l'ID du site (obligatoire pour les visites)
      formValues['id_base_site'] = widget.site.idBaseSite;

      // Log pour débogage
      debugPrint('Formulaire soumis: $formValues');

      // Préparer les données pour l'API (dans une implémentation réelle)
      // final dataToSend = BaseVisit.fromJson(formValues);

      // Simulation d'un appel API asynchrone
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Si enchaînement et création, réinitialiser le formulaire
        if (_chainInput && !_isEditMode) {
          _formBuilderKey.currentState?.resetForm();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Visite enregistrée. Vous pouvez saisir la suivante.'),
            ),
          );
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isEditMode
                  ? 'Visite mise à jour avec succès (Simulation)'
                  : 'Visite créée avec succès (Simulation)'),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? 'Modifier la visite'
            : widget.visitConfig.label ?? 'Nouvelle visite'),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Supprimer la visite',
              onPressed: _deleteVisit,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Bandeau d'information du site (compact)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Site: ${widget.site.baseSiteName}${widget.site.baseSiteCode != null ? ' (${widget.site.baseSiteCode})' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Formulaire dynamique
                  Expanded(
                    child: SingleChildScrollView(
                      child: DynamicFormBuilder(
                        key: _formBuilderKey,
                        objectConfig: widget.visitConfig,
                        customConfig: widget.customConfig,
                        initialValues: _initialValues,
                        chainInput: _chainInput,
                        onChainInputChanged: (value) {
                          setState(() {
                            _chainInput = value;
                          });
                        },
                        // Utiliser les propriétés d'affichage de la configuration
                        displayProperties: widget.visitConfig.displayProperties,
                      ),
                    ),
                  ),

                  // Boutons d'action
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Annuler'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _saveForm,
                          child: Text(
                              _isEditMode ? 'Mettre à jour' : 'Enregistrer'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
