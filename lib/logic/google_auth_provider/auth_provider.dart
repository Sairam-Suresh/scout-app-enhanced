import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/sensitive.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class GoogleAuth extends _$GoogleAuth {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: googleClientId,
  );

  @override
  Future<GoogleSignInAccount?> build() async {
    return await _googleSignIn.signInSilently();
  }

  Future<void> initiateSignIn() async {
    try {
      var user = await _googleSignIn.signIn();
      if (user != null) {
        state = AsyncValue.data(user);
      } else {
        throw Exception("Login Failed.");
      }
      ref.invalidateSelf();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    ref.invalidateSelf();
  }
}
