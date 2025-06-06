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
  String _previewUrl = '';

  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  /// Normalise l'URL en ajoutant automatiquement /api si nécessaire
  String _normalizeApiUrl(String url) {
    // Nettoyer l'URL
    String cleanUrl = url.trim();
    
    // Supprimer le slash final s'il existe
    if (cleanUrl.endsWith('/')) {
      cleanUrl = cleanUrl.substring(0, cleanUrl.length - 1);
    }
    
    // Ajouter /api s'il n'est pas déjà présent
    if (!cleanUrl.endsWith('/api')) {
      cleanUrl = '$cleanUrl/api';
    }
    
    return cleanUrl;
  }

  /// Met à jour l'aperçu de l'URL normalisée
  void _updateUrlPreview() {
    if (_apiUrl.text.isNotEmpty) {
      setState(() {
        _previewUrl = _normalizeApiUrl(_apiUrl.text);
      });
    } else {
      setState(() {
        _previewUrl = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Ajouter un listener pour mettre à jour l'aperçu en temps réel
    _apiUrl.addListener(_updateUrlPreview);
    // Initialize API URL field from storage or use default
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ref = ProviderScope.containerOf(context);
      final auth = ref.read(authenticationViewModelProvider);
      final apiUrl = await auth.getStoredApiUrl();
      setState(() {
        if (apiUrl != null && apiUrl.isNotEmpty) {
          // Si l'URL stockée contient déjà /api, la retirer pour l'affichage
          String displayUrl = apiUrl;
          if (displayUrl.endsWith('/api')) {
            displayUrl = displayUrl.substring(0, displayUrl.length - 4);
          }
          _apiUrl.text = displayUrl;
        } else {
          // Utiliser l'URL par défaut si aucune n'est stockée
          _apiUrl.text = Config.defaultApiUrl;
        }
        // Mettre à jour l'aperçu après avoir défini l'URL
        _updateUrlPreview();
      });
    });
  }

  @override
  void dispose() {
    _apiUrl.removeListener(_updateUrlPreview);
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
                      // Normaliser l'URL en ajoutant /api automatiquement
                      final normalizedUrl = _normalizeApiUrl(_apiUrl.text);
                      await auth.saveApiUrl(normalizedUrl);

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _apiUrl,
                                  decoration: InputDecoration(
                                    fillColor: const Color(0xFFF4F1E4),
                                    filled: true,
                                    labelText: 'URL du serveur GeoNature',
                                    hintText: 'https://geonature.mondomaine.org',
                                    helperText: 'Saisissez l\'URL de base (sans /api)',
                                    helperStyle: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 3,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
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
                                if (_previewUrl.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.95),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF8AAC3E).withOpacity(0.5),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.info_outline,
                                          color: Color(0xFF2D5A2D),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'URL de l\'API qui sera utilisée :',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF2D5A2D),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                _previewUrl,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF1A4A1A),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
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
