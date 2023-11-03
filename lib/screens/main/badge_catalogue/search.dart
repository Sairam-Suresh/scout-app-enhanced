import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BadgeSearch extends HookConsumerWidget {
  const BadgeSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
        body: Column(
      children: [SearchBar()],
    ));
  }
}
