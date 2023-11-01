import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scout_app_enhanced/logic/constants.dart';

@riverpod
class MyNotifier extends Notifier<ActiveTab> {
  @override
  ActiveTab build() => ActiveTab.home;

  void changeTab(ActiveTab tab) {
    state = tab;
  }
}

final rootIndexProvider =
    NotifierProvider<MyNotifier, ActiveTab>(MyNotifier.new);
