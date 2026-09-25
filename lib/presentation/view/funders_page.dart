import 'package:flutter/material.dart';
import 'package:gn_mobile_monitoring/core/widgets/eu_funding_notice.dart';

class FundersPage extends StatelessWidget {
  const FundersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Financeurs du projet"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: const EuFundingNotice(),
            ),
          ),
        ),
      ),
    );
  }
}
