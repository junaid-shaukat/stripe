import 'dart:async';

import '/core/app_export.dart';

class ConnectivityController extends GetxController {
  final RxBool isConnected = false.obs;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  Stream<bool> get connectionStream => isConnected.stream;

  @override
  void onInit() {
    super.onInit();
    _initializeConnectivity();
  }

  @override
  void onClose() {
    _disposeSubscription();
    super.onClose();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final List<ConnectivityResult> initialResults = await _connectivity
          .checkConnectivity();
      _handleConnectivityUpdate(initialResults);
    } catch (e) {
      isConnected.value = false;
    } finally {
      _setupListener();
    }
  }

  void _setupListener() {
    _subscription = _connectivity.onConnectivityChanged.listen(
      _handleConnectivityUpdate,
      onError: (error) {},
    );
  }

  void _handleConnectivityUpdate(List<ConnectivityResult> results) {
    final bool hasConnection = results.any(
      (result) => result != ConnectivityResult.none,
    );

    if (isConnected.value != hasConnection) {
      isConnected.value = hasConnection;
    }
  }

  Future<void> _disposeSubscription() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
