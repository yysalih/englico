import 'package:englico/controllers/test_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/repository/content_repository.dart';
import 'package:englico/repository/question_repository.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/test_repository.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/views/question_views/common_question_view.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/contants.dart';

class TestView extends ConsumerWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(testController);
    final testWatch = ref.watch(testController.notifier);

    final userWatch = ref.watch(userController.notifier);

    final contentProvider = ref.watch(contentsStreamProvider);
    final currentuser = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final languageLevel = ref.watch(languageLevelProvider);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: languageLevel.when(
          data: (level) => currentuser.when(
            data: (user) => contentProvider.when(
              data: (allContents) {
                final contents = allContents.where((element) => element.level == level
                    && !user.contents!.contains(element.uid)).toList();

                final testsProvider = ref.watch(testsStreamProvider("${contents.first.uid}englico"));

                return testsProvider.when(
                  data: (allTests) {
                  try {
                     final tests = allTests.where((element) =>
                     !user.tests!.contains(element.uid)).toList();

                     final questionsProvider = ref.watch(questionsStreamProvider(
                         "${contents.first.uid}englico${tests.first.uid}"));

                     return questionsProvider.when(
                       data: (allQuestions) {
                         return Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(20.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   ElevatedButton(
                                     style: ElevatedButton.styleFrom(
                                         foregroundColor: Colors.white, backgroundColor: Constants.kPrimaryColor,
                                         shape: const CircleBorder(),
                                         padding: const EdgeInsets.all(17.5)
                                     ),
                                     onPressed: () => Navigator.pop(context),
                                     child: Center(child: Icon(Icons.arrow_back_ios_new, size: 15.w, color: Colors.white),),
                                   ),
                                   Text("Test Et ${tests.first.title!}", style: Constants.kTitleTextStyle),
                                   Container(
                                     width: 45.w, height: 50.h,
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       color: Constants.kThirdColor,
                                     ),
                                     child: Center(
                                       child: Text(contents.first.level!,
                                         style: Constants.kTitleTextStyle.
                                         copyWith(color: Colors.white),),
                                     ),
                                   ),

                                 ],
                               ),
                             ),
                             allQuestions[testState.activeQuestionIndex].type != "word_match" ?
                             CommonQuestionView(question: allQuestions[testState.activeQuestionIndex].question!,
                               userModel: user, questionModel: allQuestions[testState.activeQuestionIndex],)
                                 : Text(allQuestions[testState.activeQuestionIndex].type.toString()),
                             Padding(
                               padding: EdgeInsets.all(20),
                               child: Container(
                                 width: width, height: 55.h,
                                 decoration: BoxDecoration(
                                     color: Constants.kSecondColor,
                                     borderRadius: BorderRadius.circular(25)
                                 ),
                                 child: ClipRRect(
                                   borderRadius: BorderRadius.circular(25),
                                   child: MaterialButton(
                                     onPressed: () {
                                       if(testState.activeQuestionIndex+1 < allQuestions.length) {
                                         testWatch.changeActiveQuestion(testState.activeQuestionIndex+1);
                                         testWatch.changeIsAnswered(value: false);
                                       }
                                       else if(testState.activeQuestionIndex+1 == allQuestions.length) {
                                         userWatch.addInUserTests(user, tests.first.uid!);
                                         testWatch.changeActiveQuestion(0);
                                         testWatch.changeIsAnswered(value: false);
                                       }
                                       else {
                                         testWatch.changeActiveQuestion(0);
                                         testWatch.changeIsAnswered(value: false);
                                       }
                                     },
                                     color: Constants.kSecondColor,
                                     child: Center(
                                       child: Text(testState.isAnswered ? "Devam Et" : "Pas Geç", style: Constants.kTitleTextStyle.copyWith(
                                           color: Colors.white
                                       ),),
                                     ),
                                   ),
                                 ),
                               ),
                             ),
                           ],
                         );
                       },
                       error: (error, stackTrace) => const AppErrorWidget(),
                       loading: () => const LoadingWidget(),
                     );
                   }

                   catch(E) {
                     return NoMoreTestWidget();
                   }
                  },
                  error: (error, stackTrace) => const AppErrorWidget(),
                  loading: () => const LoadingWidget(),
                );
              },
              error: (error, stackTrace) => const AppErrorWidget(),
              loading: () => const LoadingWidget(),
            ),
            loading: () => const LoadingWidget(),
            error: (error, stackTrace) => const AppErrorWidget(),
          ),
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => const AppErrorWidget(),
        )
      ),
    );
  }
}
