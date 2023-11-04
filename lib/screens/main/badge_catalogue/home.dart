import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scout_app_enhanced/logic/scout_data_providers/scout_badges_provider.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var scoutBadges = ref.watch(scoutBadgeNotifierProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Badge Catalogue'),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          isExtended: true,
          label: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search),
              SizedBox(
                width: 10,
              ),
              Text(
                "Search",
                style: TextStyle(fontSize: 17),
              )
            ],
          ),
        ),
        body: Center(
            child: scoutBadges.when(
                data: (data) => Text(data.toString()),
                error: (error, stackTrace) => Text("Error occurred: $error"),
                loading: () => const CircularProgressIndicator())));
  }
}
