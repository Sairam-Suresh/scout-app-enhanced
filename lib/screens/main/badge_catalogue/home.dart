import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/constants.dart';

import '../../../logic/current_index_provider/root_current_index_provider.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Badge Catalogue'),
        ),
        body: Center(
          child: FilledButton(
              onPressed: () {
                // context.go("/experiences");
                ref
                    .read(rootIndexNotifierProvider.notifier)
                    .changeTabAndGo(context: context, tab: Tabs.experiences);
              },
              child: const Text("Go")),
        ));
  }
}
