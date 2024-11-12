import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MarketState {

}

class MarketController extends StateNotifier<MarketState> {
  MarketController(super.state);

  extendSubscriptionDate(String userUid, Duration duration) async {
    await FirebaseFirestore.instance.collection("users").doc(userUid).update({
      "subscriptionDate" : DateTime.now().add(duration).millisecondsSinceEpoch
    });
  }

}

final marketController = StateNotifierProvider<MarketController, MarketState>((ref) => MarketController(
  MarketState()
));