import 'package:englico/controllers/test_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/question_models/word_match_model.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/content_model.dart';
import '../../models/question_model.dart';
import '../../models/test_model.dart';
import '../../models/user_model.dart';

class WordMatchView extends ConsumerWidget {
  final WordMatchModel wordMatchModel;
  final List<QuestionModel> allQuestions;
  final List<ContentModel> contents;
  final UserModel user;
  final List<TestModel> tests;

  const WordMatchView({
    super.key,
    required this.wordMatchModel,
    required this.allQuestions,
    required this.user,
    required this.tests,
    required this.contents
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final testWatch = ref.watch(testController.notifier);
    final userWatch = ref.watch(userController.notifier);
    final testState = ref.watch(testController);

    final keys = wordMatchModel.words!.keys.toList().where((element) => !testState.correctKeys.contains(element)).toList();
    final values = wordMatchModel.words!.values.toList().where((element) => !testState.correctValues.contains(element)).toList();


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Kelime Eşleştirme", style: Constants.kTitleTextStyle,),
          const Text("Verilen İngilizce ve Türkçe kelimeleri eşleştirin.",
            style: Constants.kTextStyle,),
          SizedBox(height: 10.h,),
          keys.isEmpty ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100.h,),

                  Image.asset("assets/icons/done2.png", width: 100.w,),
                  SizedBox(height: 20.h,),
                  const Text("Verilen İngilizce ve Türkçe kelimeleri bitirdiniz.\nTebrikler!",
                  style: Constants.kTextStyle, textAlign: TextAlign.center,
                  )
                    ],
              )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  for(int i = 0; i < keys.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: 100.w, height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [BoxShadow(color: Constants.kSecondColor, spreadRadius: 1, blurRadius: 1)],
                          //border: Border.all(color: Constants.kFourthColor, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: MaterialButton(
                            color: testState.key == keys[i] ? testState.selectedKeyColor : Colors.white,
                            onPressed: () {
                              if(testState.key.isEmpty || keys[i] != testState.key) {
                                testWatch.changeKeyOrValue(keys[i]);
                                testWatch.changeSelectedColor(Colors.white, isKey: false);
                                testWatch.changeKeyOrValue("", isKey: false);


                              }
                              else {
                                testWatch.changeKeyOrValue("");
                                testWatch.changeKeyOrValue("", isKey: false);
                                testWatch.changeSelectedColor(Colors.white, isKey: false);
                              }
                            },
                            child: Text(keys[i], style: Constants.kTextStyle.copyWith(
                              color: testState.key == keys[i] ? Colors.white : Colors.black,

                            ), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Column(
                children: [
                  for(int i = 0; i < values.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        width: 100.w, height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [BoxShadow(color: Constants.kSecondColor,
                              spreadRadius: 1, blurRadius: 1)],
                          //border: Border.all(color: Constants.kFourthColor, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: MaterialButton(
                            color: testState.value == values[i] ? testState.selectedValueColor : Colors.white,
                            onPressed: () {
                              if(keys.isEmpty) {
                                testWatch.changeIsAnswered(value: true);
                                testWatch.continueButton(
                                    allQuestions: allQuestions,
                                    contents: contents,
                                    tests: tests,
                                    user: user,
                                    userWatch: userWatch
                                );

                              }

                              if(testState.key.isNotEmpty) {
                                testWatch.changeKeyOrValue(values[i], isKey: false);
                                if(testState.value.isEmpty) {
                                  testWatch.changeKeyOrValue(values[i], isKey: false);
                                }
                                else {
                                  testWatch.changeKeyOrValue("", isKey: false);
                                }
                                Future.delayed(const Duration(milliseconds: 75), () {
                                  final testState = ref.read(testController);

                                  if(wordMatchModel.words![testState.key] != testState.value) {
                                    testWatch.changeSelectedColor(Colors.redAccent, isKey: true);
                                    testWatch.changeSelectedColor(Colors.redAccent, isKey: false);

                                    Future.delayed(const Duration(milliseconds: 75), () {
                                      testWatch.resetAll();
                                    },);
                                  }
                                  else {
                                    testWatch.changeSelectedColor(Colors.green, isKey: true);
                                    testWatch.changeSelectedColor(Colors.green, isKey: false);
                                    Future.delayed(const Duration(milliseconds: 75), () {
                                      testWatch.addInCorrectedKeysValues(testState.key);
                                      testWatch.addInCorrectedKeysValues(testState.value, isKey: false);

                                      testWatch.resetAll();
                                    },);
                                  }


                                },);

                              }

                            },
                            child: Text(values[i], style: Constants.kTextStyle.copyWith(
                              color: testState.value == values[i] ? Colors.white : Colors.black,
                            ), textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
