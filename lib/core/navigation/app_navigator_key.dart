import 'package:flutter/material.dart';

/// Clé globale sur le Navigator racine de l'application.
///
/// Utilisée pour afficher un dialog (ou SnackBar) depuis un ViewModel ou
/// une couche qui n'a pas accès à un BuildContext stable — par exemple
/// quand l'opération asynchrone en cours démonte le widget qui a déclenché
/// l'action (cas du bouton de téléchargement, cf. issue #168).
final GlobalKey<NavigatorState> appRootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'appRootNavigatorKey');
