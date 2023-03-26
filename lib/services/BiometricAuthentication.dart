// ignore_for_file: non_constant_identifier_names, unused_local_variable
import 'package:local_auth/local_auth.dart';

class Biometrics {
  static final LocalAuthentication auth = LocalAuthentication();
  static bool isAuthenticating = false;
  // Can Authenticate?
  static Future<bool> CanAuthenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();  
    return canAuthenticateWithBiometrics;
  }

  static Future<List<BiometricType>> AvailableBiometrics() async {
    return await auth.getAvailableBiometrics();
  }

  // Biometric Authentication
  static Future<bool> Authenticate() async {
    if (!isAuthenticating) {
      isAuthenticating = true;
      bool authenticated = false;

      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      isAuthenticating = false;
      return authenticated;
    } else
      return false;
  }
}
