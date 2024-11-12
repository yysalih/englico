import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/word_model.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/repository/word_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/widgets/custom_button.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../controllers/ad_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/word_card_widget.dart';

class PracticeView extends ConsumerStatefulWidget {
  PracticeView({super.key});

  @override
  ConsumerState<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends ConsumerState<PracticeView> {
  final CardSwiperController _cardSwiperController = CardSwiperController();

  @override
  void initState() {
    final userStream = ref.read(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    userStream.when(
      data: (user) {
        final adRead = ref.read(adController.notifier);
        if(!user.isUserPremium) {
          adRead.loadInterstitialAd();
        }
      },
      loading: () {
        debugPrint("loading");
      },
      error: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      },
    );
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final words = ref.watch(wordsStreamProvider);
    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final languageLevel = ref.watch(languageLevelProvider);

    final mainState = ref.watch(mainController);
    final mainWatch = ref.watch(mainController.notifier);

    final adWatch = ref.watch(adController.notifier);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: user.when(
          error: (error, stackTrace) => const AppErrorWidget(),
          loading: () => const LoadingWidget(),
          data: (user) => languageLevel.when(
            error: (error, stackTrace) => const AppErrorWidget(),
            loading: () => const LoadingWidget(),
            data: (level) => words.when(
              error: (error, stackTrace) => const AppErrorWidget(),
              loading: () => const LoadingWidget(),
              data: (words) {
                final userWordList = words.where((element) => (element.level == level
                    || element.level == mainState.languageLevel) &&
                    user.words!.contains(element.uid)).toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 10,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Constants.kPrimaryColor,
                              shape: const CircleBorder(),
                            ),
                            onPressed: () {
                              if(!user.isUserPremium) {
                                adWatch.showInterstitialAd();
                              }
                              Navigator.pop(context);

                            },
                            child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15.w, color: Colors.white),),
                          ),
                          Image.asset("assets/icons/practice.png", width: 40.w),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(17.h),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 0, top: 0),
                          child: CardSwiper(
                            padding: EdgeInsets.zero,
                            scale: 1,
                            backCardOffset: Offset.zero,
                            allowedSwipeDirection:
                            const AllowedSwipeDirection.symmetric(vertical: false, horizontal: false),
                            numberOfCardsDisplayed: 1,
                            onSwipe: (previousIndex, currentIndex, direction) async {

                              return true;
                            },
                            isLoop: true,
                            controller: _cardSwiperController,
                            onEnd: () {

                            },

                            cardBuilder: (context, index, a, b) {
                              if(userWordList.isEmpty) {
                                return const NoMoreWidget();
                              }
                              final word = userWordList[index];
                              return Column(
                                children: [
                                  WordCardWidget(word: userWordList[index], user: user),
                                  SizedBox(height: 20.h,),
                                  bottomButtons(width, height, context, ref, word, user)
                                ],
                              );
                            },
                            cardsCount: userWordList.isEmpty ? 1 : userWordList.length,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          )
        ),
      ),
    );
  }

  bottomButtons(double width, double height, BuildContext context, WidgetRef ref,
      WordModel word, UserModel userModel) {
    final mainWatch = ref.watch(mainController.notifier);

    return Container(
      width: width, height: height * .15,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Constants.kSixthColor.withOpacity(.3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(
              color: Colors.white, icon: Icons.refresh, iconColor: Colors.black, onTap: () {
              _cardSwiperController.swipe(CardSwiperDirection.left);},
            ),
            CustomButton(
              color: Constants.kPrimaryColor, iconColor: Colors.white, icon: Icons.thumb_up_alt_outlined,
              onTap: () async {
                //await userRead.addWordInUserWords(wordUid, userModel);
                mainWatch.textToSpeech(word.english!);
                _cardSwiperController.swipe(CardSwiperDirection.right);
              },
            ),
          ],
        ),
      ),
    );
  }
}
