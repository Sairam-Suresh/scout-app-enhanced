import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scout_app_enhanced/firebase_options.dart';
import 'package:scout_app_enhanced/screens/main/announcements/announcements.dart';
import 'package:scout_app_enhanced/screens/main/badge_catalogue/badge_viewer.dart';
import 'package:scout_app_enhanced/screens/main/badge_catalogue/search.dart';
import 'package:scout_app_enhanced/screens/main/experiences/experiences.dart';
import 'package:scout_app_enhanced/screens/main/root.dart';
import 'package:scout_app_enhanced/screens/main/settings/settings.dart';

import 'screens/main/badge_catalogue/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Firebase Crashlytics (Should only run in debug mode)
  if (!kDebugMode) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  initialLocation: "/home",
  routes: [
    ShellRoute(
        builder: (context, state, child) => Root(
              child: child,
            ),
        // pageBuilder: (context, state, child) => CustomTransitionPage(
        //       child: Root(
        //         child: child,
        //       ),
        //       transitionsBuilder:
        //           (context, animation, secondaryAnimation, child) =>
        //               FadeTransition(opacity: animation, child: child),
        //     ),
        routes: [
          GoRoute(
            path: '/home',
            routes: [
              GoRoute(
                path: 'search',
                builder: (context, state) => const BadgeSearch(),
              ),
              GoRoute(
                path: 'badge/:name',
                builder: (context, state) =>
                    BadgeViewer(name: state.pathParameters["name"]!),
              ),
            ],
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const Home(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        const Home(),
                maintainState: false),
          ),
          GoRoute(
            path: '/experiences',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const Experiences(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        const Experiences(),
                maintainState: false),
          ),
          GoRoute(
            path: '/announcements',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const Announcements(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        const Announcements(),
                maintainState: false),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => CustomTransitionPage(
                child: const Settings(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) =>
                        const Settings(),
                maintainState: false),
          ),
        ])
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
