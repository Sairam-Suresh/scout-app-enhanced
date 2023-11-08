import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/google_auth_provider/auth_provider.dart';

class Settings extends HookConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var signedInAccount = ref.watch(googleAuthProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          children: [
            signedInAccount.when(
              data: (data) {
                if (data != null) {
                  return buildSignedInUserListTile(data, ref);
                } else {
                  return buildGuestListTile(ref);
                }
              },
              error: (error, stackTrace) {
                return buildSignInErrorListTile(ref);
              },
              loading: () {
                return buildGuestListTile(ref);
              },
            )
          ],
        ));
  }

  ListTile buildSignInErrorListTile(WidgetRef ref) {
    return ListTile(
      onTap: () {
        ref.read(googleAuthProvider.notifier).initiateSignIn();
      },
      leading: const Icon(Icons.error_outline, size: 40),
      title: const Text("Sign in failed."),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Tap to retry",
            style: TextStyle(fontSize: 19),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 35,
          )
        ],
      ),
    );
  }

  ListTile buildSignedInUserListTile(GoogleSignInAccount data, WidgetRef ref) {
    return ListTile(
      leading: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(data.photoUrl!)),
      title: Text(data.displayName!),
      subtitle: Text(data.email),
      trailing: IconButton(
          onPressed: () {
            ref.read(googleAuthProvider.notifier).signOut();
          },
          icon: const Icon(Icons.logout)),
    );
  }

  ListTile buildGuestListTile(WidgetRef ref) {
    return ListTile(
      onTap: () {
        ref.read(googleAuthProvider.notifier).initiateSignIn();
      },
      leading: const Icon(
        Icons.account_circle_outlined,
        size: 40,
      ),
      title: const Text(
        "Guest",
        style: TextStyle(fontSize: 23),
      ),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Tap to sign in",
            style: TextStyle(fontSize: 19),
          ),
          Icon(
            Icons.chevron_right_rounded,
            size: 35,
          )
        ],
      ),
    );
  }
}
