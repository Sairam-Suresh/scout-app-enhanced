import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Experiences extends HookConsumerWidget {
  const Experiences({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Experiences'),
        ),
        body: const Center(
          child: Text("Hello world"),
        ));
  }
}
