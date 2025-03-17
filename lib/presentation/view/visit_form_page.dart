import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/domain_module.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

class VisitFormPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final CustomConfig? customConfig;
  final BaseVisit? visit; // En mode édition, visite existante
  final int? moduleId; // ID du module pour la visite

  const VisitFormPage({
    super.key,
    required this.site,
    required this.visitConfig,
    this.customConfig,
    this.visit,
    this.moduleId,
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
    } else {
      // En mode création, initialiser avec l'utilisateur connecté comme observateur
      _initialValues = {};
      _loadConnectedUser();
    }
  }

  /// Charge l'utilisateur connecté et l'ajoute comme observateur initial
  Future<void> _loadConnectedUser() async {
    final userId =
        await ref.read(getUserIdFromLocalStorageUseCaseProvider).execute();

    if (userId != null && userId > 0) {
      setState(() {
        _initialValues = {
          'observers': [userId]
        };
      });
    }
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

  // Suppression d'une visite avec confirmation
  Future<void> _deleteVisit() async {
    if (widget.visit == null) return;

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

      try {
        final viewModel = ref
            .read(siteVisitsViewModelProvider(widget.site.idBaseSite).notifier);
        final success = await viewModel.deleteVisit(widget.visit!.idBaseVisit);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          if (success) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Visite supprimée avec succès'),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erreur lors de la suppression de la visite'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  // Sauvegarde (création ou mise à jour)
  Future<void> _saveForm() async {
    if (_formBuilderKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Récupérer l'ID de l'utilisateur connecté
        final userId =
            await ref.read(getUserIdFromLocalStorageUseCaseProvider).execute();

        // Récupérer le nom de l'utilisateur connecté
        final userName = await ref
            .read(getUserNameFromLocalStorageUseCaseProvider)
            .execute();

        // Récupérer les valeurs du formulaire
        final formValues = _formBuilderKey.currentState?.getFormValues() ?? {};

        // Extraire les données principales
        final Map<String, dynamic> mainData = {
          'id_base_site': widget.site.idBaseSite,
          'id_module': widget.moduleId ??
              -1, // -1 indique un problème avec l'ID du module
          'id_dataset': 1, // TODO: Récupérer le dataset depuis la configuration
        };

        // Extraire les données génériques
        if (formValues.containsKey('visit_date_min')) {
          mainData['visit_date_min'] = formValues.remove('visit_date_min');
        }
        if (formValues.containsKey('visit_date_max')) {
          mainData['visit_date_max'] = formValues.remove('visit_date_max');
        }
        if (formValues.containsKey('comments')) {
          mainData['comments'] = formValues.remove('comments');
        }

        // Gérer les observateurs
        List<int> observers = [];

        // Si des observateurs sont déjà sélectionnés dans le formulaire, les utiliser
        if (formValues.containsKey('observers')) {
          observers = List<int>.from(formValues.remove('observers'));
        }

        // Si l'utilisateur connecté n'est pas déjà dans la liste des observateurs, l'ajouter
        if (userId != null && userId > 0 && !observers.contains(userId)) {
          observers.add(userId);
        }

        // Si la liste des observateurs n'est pas vide, l'ajouter aux données principales
        if (observers.isNotEmpty) {
          mainData['observers'] = observers;
        }

        // Toutes les autres données vont dans le champ "data"
        mainData['data'] = formValues;

        // En mode édition, conserver l'ID de la visite
        if (_isEditMode && widget.visit != null) {
          mainData['id_base_visit'] = widget.visit!.idBaseVisit;
        } else {
          // En mode création, utiliser un ID temporaire qui sera remplacé par la BDD
          mainData['id_base_visit'] = 0;
        }

        // Créer l'objet BaseVisit
        final visit = BaseVisit.fromJson(mainData);

        // Récupérer le ViewModel
        final viewModel = ref
            .read(siteVisitsViewModelProvider(widget.site.idBaseSite).notifier);

        // Sauvegarder ou mettre à jour
        if (_isEditMode && widget.visit != null) {
          final success = await viewModel.updateVisit(visit);

          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            if (success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Visite mise à jour avec succès${userName != null ? " avec $userName comme observateur" : ""}'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la mise à jour de la visite'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        } else {
          final visitId = await viewModel.saveVisit(visit);

          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            if (visitId > 0) {
              // Si enchaînement et création, réinitialiser le formulaire
              if (_chainInput) {
                _formBuilderKey.currentState?.resetForm();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Visite enregistrée${userName != null ? " avec $userName comme observateur" : ""}. Vous pouvez saisir la suivante.'),
                  ),
                );
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Visite créée avec succès${userName != null ? " avec $userName comme observateur" : ""}'),
                  ),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Erreur lors de la création de la visite'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur: ${e.toString()}'),
              backgroundColor: Colors.red,
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
                  const SizedBox(height: 16),

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
