import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-9233337667665690/9877704419'; //ca-app-pub-3940256099942544/6300978111 test
      // ca-app-pub-9233337667665690/9877704419 real
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5044508379077917/5463600112';
    } else {

      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9233337667665690/6868397692";  //'ca-app-pub-9233337667665690/6868397692'; real
      // "ca-app-pub-3940256099942544/3986624511" test
    } else if (Platform.isIOS) {
      return 'ca-app-pub-5044508379077917/1103576917';
    }
    throw UnsupportedError("Unsupported platform");
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9233337667665690/4625377736"; // ca-app-pub-3940256099942544/1033173712 test
      // ca-app-pub-9233337667665690/4625377736 real
    } else if (Platform.isIOS) {
      return "ca-app-pub-5044508379077917/4618949745";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-9233337667665690/8373051052"; //ca-app-pub-3940256099942544/5224354917 test
      // ca-app-pub-9233337667665690/8373051052 real
    } else if (Platform.isIOS) {
      return "ca-app-pub-5044508379077917/2111942571";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}