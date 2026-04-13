import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Mock implementation for connectivity checks in E2E tests.
/// Always reports WiFi connectivity by default.
///
/// Note: Does not extend [Connectivity] (which has a factory constructor).
/// Instead, use this where connectivity results are checked directly.
class MockConnectivity {
  List<ConnectivityResult> _result = [ConnectivityResult.wifi];
  final StreamController<List<ConnectivityResult>> _controller =
      StreamController<List<ConnectivityResult>>.broadcast();

  /// Set the connectivity result to return
  void setConnectivity(List<ConnectivityResult> result) {
    _result = result;
    _controller.add(result);
  }

  /// Simulate going offline
  void goOffline() {
    setConnectivity([ConnectivityResult.none]);
  }

  /// Simulate being on WiFi
  void goOnline() {
    setConnectivity([ConnectivityResult.wifi]);
  }

  /// Check current connectivity
  Future<List<ConnectivityResult>> checkConnectivity() async => _result;

  /// Stream of connectivity changes
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _controller.stream;

  void dispose() {
    _controller.close();
  }
}
