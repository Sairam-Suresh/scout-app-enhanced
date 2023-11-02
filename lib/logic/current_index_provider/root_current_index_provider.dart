import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/constants.dart';

part 'root_current_index_provider.g.dart';

@Riverpod(keepAlive: true)
class RootIndexNotifier extends _$RootIndexNotifier {
  @override
  Tabs build() => Tabs.home;

  void _changeTab(Tabs tab) {
    state = tab;
  }

  void changeTabAndGo({required BuildContext context, required Tabs tab}) {
    _changeTab(tab);
    context.go("/${state.name}");
  }
}
