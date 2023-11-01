import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Announcements extends HookConsumerWidget {
  const Announcements({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Announcements'),
        ),
        body: const Center(
          child: Text("Hello world"),
        ));
  }
}
