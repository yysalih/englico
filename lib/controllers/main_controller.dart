import 'package:englico/views/main_views/home_view.dart';
import 'package:englico/views/main_views/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum languageLevels {A1, A2, B1, B2, C1}

class MainState {
  final int bottomIndex;
  final String languageLevel;

  MainState({required this.bottomIndex, required this.languageLevel});

  MainState copyWith({int? bottomIndex, String? languageLevel,}) {
    return MainState(
      bottomIndex: bottomIndex ?? this.bottomIndex,
      languageLevel: languageLevel ?? this.languageLevel,
    );
  }
}

class MainController extends StateNotifier<MainState> {
  MainController(super.state);

  List<Map<String, dynamic>> languageLevels = [
    {"level" : "A1", "title" : "A1 Basic", "description" : "Temel İngilizce anlama ve kullanma becerilerine sahibim"},
    {"level" : "A2", "title" : "A2 Elemantary", "description" : "Günlük konularda basit İngilizce konuşabilirim"},
    {"level" : "B1", "title" : "B1 Intermediate", "description" : "Günlük yaşamda ve iş yerinde kullanılan kelimeleri anlayabilir ve kendimi ifade edebilirim"},
    {"level" : "B2", "title" : "B2 Upper Intermediate", "description" : "Karmaşık konularda konuşabilirim ve yazabilirim"},
    {"level" : "C1", "title" : "C1 Advanced", "description" : "İngilizceyi ana dilim gibi konuşabilirim"},
  ];

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

  setLanguageLevel(String value) async {
    state = state.copyWith(languageLevel: value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language_level", value);

    debugPrint(state.languageLevel.toString());
    debugPrint(prefs.getString("language_level")!.toString());
  }
}

final mainController = StateNotifierProvider<MainController, MainState>(
        (ref) => MainController(MainState(bottomIndex: 0, languageLevel: "")));