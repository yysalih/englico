import 'package:englico/controllers/test_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/question_model.dart';
import 'package:englico/models/user_model.dart';
import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonQuestionView extends ConsumerWidget {
  final Map<String, dynamic> question;
  final UserModel userModel;
  final QuestionModel questionModel;

  const CommonQuestionView({super.key,
    required this.question,
    required this.userModel,
    required this.questionModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;

    final testState = ref.watch(testController);
    final testWatch = ref.watch(testController.notifier);

    final userWatch = ref.watch(userController.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question["type"] == "complete_sentence" ? question["uncompleted_sentence"]
              : question["question_text"],
            style: Constants.kTitleTextStyle.copyWith(color: Colors.black),),
          SizedBox(height: 10.h),
          for(int i = 0; i < (question["answers"] as List).length; i++)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Container(
                width: width, height: 55.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1, spreadRadius: 1)]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: () {
                      testWatch.changeIsAnswered(value: true);
                      if(question["answers"][i] == question["answer"]) {
                        testWatch.changePoint(value: testState.point + questionModel.point!);
                        userWatch.addPointToUser(userModel, questionModel.point!);
                      }
                    },
                    child: Center(
                      child: Text(question["answers"][i], style: Constants.kTitleTextStyle.copyWith(
                          color: testState.isAnswered ? Colors.white : Colors.black
                      ),),
                    ),
                    color: testState.isAnswered ? question["answers"][i] == question["answer"]
                        ? Colors.green
                        : Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
