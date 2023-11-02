import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/constants.dart';

@riverpod
class RootIndexNotifier extends Notifier<Tabs> {
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

final rootIndexProvider =
    NotifierProvider<RootIndexNotifier, Tabs>(RootIndexNotifier.new);
