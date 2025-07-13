import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance =
      ConnectivityService._createInstance();
  factory ConnectivityService() => _instance;
  static ConnectivityService get instance => _instance;

  static final Connectivity _connectivity = Connectivity();

  final StreamController<(ConnectivityResult, bool)>
  _connectionStatusController =
      StreamController<(ConnectivityResult, bool)>.broadcast();

  ConnectivityService._createInstance() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final primaryResult =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
      _connectionStatusController.add((primaryResult, false));
    });
  }

  /// Use this in interceptors or services to check current status
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }

  /// Use this stream in UI to listen to real-time connection changes
  Stream<(ConnectivityResult, bool)> get connectionStatusStream =>
      _connectionStatusController.stream;
}
