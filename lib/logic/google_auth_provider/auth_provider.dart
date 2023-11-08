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
    state = AsyncValue.data(await _googleSignIn.signIn());
    ref.invalidateSelf();
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _googleSignIn.disconnect();
    ref.invalidateSelf();
  }
}
