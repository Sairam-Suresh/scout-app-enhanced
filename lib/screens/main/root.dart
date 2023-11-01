import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/root_current_index_provider.dart';

import '../../logic/constants.dart';

class Root extends HookConsumerWidget {
  const Root({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var a = ref.read(rootIndexProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: ActiveTab.values.indexOf(a),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge), label: "Overview"),
          NavigationDestination(icon: Icon(Icons.book), label: "Experiences"),
          NavigationDestination(
              icon: Icon(Icons.announcement), label: "Announcements"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onDestinationSelected: (index) {
          ActiveTab? tab;
          switch (index) {
            case 0:
              tab = ActiveTab.home;
            case 1:
              tab = ActiveTab.experiences;
            case 2:
              tab = ActiveTab.announcements;
            case 3:
              tab = ActiveTab.settings;
            default:
              throw Exception("There cant be values that can bypass this!");
          }
          ref.read(rootIndexProvider.notifier).changeTab(tab);
          context.go("/${tab.name}");
        },
      ),
    );
  }
}
