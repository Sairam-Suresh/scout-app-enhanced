import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: const Text("hel"));
  }
}
