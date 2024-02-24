import 'package:englico/views/main_views/home_view.dart';
import 'package:englico/views/main_views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainState {
  final int bottomIndex;

  MainState({required this.bottomIndex});

  MainState copyWith({int? bottomIndex}) {
    return MainState(
      bottomIndex: bottomIndex ?? this.bottomIndex,
    );
  }
}

class MainController extends StateNotifier<MainState> {
  MainController(super.state);

  List<Map<String, dynamic>> pageInfo = [
    {"label" : "Ana Sayfa", "icon" : "home"},
    {"label" : "Sıralama", "icon" : "trophy"},
    {"label" : "Deyimler", "icon" : "pen"},
    {"label" : "Kelimelerim", "icon" : "book"},
    {"label" : "Ayarlar", "icon" : "settings"},
  ];

  final PageController pageController = PageController(initialPage: 0);

  final List<Widget> pages = [HomeView(), Container(), Container(), Container(), const SettingsView()];

  changePage(int index) {
    state = state.copyWith(bottomIndex: index);

  }

  Route routeToSignInScreen(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

}

final mainController = StateNotifierProvider<MainController, MainState>(
        (ref) => MainController(MainState(bottomIndex: 0)));