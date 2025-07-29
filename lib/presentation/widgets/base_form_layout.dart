import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/presentation/widgets/breadcrumb_navigation.dart';

/// Widget de base pour les formulaires avec une structure cohérente
/// Structure : AppBar + Fil d'Ariane (optionnel) + Contenu scrollable + Boutons d'action fixes
class BaseFormLayout extends StatelessWidget {
  /// Titre de la page
  final String title;
  
  /// Actions personnalisées pour l'AppBar (ex: bouton supprimer)
  final List<Widget>? appBarActions;
  
  /// Éléments du fil d'Ariane (optionnel)
  final List<BreadcrumbItem>? breadcrumbItems;
  
  /// Contenu principal du formulaire (scrollable)
  final Widget formContent;
  
  /// Indicateur de chargement
  final bool isLoading;
  
  /// Fonction appelée lors de l'annulation
  final VoidCallback onCancel;
  
  /// Fonction appelée lors de la sauvegarde
  final VoidCallback? onSave;
  
  /// Texte du bouton de sauvegarde
  final String saveButtonText;
  
  /// Indicateur si la sauvegarde est en cours
  final bool isSaving;
  
  const BaseFormLayout({
    super.key,
    required this.title,
    this.appBarActions,
    this.breadcrumbItems,
    required this.formContent,
    this.isLoading = false,
    required this.onCancel,
    this.onSave,
    this.saveButtonText = 'Enregistrer',
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Fil d'Ariane (optionnel)
                  if (breadcrumbItems != null && breadcrumbItems!.isNotEmpty)
                    Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        child: BreadcrumbNavigation(
                          items: breadcrumbItems!,
                        ),
                      ),
                    ),

                  // Contenu du formulaire (scrollable)
                  Expanded(
                    child: SingleChildScrollView(
                      child: formContent,
                    ),
                  ),

                  // Boutons d'action fixes en bas
                  _buildActionButtons(context),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12.0, 0, 16.0),
      margin: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: isSaving ? null : onCancel,
            child: const Text('Annuler'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: (isSaving || onSave == null) ? null : onSave,
            child: isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(saveButtonText),
          ),
        ],
      ),
    );
  }
}