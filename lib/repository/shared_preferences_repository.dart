import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

final languageLevelProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  if(prefs.containsKey("language_level")) {
    debugPrint("in if: ${prefs.getString("language_level")!}");
    return prefs.getString("language_level")!;
  }
  else {
    debugPrint("in else");

    prefs.setString("language_level", "");
    return prefs.getString("language_level")!;
  }
});
