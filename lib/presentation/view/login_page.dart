import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  bool _isLoading = false;

  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/photo/splash_screen.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Consumer(builder: (context, ref, _) {
            final auth = ref.watch(authenticationViewModelProvider);

            Future<void> onPressedFunction() async {
              if (_formKey.currentState!.validate()) {
                loading();
                await auth.signInWithEmailAndPassword(
                    _identifiant.text, _password.text, context, ref);
                loading();
              }
            }

            return Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.values[2], // Center the children
                children: [
                  const Text.rich(
                    TextSpan(
                      text: 'Monitoring',
                      style: TextStyle(color: Colors.white, fontSize: 34),
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
                  const SizedBox(height: 20), // Space between title and form
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
                          borderSide:
                              const BorderSide(color: Color(0xFF7DAB9C)),
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
                  const SizedBox(height: 16), // Space between form fields
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
                          borderSide:
                              const BorderSide(color: Color(0xFF7DAB9C)),
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20), // Space at the bottom
                  if (_isLoading) ...[
                    const CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF8AAC3E))),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, _) {
                        final loginStatus = ref.watch(loginStatusProvider);
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
                      height: 20), // Additional space at the bottom if loading
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
