import 'package:connectivity_plus/connectivity_plus.dart';
import 'network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl({required this.connectivity});

  @override
  Future<bool> get isConnected async {
    final result = await connectivity.checkConnectivity();
    return result.any((connectivity) => 
      connectivity == ConnectivityResult.mobile ||
      connectivity == ConnectivityResult.wifi ||
      connectivity == ConnectivityResult.ethernet
    );
  }
}