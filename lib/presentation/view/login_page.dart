import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/presentation/viewmodel/auth/auth_viewmodel.dart';

enum Status {
  login,
}

Status type = Status.login;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _identifiant = TextEditingController();
  final _password = TextEditingController();
  final _apiUrl = TextEditingController();

  bool _isLoading = false;

  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  /// Normalise l'URL de base (nettoie seulement)
  String _normalizeBaseUrl(String url) {
    // Nettoyer l'URL
    String cleanUrl = url.trim();

    // Supprimer le slash final s'il existe
    if (cleanUrl.endsWith('/')) {
      cleanUrl = cleanUrl.substring(0, cleanUrl.length - 1);
    }

    // Supprimer /api s'il est présent
    if (cleanUrl.endsWith('/api')) {
      cleanUrl = cleanUrl.substring(0, cleanUrl.length - 4);
    }

    return cleanUrl;
  }

  @override
  void initState() {
    super.initState();
    // Initialize API URL field from storage or use default
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ref = ProviderScope.containerOf(context);
      final auth = ref.read(authenticationViewModelProvider);
      final apiUrl = await auth.getStoredApiUrl();
      setState(() {
        if (apiUrl != null && apiUrl.isNotEmpty) {
          // L'URL stockée est maintenant l'URL de base (sans /api)
          _apiUrl.text = apiUrl;
        } else {
          // Utiliser l'URL par défaut si aucune n'est stockée
          _apiUrl.text = Config.defaultApiUrl;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Permettre au contenu de se déplacer quand le clavier apparaît
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Image d'arrière-plan occupant tout l'écran
          Positioned.fill(
            child: ClipRect(
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Transform.scale(
                  scale: 1, // Facteur de zoom (plus petit = moins zoomé)
                  child: Image.asset(
                    'assets/photo/splash_screen.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ),
          ),
          // Overlay de couleur verte semi-transparent pour la lisibilité
          Positioned.fill(
            child: Container(
              color: const Color(0xFF598979).withOpacity(0.2),
            ),
          ),
          // Contenu du formulaire
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                // Ajouter un padding vertical pour mieux positionner le formulaire
                padding: const EdgeInsets.symmetric(vertical: 20),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Consumer(builder: (context, ref, _) {
                  final auth = ref.watch(authenticationViewModelProvider);

                  Future<void> onPressedFunction() async {
                    if (_formKey.currentState!.validate()) {
                      loading();
                      // Normaliser l'URL de base (sans /api)
                      final normalizedBaseUrl = _normalizeBaseUrl(_apiUrl.text);
                      await auth.saveApiUrl(normalizedBaseUrl);

                      await auth.signInWithEmailAndPassword(
                          _identifiant.text, _password.text, context, ref);
                      if (mounted) {
                        loading();
                      }
                    }
                  }

                  return Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.only(
                        // Marge supplémentaire en bas pour éviter le clavier
                        bottom: MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom + 20
                            : 0,
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.values[2], // Center the children
                        children: [
                          const Text.rich(
                            TextSpan(
                              text: 'Monitoring',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 34),
                              children: [
                                TextSpan(
                                  text: 'Mobile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF8AAC3E),
                                    fontSize: 45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                              height: 20), // Space between title and form
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _identifiant,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFF4F1E4),
                                filled: true,
                                labelText: 'Identifiant',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7DAB9C)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "L'identifiant est nécessaire";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                              height: 16), // Space between form fields
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _password,
                              obscureText: true,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFF4F1E4),
                                filled: true,
                                labelText: 'Mot de Passe',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7DAB9C)),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Le mot de passe est nécessaire';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // URL de l'API (maintenant toujours visible)
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              controller: _apiUrl,
                              decoration: InputDecoration(
                                fillColor: const Color(0xFFF4F1E4),
                                filled: true,
                                labelText: 'URL du serveur GeoNature',
                                hintText: 'https://geonature.mondomaine.org',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFF7DAB9C)),
                                ),
                              ),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'L\'URL du serveur est nécessaire';
                                }
                                // Simple URL validation
                                if (!value.startsWith('http://') &&
                                    !value.startsWith('https://')) {
                                  return 'L\'URL doit commencer par http:// ou https://';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20), // Space before the button
                          MaterialButton(
                            onPressed: onPressedFunction,
                            color: const Color(0xFF8AAC3E),
                            textColor: Colors.white,
                            minWidth: 200,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              type == Status.login ? 'Log in' : 'Sign up',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20), // Space at the bottom
                          if (_isLoading) ...[
                            const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF8AAC3E))),
                            const SizedBox(height: 16),
                            Consumer(
                              builder: (context, ref, _) {
                                final loginStatus =
                                    ref.watch(loginStatusProvider);
                                return Column(
                                  children: [
                                    Text(
                                      loginStatus.message,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (loginStatus.errorDetails != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, left: 20, right: 20),
                                        child: Text(
                                          loginStatus.errorDetails!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                          const SizedBox(
                              height:
                                  20), // Additional space at the bottom if loading
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
