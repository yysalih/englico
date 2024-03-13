import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/user_model.dart';

import '../utils/ad_helper.dart';

class AdState {
  final bool isRewardedAdLoaded;
  final bool isBannerLoaded;
  final bool isInterLoaded;
  final BannerAd bannerAd;
  final int numRewardedLoadAttempts;
  // ... other state variables

  AdState({
    required this.isRewardedAdLoaded,
    required this.isBannerLoaded,
    required this.isInterLoaded,
    required this.bannerAd,
    required this.numRewardedLoadAttempts,
    // ...
  });

  AdState copyWith({
    bool? isRewardAdLoaded,
    bool? isInterLoaded,
    bool? isBannerLoaded,
    BannerAd? bannerAd,
    int? numRewardedLoadAttempts,
  }) {
    return AdState(
      isRewardedAdLoaded: isRewardAdLoaded ?? this.isRewardedAdLoaded,
      isInterLoaded: isInterLoaded ?? this.isInterLoaded,
      isBannerLoaded: isBannerLoaded ?? this.isBannerLoaded,
      bannerAd: bannerAd ?? this.bannerAd,
      numRewardedLoadAttempts: numRewardedLoadAttempts ?? this.numRewardedLoadAttempts,
    );
  }
}

class AdController extends StateNotifier<AdState> {
  AdController(AdState state) : super(state);

  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  BannerAd? bannerAd;

  void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize(height: 170, width: 400),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          state = state.copyWith(isBannerLoaded: true);
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    );
    bannerAd!.load();
  }

  Future<void> loadRewardedAd() async {
    RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            state = state.copyWith(isRewardAdLoaded: true);

          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            state = state.copyWith(numRewardedLoadAttempts: state.numRewardedLoadAttempts+1);
            if (state.numRewardedLoadAttempts < 3) {
              loadRewardedAd();
            }
            else {
              state = state.copyWith(isRewardAdLoaded: false);

            }
          },
        ));


  }

  Future<void> loadInterstitialAd() async {
    if(_interstitialAd == null) {
      print("it's empty");

      InterstitialAd.load(
          adUnitId: AdHelper.rewardedAdUnitId,
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              print('$ad loaded.');
              _interstitialAd = ad;
              state = state.copyWith(isInterLoaded: true);

            },
            onAdFailedToLoad: (LoadAdError error) {
              print('InterstitialAd failed to load: $error');
              _interstitialAd = null;
              loadInterstitialAd();

            },
          ));

    }
  }

  Future<void> showInterstitialAd() async {
    if(_interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
    } else if(_interstitialAd == null) {
      print("it's empty");
      loadInterstitialAd();
    }
  }

  Future<void> showRewardedAd(UserController userWatch, UserModel userModel, BuildContext context, {bool giveReward = true}) async {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          _rewardedAd = null;

          if(giveReward) {
            userWatch.canWatchRewardedAd();
          }
      }
    );

  }

  @override
  void dispose() {
    state.bannerAd.dispose();
    _interstitialAd!.dispose();
    _rewardedAd!.dispose();
    super.dispose();
  }
}

final adController = StateNotifierProvider<AdController, AdState>((ref) => AdController(AdState(
  numRewardedLoadAttempts: 0,
  bannerAd: BannerAd(
    adUnitId: AdHelper.bannerAdUnitId,
    request: const AdRequest(),
    size: AdSize(height: 170, width: 400),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (ad) {
        debugPrint('$ad loaded.');

      },
      // Called when an ad request failed.
      onAdFailedToLoad: (ad, err) {
        debugPrint('BannerAd failed to load: $err');
        // Dispose the ad here to free resources.
        ad.dispose();
      },
    ),
  ),
  isRewardedAdLoaded: false, isBannerLoaded: false, isInterLoaded: false
)));