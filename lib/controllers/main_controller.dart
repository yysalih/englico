import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englico/views/main_views/best_users_view.dart';
import 'package:englico/views/main_views/home_view.dart';
import 'package:englico/views/main_views/saved_words_view.dart';
import 'package:englico/views/main_views/sayings_view.dart';
import 'package:englico/views/main_views/settings_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum languageLevels {A1, A2, B1, B2, C1}

class MainState {
  final int bottomIndex;
  final String languageLevel;
  final String selectedTab;

  MainState({required this.bottomIndex,
    required this.languageLevel,
    required this.selectedTab,
  });

  MainState copyWith({int? bottomIndex, String? languageLevel, String? selectedTab,}) {
    return MainState(
      bottomIndex: bottomIndex ?? this.bottomIndex,
      languageLevel: languageLevel ?? this.languageLevel,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class MainController extends StateNotifier<MainState> {
  MainController(super.state);

  FlutterTts flutterTts = FlutterTts();


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

  final List<Widget> pages = [ HomeView(), BestUsersView(), SayingsView(),
    SavedWordsView(), SettingsView()];

  changePage(int index) {
    state = state.copyWith(bottomIndex: index);
  }

  Future<void> configureTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.75);
    await flutterTts.setVolume(1.0);
  }

  void textToSpeech(String text) async {
    await flutterTts.speak(text);
  }

  void stopSpeaking() async {
    await flutterTts.stop();
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

  checkPointsCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //week
    if(prefs.containsKey("week")) {
      int month = prefs.getInt("week")!;

      if(month != DateTime.now().weekday) {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "weeklyPoint" : 0
        });
        prefs.setInt("week", DateTime.now().weekday);
      }

    }
    else {
      prefs.setInt("week", DateTime.now().weekday);
    }

    //month
    if(prefs.containsKey("month")) {
      int month = prefs.getInt("month")!;

      if(month != DateTime.now().month) {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "monthlyPoint" : 0
        });
        prefs.setInt("month", DateTime.now().month);
      }

    }
    else {
      prefs.setInt("month", DateTime.now().month);
    }

    //year
    if(prefs.containsKey("year")) {
      int month = prefs.getInt("year")!;

      if(month != DateTime.now().year) {
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          "annuallyPoint" : 0
        });
        prefs.setInt("year", DateTime.now().year);
      }

    }
    else {
      prefs.setInt("year", DateTime.now().year);
    }

  }

  changeSelectedTab(String value) {
    state = state.copyWith(selectedTab: value);
  }
}

final mainController = StateNotifierProvider<MainController, MainState>(
        (ref) => MainController(MainState(bottomIndex: 0, languageLevel: "", selectedTab: "point")));