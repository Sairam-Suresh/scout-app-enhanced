import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../logic/constants.dart';
import '../../logic/current_index_provider/root_current_index_provider.dart';

class Root extends HookConsumerWidget {
  const Root({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var a = ref.watch(rootIndexNotifierProvider);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: Tabs.values.indexOf(a),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.badge), label: "Overview"),
          NavigationDestination(icon: Icon(Icons.book), label: "Experiences"),
          NavigationDestination(
              icon: Icon(Icons.announcement), label: "Announcements"),
          NavigationDestination(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onDestinationSelected: (index) {
          Tabs? tab;
          switch (index) {
            case 0:
              tab = Tabs.home;
            case 1:
              tab = Tabs.experiences;
            case 2:
              tab = Tabs.announcements;
            case 3:
              tab = Tabs.settings;
            default:
              throw Exception("There can't be values that can bypass this!");
          }
          ref
              .read(rootIndexNotifierProvider.notifier)
              .changeTabAndGo(context: context, tab: tab);
        },
      ),
    );
  }
}
