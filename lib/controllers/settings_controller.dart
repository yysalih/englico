import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {

}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(super.state);

  List<Map<String, dynamic>> settingsWidgets = [
    {"icon" : "user", "title" : "Profili Düzenle"},
    {"icon" : "language", "title" : "Dil Seviyesi"},
    {"icon" : "subscription", "title" : "Abonelikler"},
    {"icon" : "star", "title" : "Bizi Değerlendir"},
    {"icon" : "logout", "title" : "Çıkış Yap"},
    {"icon" : "trash", "title" : "Hesabımı Sil"},
  ];
}


final settingsController = StateNotifierProvider<SettingsController, SettingsState>(
        (ref) => SettingsController(SettingsState()));