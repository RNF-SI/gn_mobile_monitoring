import 'package:flutter/material.dart';

class FundersPage extends StatelessWidget {
  const FundersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF598979), // Brand color
        title: const Text("Financeurs du projet"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ce projet est financé par :",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Life logo
              Image.asset(
                'assets/logos/life.jpg',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 40),
              // Biodiv France logo
              Image.asset(
                'assets/logos/biodiv_france.png',
                height: 120,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
