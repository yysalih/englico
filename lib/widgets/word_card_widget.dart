import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/user_model.dart';
import 'package:englico/models/word_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/main_controller.dart';
import '../utils/contants.dart';

class WordCardWidget extends ConsumerWidget {
  final WordModel word;
  final UserModel user;
  const WordCardWidget({super.key, required this.word, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final mainWatch = ref.watch(mainController.notifier);
    final userWatch = ref.watch(userController.notifier);

    return ClipRRect(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 45, height: 45,
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
                    Image.asset("assets/icons/learn.png", width: 40.w,),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => mainWatch.textToSpeech(word.english!.toString()),
                          child: Container(
                            width: 45, height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.kPrimaryColor,
                            ),
                            child: const Center(
                                child: Icon(Icons.audiotrack, color: Colors.white,)
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => userWatch.addInUserSavedWords(user, word.uid!),
                          child: Container(
                            width: 45, height: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Constants.kPrimaryColor,
                            ),
                            child: Center(
                                child: Icon(user.savedWords!.contains(word.uid!) ?
                                Icons.bookmark_added
                                    :
                                Icons.bookmark_add, color: Colors.white,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(word.english!.toString(),
                  style: Constants.kTitleTextStyle.copyWith(
                      fontSize: 40.w
                  ),),
                Container(
                  width: width * .5, height: .5,
                  color: Constants.kPrimaryColor.withOpacity(.2),
                ),
                Text(word.turkish.toString(),
                  style: Constants.kTitleTextStyle.copyWith(
                    fontSize: 30.w, fontWeight: FontWeight.normal,

                  ),),
                Container(
                  width: width * .5, height: .5,
                  color: Constants.kPrimaryColor.withOpacity(.2),
                ),
                RichText(
                  textAlign: TextAlign.center,

                  text: TextSpan(

                      children: [
                        TextSpan(
                          text: "${word.englishSentence.toString()}\n",
                          style: Constants.kTextStyle
                              .copyWith(color: Constants.kSecondColor,
                              fontWeight: FontWeight.bold, fontSize: 20.w),

                        ),
                        TextSpan(
                            text: word.turkishSentence.toString(),
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
    );
  }
}
