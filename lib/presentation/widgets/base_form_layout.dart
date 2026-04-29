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
    // Détecter si le clavier est visible
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: appBarActions,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              // Option 5 : Réduire le padding en haut et en bas quand le clavier est visible
              padding: EdgeInsets.fromLTRB(
                16.0,
                isKeyboardVisible ? 8.0 : 16.0,
                16.0,
                isKeyboardVisible ? 8.0 : 16.0,
              ),
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

                  // Toujours afficher les boutons : le Scaffold pousse le
                  // layout au-dessus du clavier, masquer "Enregistrer" forçait
                  // l'utilisateur à fermer le clavier avant de valider.
                  _buildActionButtons(context),
                ],
              ),
            ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    // Détecter si le clavier est visible
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboardVisible = viewInsets.bottom > 0;

    return Container(
      // Réduire le padding en bas quand le clavier est visible
      padding: EdgeInsets.fromLTRB(0, 12.0, 0, isKeyboardVisible ? 8.0 : 16.0),
      // Réduire la marge en bas quand le clavier est visible
      margin: EdgeInsets.only(bottom: isKeyboardVisible ? 0.0 : 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            key: const Key('form-cancel-button'),
            onPressed: isSaving ? null : onCancel,
            child: const Text('Annuler'),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            key: const Key('form-save-button'),
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