import 'package:englico/controllers/test_controller.dart';
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
                    final tests = allTests.where((element) =>
                    !user.tests!.contains(element.uid)).toList();

                    final questionsProvider = ref.watch(questionsStreamProvider(
                        "${contents.first.uid}englico${tests.first.uid}"));

                    return questionsProvider.when(
                      data: (allQuestions) {
                        print(allQuestions.first.uid);
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
                                  const Text("Test Et", style: Constants.kTitleTextStyle),
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
                            allQuestions.first.type != "word_match" ?
                                CommonQuestionView(question: allQuestions.first.question!,)
                                : Container(),
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

                                    },
                                    child: Center(
                                      child: Text("Pas Geç", style: Constants.kTitleTextStyle.copyWith(
                                        color: Colors.white
                                      ),),
                                    ),
                                    color: Constants.kSecondColor,
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
