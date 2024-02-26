import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/user_controller.dart';
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

import '../../models/user_model.dart';

class PracticeView extends ConsumerWidget {
  PracticeView({super.key});

  final CardSwiperController _cardSwiperController = CardSwiperController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final words = ref.watch(wordsStreamProvider);
    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final languageLevel = ref.watch(languageLevelProvider);

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
                    !user.words!.contains(element.uid)).toList();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white, backgroundColor: Constants.kPrimaryColor,
                              shape: const CircleBorder(),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15.w, color: Colors.white),),
                          ),
                        ),
                      ],
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
                                return NoMoreWidget();
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
                                                      child: Text(userWordList[index].level!,
                                                        style: Constants.kTitleTextStyle.
                                                        copyWith(color: Colors.white),),
                                                    ),
                                                  ),
                                                  Image.asset("assets/icons/practice.png", width: 40.w,),
                                                  Container(
                                                    width: 45.w, height: 50.h,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Constants.kPrimaryColor,
                                                    ),
                                                    child: const Center(
                                                      child: Icon(Icons.audiotrack, color: Colors.white,)
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                width: width * .7, height: 1,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              Text(userWordList[index].english!.toString(),
                                                style: Constants.kTitleTextStyle.copyWith(
                                                  fontSize: 40.w
                                                ),),
                                              Container(
                                                width: width * .7, height: 1,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              Text(userWordList[index].turkish.toString(),
                                                style: Constants.kTitleTextStyle.copyWith(
                                                    fontSize: 30.w, fontWeight: FontWeight.normal,
                      
                                                ),),
                                              Container(
                                                width: width * .7, height: 1,
                                                color: Constants.kPrimaryColor.withOpacity(.2),
                                              ),
                                              RichText(
                                                textAlign: TextAlign.center,
                      
                                                text: TextSpan(
                      
                                                  children: [
                                                    TextSpan(
                                                      text: "${userWordList[index].englishSentence.toString()}\n",
                                                      style: Constants.kTextStyle
                                                          .copyWith(color: Constants.kSecondColor,
                                                          fontWeight: FontWeight.bold, fontSize: 20.w),
                      
                                                    ),
                                                    TextSpan(
                                                        text: userWordList[index].turkishSentence.toString(),
                                                        style: Constants.kTextStyle.copyWith(
                                                            color: Colors.black, fontSize: 20.w
                                                        )
                                                    ),
                                                  ]
                                                ),
                                              )
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

  bottomButtons(double width, double height, BuildContext context, WidgetRef ref, String wordUid, UserModel userModel) {
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
              color: Constants.kPrimaryColor, iconColor: Colors.white, icon: Icons.thumb_up_alt_outlined,
              onTap: () async {
                //await userRead.addWordInUserWords(wordUid, userModel);

                _cardSwiperController.swipe(CardSwiperDirection.right);
              },
            ),
          ],
        ),
      ),
    );
  }
}
