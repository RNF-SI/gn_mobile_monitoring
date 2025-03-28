import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/core/helpers/format_datetime.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/visit_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/site_visits_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

class VisitFormPage extends ConsumerStatefulWidget {
  final BaseSite site;
  final ObjectConfig visitConfig;
  final CustomConfig? customConfig;
  final BaseVisit? visit; // En mode édition, visite existante
  final int? moduleId; // ID du module pour la visite
  final ModuleInfo?
      moduleInfo; // Information sur le module parent (pour le fil d'Ariane)
  final dynamic
      siteGroup; // Groupe de sites parent éventuel (pour le fil d'Ariane)

  const VisitFormPage({
    super.key,
    required this.site,
    required this.visitConfig,
    this.customConfig,
    this.visit,
    this.moduleId,
    this.moduleInfo,
    this.siteGroup,
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

    // En mode édition, préparer les valeurs initiales depuis la visite existante
    if (_isEditMode && widget.visit != null) {
      // Initialiser avec les valeurs basiques de la visite
      _initialValues = _prepareInitialValues(widget.visit!);

      // Charger les données complètes de la visite (avec les données JSON)
      _loadVisitWithFullDetails(widget.visit!.idBaseVisit).then((fullVisit) {
        if (mounted) {
          setState(() {
            _initialValues = _prepareInitialValues(fullVisit);
          });
        }
      }).catchError((e) {
        // Erreur silencieuse
      });
    } else {
      // En mode création, initialiser vide et charger l'utilisateur connecté comme observateur
      _initialValues = {};
      _loadConnectedUser();
    }
  }

  /// Charge l'utilisateur connecté et l'ajoute comme observateur initial
  Future<void> _loadConnectedUser() async {
    try {
      // Récupérer le ViewModel
      final viewModel = ref.read(siteVisitsViewModelProvider(
          (widget.site.idBaseSite, widget.moduleId!)).notifier);

      // Récupérer l'ID de l'utilisateur via le ViewModel
      final userId = await viewModel.getCurrentUserId();

      if (userId != null && userId > 0 && mounted) {
        setState(() {
          _initialValues = {
            'observers': [userId]
          };
        });
      }
    } catch (e) {
      // En cas d'erreur, on laisse les valeurs initiales vides
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
        // Retirer les guillemets des clés si nécessaire
        String key = entry.key.replaceAll('"', '');

        // Traiter la valeur en fonction de son type
        dynamic value = entry.value;

        // Convertir la valeur en chaîne pour traitement uniforme
        String valueStr = value.toString();

        // Supprimer les guillemets au début et à la fin si présents
        if (valueStr.startsWith('"') && valueStr.endsWith('"')) {
          valueStr = valueStr.substring(1, valueStr.length - 1);
        }

        // Pour les champs d'heure, s'assurer qu'ils sont au bon format
        if (key.toLowerCase().contains('time') &&
            !key.toLowerCase().contains('date')) {
          // Nettoyer les valeurs d'heure (retirer les guillemets, etc.)
          valueStr = valueStr.replaceAll('"', '').trim();

          // Vérifier le format et corriger si nécessaire
          if (valueStr.contains(':')) {
            final parts = valueStr.split(':');
            if (parts.length == 2) {
              final hour = int.tryParse(parts[0].trim());
              final minute = int.tryParse(parts[1].trim());
              if (hour != null && minute != null) {
                valueStr =
                    '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
              }
            }
          }
          value = valueStr;
        }
        // Pour les valeurs numériques
        else if (num.tryParse(valueStr) != null) {
          // Garder le type numérique
          value = num.tryParse(valueStr);
        }
        // Pour les autres chaînes
        else {
          value = valueStr;
        }

        // Ajouter la paire clé-valeur au résultat
        values[key] = value;
      }
    }

    return values;
  }

  /// Charge une visite avec tous ses détails depuis le repository
  Future<BaseVisit> _loadVisitWithFullDetails(int visitId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final viewModel = ref.read(siteVisitsViewModelProvider(
          (widget.site.idBaseSite, widget.moduleId ?? 1)).notifier);
      final visit = await viewModel.getVisitWithFullDetails(visitId);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      return visit;
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de chargement des données: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      rethrow;
    }
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
        // Récupérer le ViewModel
        final viewModel = ref.read(siteVisitsViewModelProvider(
            (widget.site.idBaseSite, widget.moduleId ?? 1)).notifier);

        // Supprimer la visite via le ViewModel
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
        // Récupérer le ViewModel
        final viewModel = ref.read(siteVisitsViewModelProvider(
            (widget.site.idBaseSite, widget.moduleId ?? 1)).notifier);

        // Récupérer le nom d'utilisateur pour l'affichage
        final userName = await viewModel.getCurrentUserName();

        // Récupérer les valeurs brutes du formulaire
        final formValues = _formBuilderKey.currentState?.getFormValues() ?? {};

        // Sauvegarder ou mettre à jour selon le mode
        if (_isEditMode && widget.visit != null) {
          // Mettre à jour la visite existante
          final success = await viewModel.updateVisitFromFormData(
            formValues,
            widget.site,
            widget.visit!.idBaseVisit,
            moduleId: widget.moduleId ?? 1,
          );

          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            if (success) {
              // Vérifier si la configuration des observations existe
              final hasObservationConfig = widget.moduleInfo?.module.complement
                      ?.configuration?.observation !=
                  null;

              // Demander à l'utilisateur s'il souhaite saisir des observations seulement si la config existe
              if (!_chainInput && hasObservationConfig) {
                final bool? createObservations = await _askForObservations();

                if (createObservations == true && mounted) {
                  // Naviguer vers le formulaire d'observation
                  _navigateToObservationForm(widget.visit!.idBaseVisit);
                  return;
                }
              }

              // Rediriger vers la page de détail de la visite
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VisitDetailPage(
                      visit: widget.visit!,
                      site: widget.site,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.siteGroup,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Visite mise à jour avec succès${userName != null ? " avec $userName comme observateur" : ""}'),
                  ),
                );
              }
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
          // Créer une nouvelle visite
          final visitId = await viewModel.createVisitFromFormData(
            formValues,
            widget.site,
            moduleId: widget.moduleId ?? 1,
          );

          if (mounted) {
            setState(() {
              _isLoading = false;
            });

            if (visitId > 0) {
              // Si enchaînement et création, réinitialiser le formulaire
              if (_chainInput) {
                _formBuilderKey.currentState?.resetForm();

                // Réinitialiser avec l'utilisateur connecté comme observateur
                final userId = await viewModel.getCurrentUserId();
                setState(() {
                  _initialValues = {
                    'observers': userId != null ? [userId] : []
                  };
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Visite enregistrée${userName != null ? " avec $userName comme observateur" : ""}. Vous pouvez saisir la suivante.'),
                  ),
                );
              } else {
                // Récupérer la visite créée pour la redirection
                final newVisit =
                    await viewModel.getVisitWithFullDetails(visitId);

                // Rediriger vers la page de détail de la visite
                if (mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitDetailPage(
                        visit: newVisit,
                        site: widget.site,
                        moduleInfo: widget.moduleInfo,
                        fromSiteGroup: widget.siteGroup,
                      ),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Visite créée avec succès${userName != null ? " avec $userName comme observateur" : ""}'),
                    ),
                  );
                }
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

  /// Demande à l'utilisateur s'il souhaite saisir des observations pour cette visite
  Future<bool?> _askForObservations() async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saisir des observations'),
        content: const Text(
            "Souhaitez-vous saisir des observations pour cette visite ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }

  /// Navigue vers le formulaire d'observation pour la visite spécifiée
  void _navigateToObservationForm(int visitId) async {
    // Récupérer la visite créée pour la redirection
    final viewModel = ref.read(siteVisitsViewModelProvider(
        (widget.site.idBaseSite, widget.moduleId ?? 1)).notifier);
    final newVisit = await viewModel.getVisitWithFullDetails(visitId);

    // Récupérer la config pour les observations depuis le module
    if (widget.moduleInfo?.module.complement?.configuration?.observation !=
        null) {
      final observationConfig =
          widget.moduleInfo!.module.complement!.configuration!.observation!;
      final customConfig = widget.customConfig;

      // Naviguer vers le formulaire d'observation avec les informations nécessaires
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ObservationFormPage(
              visitId: visitId,
              observationConfig: observationConfig,
              customConfig: customConfig,
              moduleId: widget.moduleId,
              moduleName: widget.moduleInfo?.module.moduleLabel,
              siteLabel: widget
                  .moduleInfo?.module.complement?.configuration?.site?.label,
              siteName: widget.site.baseSiteName ?? widget.site.baseSiteCode,
              visitLabel: widget.visitConfig.label,
              visitDate: formatDateString(newVisit.visitDateMin),
              observationDetailConfig: widget.moduleInfo?.module.complement
                  ?.configuration?.observationDetail,
            ),
          ),
        );
      }
    } else {
      // Pas de config d'observation disponible
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuration des observations non disponible'),
            backgroundColor: Colors.orange,
          ),
        );
        Navigator.pop(context);
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
                  // Fil d'Ariane pour la navigation
                  if (widget.moduleInfo != null)
                    Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: BreadcrumbNavigation(
                          items: [
                            // Module
                            BreadcrumbItem(
                              label: 'Module',
                              value: widget.moduleInfo!.module.moduleLabel ??
                                  'Module',
                              onTap: () {
                                // Naviguer vers le module (plusieurs niveaux de retour)
                                Navigator.of(context).popUntil((route) =>
                                    route.isFirst ||
                                    route.settings.name == '/module_detail');
                              },
                            ),

                            // Groupe de site (si disponible)
                            if (widget.siteGroup != null)
                              BreadcrumbItem(
                                label: widget.moduleInfo!.module.complement
                                        ?.configuration?.sitesGroup?.label ??
                                    'Groupe',
                                value: widget.siteGroup.sitesGroupName ??
                                    widget.siteGroup.sitesGroupCode ??
                                    'Groupe',
                                onTap: () {
                                  // Retourner 2 niveaux en arrière pour revenir au groupe
                                  int count = 0;
                                  Navigator.of(context).popUntil((route) {
                                    return count++ >= 2;
                                  });
                                },
                              ),

                            // Site
                            BreadcrumbItem(
                              label: widget.moduleInfo!.module.complement
                                      ?.configuration?.site?.label ??
                                  'Site',
                              value: widget.site.baseSiteName ??
                                  widget.site.baseSiteCode ??
                                  'Site',
                              onTap: () {
                                // Revenir au site
                                Navigator.of(context).pop();
                              },
                            ),

                            // Visite (formulaire actuel)
                            BreadcrumbItem(
                              label: widget.visitConfig.label ?? 'Visite',
                              value: widget.visit != null
                                  ? formatDateString(widget.visit!.visitDateMin)
                                  : 'Nouvelle',
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Si pas de moduleInfo, afficher juste le bandeau classique
                  if (widget.moduleInfo == null)
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
