import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gn_mobile_monitoring/config/config.dart';
import 'package:gn_mobile_monitoring/core/theme/app_colors.dart';
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
  bool _hasSubmitted = false;
  bool _showHttpsWarning = false;
  bool _isPinging = false;
  bool? _pingReachable;
  String _lastPingedUrl = '';

  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  /// Normalise l'URL de base saisie par l'utilisateur.
  /// Délègue à [Config.normalizeUserInputUrl] pour centraliser la logique.
  String _normalizeBaseUrl(String url) => Config.normalizeUserInputUrl(url);

  @override
  void initState() {
    super.initState();
    _apiUrl.addListener(_updateHttpsWarning);
    // Initialize API URL field from storage or use default
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final ref = ProviderScope.containerOf(context);
      final auth = ref.read(authenticationViewModelProvider);
      final apiUrl = await auth.getStoredApiUrl();
      if (!mounted) return;
      final initial = (apiUrl != null && apiUrl.isNotEmpty)
          ? apiUrl
          : Config.defaultApiUrl;
      // Utiliser `value` plutôt que `text` pour positionner explicitement le
      // curseur en fin de champ. Assigner `.text` directement laisse la
      // sélection à l'état invalide (-1) et provoque un select-all au tap sur
      // Android.
      _apiUrl.value = TextEditingValue(
        text: initial,
        selection: TextSelection.collapsed(offset: initial.length),
      );
    });
  }

  void _updateHttpsWarning() {
    final shouldWarn = Config.isInsecureHttpForProduction(_apiUrl.text);
    final pingObsolete =
        _pingReachable != null && _apiUrl.text.trim() != _lastPingedUrl;
    if (shouldWarn != _showHttpsWarning || pingObsolete) {
      setState(() {
        _showHttpsWarning = shouldWarn;
        if (pingObsolete) {
          _pingReachable = null;
        }
      });
    }
  }

  Future<void> _pingServer() async {
    if (_isPinging) return;
    final urlToPing = _apiUrl.text.trim();
    setState(() {
      _isPinging = true;
      _pingReachable = null;
    });
    final ref = ProviderScope.containerOf(context);
    final auth = ref.read(authenticationViewModelProvider);
    final result = await auth.pingServer(urlToPing);
    if (!mounted) return;
    setState(() {
      _isPinging = false;
      _pingReachable = result.reachable;
      _lastPingedUrl = urlToPing;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor:
            result.reachable ? Colors.green.shade700 : Colors.red.shade700,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _apiUrl.removeListener(_updateHttpsWarning);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Garder l'image fixe, le clavier passe par-dessus
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Image d'arrière-plan avec hauteur 100% et largeur adaptée
          Positioned.fill(
            child: Center(
              child: Image.asset(
                'assets/photo/splash_screen.jpg',
                fit: BoxFit.fitHeight,
                alignment: Alignment.center,
                height: double.infinity,
              ),
            ),
          ),
          // Overlay de couleur verte semi-transparent pour la lisibilité
          Positioned.fill(
            child: Container(
              color: AppColors.dark.withOpacity(0.2),
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
                    setState(() {
                      _hasSubmitted = true;
                    });
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
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.values[2], // Center the children
                        children: [
                          const Text.rich(
                            TextSpan(
                              text: 'Monitoring',
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 34),
                              children: [
                                TextSpan(
                                  text: 'Mobile',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
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
                              key: const Key('login-identifiant-field'),
                              controller: _identifiant,
                              keyboardType: TextInputType.emailAddress,
                              autovalidateMode: _hasSubmitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              decoration: const InputDecoration(
                                labelText: 'Identifiant',
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
                              key: const Key('login-password-field'),
                              controller: _password,
                              obscureText: true,
                              autovalidateMode: _hasSubmitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              decoration: const InputDecoration(
                                labelText: 'Mot de Passe',
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
                              autovalidateMode: _hasSubmitted
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              decoration: InputDecoration(
                                labelText: 'URL du serveur GeoNature',
                                hintText: 'https://geonature.mondomaine.org',
                                helperText: _showHttpsWarning
                                    ? 'Avertissement : http:// peut être refusé par le serveur. Préférez https://.'
                                    : 'https:// est ajouté automatiquement si aucun schéma n\'est saisi',
                                helperMaxLines: 2,
                                helperStyle: _showHttpsWarning
                                    ? const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.w600,
                                      )
                                    : null,
                                suffixIcon: _isPinging
                                    ? const Padding(
                                        padding: EdgeInsets.all(12),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      )
                                    : IconButton(
                                        tooltip: 'Tester la connexion au serveur',
                                        icon: Icon(
                                          _pingReachable == null
                                              ? Icons.network_check
                                              : _pingReachable == true
                                                  ? Icons.check_circle
                                                  : Icons.error,
                                          color: _pingReachable == null
                                              ? null
                                              : _pingReachable == true
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                        onPressed: _pingServer,
                                      ),
                              ),
                              keyboardType: TextInputType.url,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'L\'URL du serveur est nécessaire';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20), // Space before the button
                          MaterialButton(
                            key: const Key('login-button'),
                            onPressed: onPressedFunction,
                            color: AppColors.primary,
                            textColor: Colors.white,
                            minWidth: 200,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Text(
                              type == Status.login ? 'Se connecter' : 'Sign up',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20), // Space at the bottom
                          if (_isLoading) ...[
                            const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary)),
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
                                        child: Column(
                                          children: [
                                            SelectableText(
                                              loginStatus.errorDetails!,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 4),
                                            TextButton.icon(
                                              icon: const Icon(
                                                Icons.copy,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Copier l\'erreur',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              onPressed: () async {
                                                await Clipboard.setData(
                                                  ClipboardData(
                                                    text: loginStatus
                                                        .errorDetails!,
                                                  ),
                                                );
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Erreur copiée dans le presse-papier',
                                                      ),
                                                      duration:
                                                          Duration(seconds: 2),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
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
          // Logo LIFE et texte de copyright en bas
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/photo/logo_life.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '© B CAUVIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
