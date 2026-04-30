class BadCredentialsException implements Exception {
  final String message;

  BadCredentialsException([
    this.message =
        "Identifiants invalides. Vérifiez votre login et votre mot de passe.",
  ]);

  @override
  String toString() => message;
}
