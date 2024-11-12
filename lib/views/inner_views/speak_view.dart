import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/speak_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/repository/word_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/ad_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';

class SpeakView extends ConsumerStatefulWidget {
  SpeakView({super.key});

  @override
  ConsumerState<SpeakView> createState() => _SpeakViewState();
}

class _SpeakViewState extends ConsumerState<SpeakView> {
  final CardSwiperController _cardSwiperController = CardSwiperController();

  bool isShuffled = false;

  @override
  void initState() {
    final speakRead = ref.read(speakController.notifier);
    speakRead.initSpeech();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final words = ref.watch(wordsStreamProvider);
    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final languageLevel = ref.watch(languageLevelProvider);

    final mainWatch = ref.watch(mainController.notifier);
    final adWatch = ref.watch(adController.notifier);
    final speakWatch = ref.watch(speakController.notifier);
    final speakState = ref.watch(speakController);


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
                final userWordList = words.where((element) => element.level == level &&
                    user.words!.contains(element.uid)).toList();
                if(!isShuffled) {
                  isShuffled = true;

                  userWordList.shuffle();
                }
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
                                //adWatch.showInterstitialAd();
                              }
                              Navigator.pop(context);

                            },
                            child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15.w, color: Colors.white),),
                          ),
                          Image.asset("assets/icons/speak.png", width: 30.w),
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
                                return const NoPracticeWidget();
                              }
                              final word = userWordList[index];
                              return Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: Container(
                                        width: width, height: height * .65,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft, end: Alignment.bottomRight,
                                            colors: [
                                              for(int i = 0; i < 4; i++)
                                                Constants.kSixthColor.withOpacity(
                                                    [.3, 0.2, 0.1, 0.1][i]
                                                )
                                            ]

                                          )
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 45.w, height: 50.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Constants.kThirdColor,
                                                    ),
                                                    child: Center(
                                                      child: Text(word.level!,
                                                        style: Constants.kTitleTextStyle.
                                                        copyWith(color: Colors.white),),
                                                    ),
                                                  ),
                                                  Image.asset("assets/icons/speak.png", width: 40.w,),
                                                  GestureDetector(
                                                    onTap: () => mainWatch.textToSpeech(word.english!.toString()),
                                                    child: Container(
                                                      width: 50, height: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),
                                                        color: Constants.kPrimaryColor,
                                                      ),
                                                      child: const Center(
                                                          child: Icon(Icons.audiotrack, color: Colors.white,)
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: width * .5, height: .5,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              Text(word.english!.toString(),
                                                style: Constants.kTitleTextStyle.copyWith(
                                                  fontSize: 35.w
                                                ),),
                                              Container(
                                                width: width * .5, height: .5,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [BoxShadow(
                                                      color: Colors.black12.withOpacity(.05),
                                                      spreadRadius: 1, blurRadius: 1)]
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      await Permission.microphone.request();
                                                    },
                                                    child: RichText(
                                                      textAlign: TextAlign.center,

                                                      text: TextSpan(

                                                        children: [
                                                          TextSpan(
                                                            text: "Senin söylediğin kelime:\n",
                                                            style: Constants.kTextStyle
                                                                .copyWith(color: Constants.kSecondColor,
                                                                fontWeight: FontWeight.bold, fontSize: 16.w),

                                                          ),
                                                          TextSpan(
                                                              text: speakState.speechEnabled
                                                                ? speakState.lastWords
                                                                    : 'Mikrofona izin vermek için tıklayınız',
                                                              style: Constants.kTextStyle.copyWith(
                                                                  color: Colors.black, fontSize: 18.w
                                                              )
                                                          ),
                                                        ]
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: width * .5, height: .5,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              Text(
                                                "Mikrofona basarak konuşmaya başlayabilirsin",
                                                style: Constants.kTextStyle
                                                    .copyWith(color: Colors.black,
                                                    fontSize: 15.w,),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                  ),
                                  SizedBox(height: 20.h,),
                                  bottomButtons(width, height, context, ref, word.uid!, user)
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

  bottomButtons(double width, double height, BuildContext context,
      WidgetRef ref, String wordUid, UserModel userModel) {
    final speakWatch = ref.watch(speakController.notifier);
    final speakState = ref.watch(speakController);
    final userRead = ref.read(userController.notifier);
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
              color: Constants.kPrimaryColor, iconColor: Colors.white,
              icon: speakWatch.speechToText.isNotListening ? Icons.mic_off : Icons.mic,
              onTap: () {
                if(speakWatch.speechToText.isNotListening) {
                  speakWatch.startListening();
                }
                else {
                  speakWatch.stopListening();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
