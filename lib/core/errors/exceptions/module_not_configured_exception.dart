/// Exception levée quand le serveur signale un module non configuré
/// (`configured: false`, gn_module_monitoring#752). Comme le module web, qui
/// bloque alors l'accès aux sites, visites et observations, l'application
/// refuse de le télécharger.
class ModuleNotConfiguredException implements Exception {
  final String moduleLabel;

  ModuleNotConfiguredException(this.moduleLabel);

  /// Texte affiché aussi sur la page d'un module déjà téléchargé.
  static const explanation =
      'Il lui manque un réglage sur le serveur GeoNature : liste '
      "d'observateurs, jeu de données, liste de taxons ou mode d'affichage "
      'des taxons. Un utilisateur autorisé à modifier ce module doit le '
      'configurer depuis le module Monitoring web.';

  @override
  String toString() =>
      "Le module $moduleLabel n'est pas encore configuré.\n\n$explanation";
}
