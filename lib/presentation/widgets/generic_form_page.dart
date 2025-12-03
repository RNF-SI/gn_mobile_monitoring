import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/domain/model/module_configuration.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/base_form_layout.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/conflict_info_banner.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/dynamic_form_builder.dart';
import 'package:gn_mobile_monitoring/domain/model/sync_conflict.dart';

/// Widget générique pour tous les types de formulaires (observation, visite, détail d'observation)
/// Factorisation complète de la logique commune des formulaires
class GenericFormPage extends ConsumerStatefulWidget {
  /// Configuration du formulaire (observation, visite, etc.)
  final ObjectConfig objectConfig;
  
  /// Configuration personnalisée
  final CustomConfig? customConfig;
  
  /// Titre de la page
  final String title;
  
  /// Actions de l'AppBar (ex: bouton supprimer)
  final List<Widget>? appBarActions;
  
  /// Éléments du fil d'Ariane
  final List<BreadcrumbItem>? breadcrumbItems;
  
  /// Valeurs initiales du formulaire
  final Map<String, dynamic>? initialValues;
  
  /// Widget supplémentaire à afficher avant le formulaire (ex: bandeau de conflit)
  final Widget? headerWidget;
  
  /// Fonction appelée lors de la validation du formulaire
  final Future<bool> Function(Map<String, dynamic> formData) onSave;
  
  /// Fonction appelée lors de l'annulation
  final VoidCallback? onCancel;
  
  /// Texte du bouton de sauvegarde
  final String saveButtonText;
  
  /// Provider pour l'état "enchaîner les saisies"
  final StateProvider<bool>? chainInputProvider;
  
  /// Liste de propriétés à afficher
  final List<String>? displayProperties;
  
  /// ID de la liste taxonomique (pour les observations)
  final int? idListTaxonomy;
  
  /// Conflit en cours (optionnel)
  final SyncConflict? currentConflict;
  
  /// Type d'objet pour appliquer des exclusions spécifiques (ex: 'site', 'sites_group', 'visit', 'observation')
  final String? objectType;
  
  /// Fonction personnalisée de normalisation des valeurs initiales
  final Map<String, dynamic> Function(Map<String, dynamic>)? normalizeInitialValues;

  const GenericFormPage({
    super.key,
    required this.objectConfig,
    this.customConfig,
    required this.title,
    this.appBarActions,
    this.breadcrumbItems,
    this.initialValues,
    this.headerWidget,
    required this.onSave,
    this.onCancel,
    this.saveButtonText = 'Enregistrer',
    this.chainInputProvider,
    this.displayProperties,
    this.idListTaxonomy,
    this.currentConflict,
    this.objectType,
    this.normalizeInitialValues,
  });

  @override
  GenericFormPageState createState() => GenericFormPageState();
}

class GenericFormPageState extends ConsumerState<GenericFormPage> {
  bool _isLoading = false;
  bool? _chainInput; // Null si pas de provider, pour ne pas afficher le bouton
  final _formBuilderKey = GlobalKey<DynamicFormBuilderState>();
  Map<String, dynamic>? _processedInitialValues;

  @override
  void initState() {
    super.initState();
    
    // Initialiser l'état de chaînage seulement si le provider existe
    if (widget.chainInputProvider != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _chainInput = ref.read(widget.chainInputProvider!);
        });
      });
    } else {
      // Pas de provider = pas de bouton "enchaîner les saisies"
      _chainInput = null;
    }

    // Traiter les valeurs initiales
    _processedInitialValues = _processInitialValues();
  }

  /// Traite les valeurs initiales en appliquant la fonction de normalisation si fournie
  Map<String, dynamic> _processInitialValues() {
    if (widget.initialValues == null) return {};
    
    if (widget.normalizeInitialValues != null) {
      return widget.normalizeInitialValues!(widget.initialValues!);
    }
    
    return widget.initialValues!;
  }

  @override
  Widget build(BuildContext context) {
    return BaseFormLayout(
      title: widget.title,
      appBarActions: widget.appBarActions,
      breadcrumbItems: widget.breadcrumbItems,
      formContent: _buildFormContent(),
      isLoading: _isLoading,
      onCancel: widget.onCancel ?? () => Navigator.of(context).pop(),
      onSave: _handleSave,
      saveButtonText: widget.saveButtonText,
      isSaving: _isLoading,
    );
  }

  /// Construit le contenu du formulaire
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Widget d'en-tête personnalisé (ex: bandeau de conflit)
        if (widget.headerWidget != null) ...[
          widget.headerWidget!,
          const SizedBox(height: 16),
        ],
        
        // Bandeau de conflit standard
        if (widget.currentConflict != null) ...[
          ConflictInfoBanner(conflict: widget.currentConflict!),
          const SizedBox(height: 16),
        ],
        
        // Formulaire dynamique
        DynamicFormBuilder(
          key: _formBuilderKey,
          objectConfig: widget.objectConfig,
          customConfig: widget.customConfig,
          initialValues: _processedInitialValues ?? {},
          chainInput: _chainInput, // Null si pas de provider = pas de bouton
          onChainInputChanged: widget.chainInputProvider != null 
              ? _handleChainInputChanged 
              : null,
          displayProperties: widget.displayProperties,
          idListTaxonomy: widget.idListTaxonomy,
          objectType: widget.objectType,
        ),
      ],
    );
  }

  /// Gère le changement de l'état "enchaîner les saisies"
  void _handleChainInputChanged(bool value) {
    if (widget.chainInputProvider == null) return;
    
    setState(() {
      _chainInput = value;
      ref.read(widget.chainInputProvider!.notifier).state = value;
    });
  }

  /// Gère la sauvegarde du formulaire
  Future<void> _handleSave() async {
    // Validation du formulaire
    if (_formBuilderKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez corriger les erreurs du formulaire'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Récupérer les données du formulaire
      final formData = _formBuilderKey.currentState!.getFormValues();
      
      // Appeler la fonction de sauvegarde
      final success = await widget.onSave(formData);
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // En mode enchaînement, réinitialiser le formulaire
          if (_chainInput == true) {
            _formBuilderKey.currentState?.resetForm();
            setState(() {
              _processedInitialValues = {};
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${widget.objectConfig.label ?? 'Élément'} enregistré avec succès'),
              ),
            );
          } else {
            // Sinon, fermer le formulaire
            Navigator.of(context).pop(true);
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

  /// Méthode publique pour accéder au state du formulaire (si nécessaire)
  DynamicFormBuilderState? get formBuilderState => _formBuilderKey.currentState;
  
  /// Méthode publique pour réinitialiser le formulaire
  void resetForm() {
    _formBuilderKey.currentState?.resetForm();
    setState(() {
      _processedInitialValues = {};
    });
  }
  
  /// Méthode publique pour mettre à jour les valeurs initiales
  void updateInitialValues(Map<String, dynamic> newValues) {
    setState(() {
      _processedInitialValues = widget.normalizeInitialValues != null
          ? widget.normalizeInitialValues!(newValues)
          : newValues;
    });
  }
}

/// Classe helper pour construire facilement les éléments de fil d'Ariane
class BreadcrumbBuilder {
  /// Construit un fil d'Ariane standard pour les formulaires d'observation
  static List<BreadcrumbItem> buildObservationBreadcrumb({
    String? moduleName,
    String? siteLabel,
    String? siteName,
    String? visitLabel,
    String? visitDate,
    required String observationLabel,
    required String observationValue,
    VoidCallback? onModuleTap,
    VoidCallback? onSiteTap,
    VoidCallback? onVisitTap,
  }) {
    final items = <BreadcrumbItem>[];
    
    if (moduleName != null && onModuleTap != null) {
      items.add(BreadcrumbItem(
        label: 'Module',
        value: moduleName,
        onTap: onModuleTap,
      ));
    }
    
    if (siteName != null && onSiteTap != null) {
      items.add(BreadcrumbItem(
        label: siteLabel ?? 'Site',
        value: siteName,
        onTap: onSiteTap,
      ));
    }
    
    if (visitDate != null && onVisitTap != null) {
      items.add(BreadcrumbItem(
        label: visitLabel ?? 'Visite',
        value: visitDate,
        onTap: onVisitTap,
      ));
    }
    
    items.add(BreadcrumbItem(
      label: observationLabel,
      value: observationValue,
    ));
    
    return items;
  }

  /// Construit un fil d'Ariane standard pour les formulaires de visite
  static List<BreadcrumbItem> buildVisitBreadcrumb({
    String? moduleName,
    String? siteGroupLabel,
    String? siteGroupName,
    String? siteLabel,
    required String siteName,
    required String visitLabel,
    required String visitValue,
    VoidCallback? onModuleTap,
    VoidCallback? onSiteGroupTap,
    VoidCallback? onSiteTap,
  }) {
    final items = <BreadcrumbItem>[];
    
    if (moduleName != null && onModuleTap != null) {
      items.add(BreadcrumbItem(
        label: 'Module',
        value: moduleName,
        onTap: onModuleTap,
      ));
    }
    
    if (siteGroupName != null && onSiteGroupTap != null) {
      items.add(BreadcrumbItem(
        label: siteGroupLabel ?? 'Groupe',
        value: siteGroupName,
        onTap: onSiteGroupTap,
      ));
    }
    
    if (onSiteTap != null) {
      items.add(BreadcrumbItem(
        label: siteLabel ?? 'Site',
        value: siteName,
        onTap: onSiteTap,
      ));
    }
    
    items.add(BreadcrumbItem(
      label: visitLabel,
      value: visitValue,
    ));
    
    return items;
  }

  /// Construit un fil d'Ariane standard pour les formulaires de site
  static List<BreadcrumbItem> buildSiteBreadcrumb({
    String? moduleName,
    String? siteGroupLabel,
    String? siteGroupName,
    required String siteLabel,
    required String siteName,
    VoidCallback? onModuleTap,
    VoidCallback? onSiteGroupTap,
  }) {
    final items = <BreadcrumbItem>[];
    
    if (moduleName != null && onModuleTap != null) {
      items.add(BreadcrumbItem(
        label: 'Module',
        value: moduleName,
        onTap: onModuleTap,
      ));
    }
    
    if (siteGroupName != null && onSiteGroupTap != null) {
      items.add(BreadcrumbItem(
        label: siteGroupLabel ?? 'Groupe',
        value: siteGroupName,
        onTap: onSiteGroupTap,
      ));
    }
    
    items.add(BreadcrumbItem(
      label: siteLabel,
      value: siteName,
    ));
    
    return items;
  }
}