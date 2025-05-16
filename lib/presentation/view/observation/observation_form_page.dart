import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/base_site.dart';
import 'package:gn_mobile_monitoring/domain/model/base_visit.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/domain/model/observation.dart';
import 'package:gn_mobile_monitoring/presentation/model/module_info.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail/observation_detail_form_page.dart';
import 'package:gn_mobile_monitoring/presentation/view/observation/observation_detail_page.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/observations_viewmodel.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';

// Provider pour le statut du bouton "Enchainer les saisies"
final chainObservationInputProvider = StateProvider<bool>((ref) => false);

class ObservationFormPage extends ConsumerStatefulWidget {
  final int visitId;
  final ObjectConfig observationConfig;
  final CustomConfig? customConfig;
  final Observation? observation; // En mode édition, observation existante
  final int? moduleId; // ID du module pour la visite/observation
  final ObjectConfig?
      observationDetailConfig; // Configuration des observations_detail

  // Informations complémentaires pour le fil d'Ariane et la redirection
  final String? moduleName;
  final String? siteLabel;
  final String? siteName;
  final String? visitLabel;
  final String? visitDate;
  final BaseVisit? visit;
  final BaseSite? site;
  final ModuleInfo? moduleInfo;
  final dynamic fromSiteGroup;

  const ObservationFormPage({
    super.key,
    required this.visitId,
    required this.observationConfig,
    this.customConfig,
    this.observation,
    this.moduleId,
    this.moduleName,
    this.siteLabel,
    this.siteName,
    this.visitLabel,
    this.visitDate,
    this.visit,
    this.site,
    this.moduleInfo,
    this.fromSiteGroup,
    this.observationDetailConfig,
  });

  @override
  ObservationFormPageState createState() => ObservationFormPageState();
}

class ObservationFormPageState extends ConsumerState<ObservationFormPage> {
  late bool _isEditMode;
  bool _isLoading = false;
  bool _chainInput = false; // pour "enchaîner les saisies"
  final _formBuilderKey = GlobalKey<DynamicFormBuilderState>();
  Map<String, dynamic>? _initialValues;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.observation != null;

    // Récupérer l'état du bouton depuis le provider dans le prochain frame
    // (car on ne peut pas accéder à ref dans initState)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Si la config indique que l'enchaînement est possible, on récupère la valeur du provider
        if (widget.observationConfig.chained == true) {
          _chainInput = ref.read(chainObservationInputProvider);
        } else {
          _chainInput = false;
        }
      });
    });

    // En mode édition, préparer les valeurs initiales depuis l'observation existante
    if (_isEditMode && widget.observation != null) {
      _initialValues = _prepareInitialValues(widget.observation!);
    }
  }

  /// Prépare les valeurs initiales pour le formulaire à partir d'une observation existante
  Map<String, dynamic> _prepareInitialValues(Observation observation) {
    // Commencer par les champs de base
    final Map<String, dynamic> values = {
      'id_observation': observation.idObservation,
      'cd_nom': observation.cdNom,
      'comments': observation.comments,
    };

    // Ajouter toutes les données supplémentaires de l'observation
    if (observation.data != null) {
      values.addAll(observation.data!);
    }

    return _normalizeNomenclatureValues(values);
  }

  /// Normalise les valeurs de nomenclature pour l'affichage
  /// Garantit que toutes les valeurs id_nomenclature_* sont converties en entiers
  /// pour éviter les problèmes de type lors de l'édition
  /// Vérifie également si cd_nom existe dans la base de données
  Map<String, dynamic> _normalizeNomenclatureValues(
      Map<String, dynamic> values) {
    final result = Map<String, dynamic>.from(values);

    // Ne pas modifier le cd_nom, même si le taxon n'existe plus
    // Cela permettra de conserver la valeur lors de l'affichage du formulaire
    // dans le cas des conflits et des taxons supprimés
    if (result.containsKey('cd_nom')) {
      final cdNom = result['cd_nom'];
      if (cdNom != null) {
        // On pourrait ajouter un flag spécial pour indiquer que le taxon a été supprimé si nécessaire
        // result['_taxon_deleted'] = true;
      }
    }

    // Parcourir tous les champs de nomenclature
    for (final key in result.keys.toList()) {
      if (key.startsWith('id_nomenclature_')) {
        final value = result[key];
        

        // Cas 1: La valeur est un entier - la convertir en Map pour NomenclatureSelectorWidget
        if (value is int) {
          // Convertir en Map pour compatibilité avec NomenclatureSelectorWidget
          result[key] = {'id': value};
        }
        // Cas 2: La valeur est une Map, la garder telle quelle
        else if (value is Map) {
          // Vérifier que la Map contient soit un 'id', soit un 'cd_nomenclature'
          if (!value.containsKey('id') && !value.containsKey('cd_nomenclature')) {
            debugPrint('WARNING: Nomenclature Map without id or cd_nomenclature: $key: $value');
          }
          // Garder la valeur Map intacte
        }
        // Cas 3: La valeur est une chaîne, essayer de la convertir en entier puis en Map
        else if (value is String) {
          final intValue = int.tryParse(value);
          if (intValue != null) {
            result[key] = {'id': intValue};
          } else {
            print('WARNING: String nomenclature value cannot be parsed to int: $value');
            // Utiliser une valeur par défaut prudente
            result[key] = {'id': 0};
          }
        }
        // Cas 4: Null ou autre type non géré
        else if (value == null) {
          // Laisser la valeur nulle
        } else {
          print('WARNING: Unhandled nomenclature value type for $key: ${value.runtimeType}');
          // Utiliser une valeur par défaut prudente
          result[key] = {'id': 0};
        }
      }
    }

    return result;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditMode ? 'Modifier l\'observation' : 'Nouvelle observation'),
        actions: [
          // Bouton de sauvegarde
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveObservation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fil d'Ariane pour la navigation
                  if (widget.moduleName != null ||
                      widget.siteName != null ||
                      widget.visitDate != null)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: BreadcrumbNavigation(
                          items: [
                            if (widget.moduleName != null)
                              BreadcrumbItem(
                                label: 'Module',
                                value: widget.moduleName!,
                                onTap: () {
                                  // Retour au module (plusieurs niveaux)
                                  Navigator.of(context).popUntil((route) =>
                                      route.isFirst ||
                                      route.settings.name == '/module_detail');
                                },
                              ),
                            if (widget.siteName != null)
                              BreadcrumbItem(
                                label: widget.siteLabel ?? 'Site',
                                value: widget.siteName!,
                                onTap: () {
                                  // Retour au site (2 niveaux)
                                  int count = 0;
                                  Navigator.of(context).popUntil((route) {
                                    return count++ >= 2;
                                  });
                                },
                              ),
                            if (widget.visitDate != null)
                              BreadcrumbItem(
                                label: widget.visitLabel ?? 'Visite',
                                value: widget.visitDate!,
                                onTap: () {
                                  // Retour à la visite (1 niveau)
                                  Navigator.of(context).pop();
                                },
                              ),
                            BreadcrumbItem(
                              label: widget.observationConfig.label ??
                                  'Observation',
                              value: _isEditMode
                                  ? (widget.observation?.cdNom?.toString() ??
                                      'Édition')
                                  : 'Nouvelle',
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  // Formulaire dynamique basé sur la configuration
                  DynamicFormBuilder(
                    key: _formBuilderKey,
                    objectConfig: widget.observationConfig,
                    customConfig: widget.customConfig,
                    initialValues:
                        _initialValues != null ? _normalizeNomenclatureValues(_initialValues!) : {},
                    chainInput: _chainInput,
                    onChainInputChanged: (value) {
                      setState(() {
                        _chainInput = value;
                        // Mettre à jour le provider pour les prochaines saisies
                        ref.read(chainObservationInputProvider.notifier).state =
                            value;
                      });
                    },
                    displayProperties:
                        widget.observationConfig.displayProperties,
                    idListTaxonomy:
                        widget.moduleInfo?.module.complement?.idListTaxonomy,
                  ),

                  const SizedBox(height: 24),

                  // Bouton de sauvegarde
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                      onPressed: _isLoading ? null : _saveObservation,
                      child: Text(_isEditMode ? 'Enregistrer' : 'Ajouter'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  /// Sauvegarde l'observation (création ou mise à jour)
  Future<void> _saveObservation() async {
    if (_formBuilderKey.currentState?.validate() != true) {
      // Formulaire invalide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez corriger les erreurs du formulaire')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les valeurs du formulaire
      final formData = _formBuilderKey.currentState!.getFormValues();

      // Accéder au viewmodel des observations
      final observationsViewModel =
          ref.read(observationsProvider(widget.visitId).notifier);

      if (_isEditMode && widget.observation != null) {
        // Mettre à jour l'observation existante
        final success = await observationsViewModel.updateObservation(
          formData,
          widget.observation!.idObservation,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Observation mise à jour avec succès')),
          );

          // Fermer la page et retourner à la page précédente
          if (!_chainInput) {
            // Récupérer l'observation créée/mise à jour
            final observation = await observationsViewModel
                .getObservationById(widget.observation!.idObservation);

            if (observation != null && mounted) {
              // Rediriger vers la page de détail de l'observation
              if (mounted && widget.visit != null && widget.site != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                      observation: observation,
                      visit: widget.visit!,
                      site: widget.site!,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                      observationConfig: widget.observationConfig,
                      customConfig: widget.customConfig,
                      observationDetailConfig: widget.observationDetailConfig,
                      isNewObservation: false,
                    ),
                  ),
                );
              } else if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              }
            }
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
              _initialValues = {}; // Réinitialiser les valeurs initiales
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Erreur lors de la mise à jour de l\'observation')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // Créer une nouvelle observation
        final newObservationId =
            await observationsViewModel.createObservation(formData);

        if (newObservationId > 0 && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Observation créée avec succès')),
          );

          // Gérer la navigation
          if (!_chainInput) {
            // Récupérer l'observation créée
            final newObservation = await observationsViewModel
                .getObservationById(newObservationId);

            if (newObservation != null && mounted) {
              // Vérifier si le module a une configuration pour les détails d'observation
              if (widget.observationDetailConfig != null && mounted) {
                setState(() {
                  _isLoading = false;
                });
                // Demander à l'utilisateur s'il veut ajouter un détail d'observation
                _promptForObservationDetail(newObservationId, newObservation);
              } 
              // Sinon, rediriger vers la page de détail de l'observation
              else if (mounted && widget.visit != null && widget.site != null) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                      observation: newObservation,
                      visit: widget.visit!,
                      site: widget.site!,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                      observationConfig: widget.observationConfig,
                      customConfig: widget.customConfig,
                      observationDetailConfig: widget.observationDetailConfig,
                      isNewObservation: true,
                    ),
                  ),
                );
              } else if (mounted) {
                setState(() {
                  _isLoading = false;
                });
                Navigator.pop(context);
              }
            }
          } else {
            // En mode enchaînement, réinitialiser le formulaire
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _isLoading = false;
              _initialValues = {}; // Réinitialiser les valeurs initiales
            });
          }
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Erreur lors de la création de l\'observation')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navigue vers le formulaire de détail d'observation
  void _navigateToObservationDetailForm(Observation observation) {
    if (widget.observationDetailConfig != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ObservationDetailFormPage(
            observationDetail: widget.observationDetailConfig!,
            observation: observation,
            customConfig: widget.customConfig,
            visit: widget.visit,
            site: widget.site,
            moduleInfo: widget.moduleInfo,
            fromSiteGroup: widget.fromSiteGroup,
          ),
        ),
      );
    }
  }
  
  /// Affiche une boite de dialogue pour demander à l'utilisateur s'il veut ajouter un détail d'observation
  void _promptForObservationDetail(int observationId, Observation observation) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un détail d\'observation ?'),
        content: const Text('Voulez-vous ajouter un détail d\'observation maintenant ?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boite de dialogue
              
              // Naviguer vers la page détail de l'observation
              if (widget.visit != null && widget.site != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailPage(
                      observation: observation,
                      visit: widget.visit!,
                      site: widget.site!,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                      observationConfig: widget.observationConfig,
                      customConfig: widget.customConfig,
                      observationDetailConfig: widget.observationDetailConfig,
                      isNewObservation: true,
                    ),
                  ),
                );
              } else {
                Navigator.pop(context); // Retour à la page précédente
              }
            },
            child: const Text('Non'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermer la boite de dialogue
              
              // Naviguer vers le formulaire de détail d'observation
              if (widget.observationDetailConfig != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ObservationDetailFormPage(
                      observationDetail: widget.observationDetailConfig!,
                      observation: observation,
                      customConfig: widget.customConfig,
                      visit: widget.visit,
                      site: widget.site,
                      moduleInfo: widget.moduleInfo,
                      fromSiteGroup: widget.fromSiteGroup,
                    ),
                  ),
                );
              }
            },
            child: const Text('Oui'),
          ),
        ],
      ),
    );
  }
}
