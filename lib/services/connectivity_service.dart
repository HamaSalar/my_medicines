import 'dart:io';

class ConnectivityService {
  // Define a property to hold the connectivity status
  bool isOnline = false;

  // Check the internet connection status
  Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
  }

  // Method to return the connectivity status
  Future<bool> isConnected() async {
    await checkInternetConnection();
    return isOnline;
  }
}
