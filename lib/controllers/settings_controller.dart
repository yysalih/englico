import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class SettingsState {

}

class SettingsController extends StateNotifier<SettingsState> {
  SettingsController(super.state);

  List<Map<String, dynamic>> settingsWidgets = [
    {"icon" : "user", "title" : "Profili Düzenle"},
    {"icon" : "language", "title" : "Dil Seviyesi"},
    {"icon" : "subscription", "title" : "Abonelikler"},
    {"icon" : "money", "title" : "Para Kazanma"},
    {"icon" : "star", "title" : "Bizi Değerlendir"},
    {"icon" : "logout", "title" : "Çıkış Yap"},
    {"icon" : "trash", "title" : "Hesabımı Sil"},
  ];

  onShareXFileFromAssets(BuildContext context, String uid) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final data = await rootBundle.load('assets/logo.png');
    final buffer = data.buffer;
    final shareResult = await Share.shareXFiles(
      text: "Yenilikçi içerikler, eğlenceli sorularla Englico ile İngilizce öğrenme deneyimine başla.\n"
          "Size özel davet kodunuz:\n"
          "$uid"
          "\nPlay Store: https://play.google.com/store/apps/details?id=com.mapeve.mapeve"
          "\nApp Store: https://apps.apple.com/us/app/i-z/id6448877345",
      subject: "Englico ile İngilizce öğren",


      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'englico.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

  }
}


final settingsController = StateNotifierProvider<SettingsController, SettingsState>(
        (ref) => SettingsController(SettingsState()));