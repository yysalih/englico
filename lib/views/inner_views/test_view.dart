import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/test_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/models/question_models/word_match_model.dart';
import 'package:englico/repository/content_repository.dart';
import 'package:englico/repository/question_repository.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/test_repository.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/views/info_views/show_progress_view.dart';
import 'package:englico/views/main_view.dart';
import 'package:englico/views/question_views/common_question_view.dart';
import 'package:englico/views/question_views/word_match_view.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../controllers/ad_controller.dart';
import '../../utils/contants.dart';

class TestView extends ConsumerStatefulWidget {
  const TestView({super.key});

  @override
  ConsumerState<TestView> createState() => _TestViewState();
}

class _TestViewState extends ConsumerState<TestView> {

  List? shuffledKeys;
  List? shuffledValues;
  bool shuffled = false;

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
    final testState = ref.watch(testController);
    final testWatch = ref.watch(testController.notifier);

    final mainWatch = ref.watch(mainController.notifier);
    final adWatch = ref.watch(adController.notifier);

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
                try {
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
                          if(allQuestions[testState.activeQuestionIndex].type == "word_match" && !shuffled) {
                            shuffledKeys = (allQuestions[testState.activeQuestionIndex]
                                .question!["words"] as Map).keys.toList()..shuffle();
                            shuffledValues = (allQuestions[testState.activeQuestionIndex]
                                .question!["words"] as Map).values.toList()..shuffle();

                            shuffled = true;
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white, backgroundColor: Constants.kPrimaryColor,
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(17.5)
                                      ),
                                      onPressed: () async => await showDialog(context: context,
                                        builder: (context) => CustomAlertDialog(image: "information",
                                          title: "Test bölümünden çıkmak istediğine emin misin?",
                                          description: "Kaydedilmeyen ilerleme kaybolabilir!",
                                          onPressed: () {
                                            testWatch.changeIsAnswered(value: false);
                                            testWatch.changeActiveQuestion(0);
                                            if(!user.isUserPremium) {
                                              adWatch.showInterstitialAd();
                                            }
                                            Navigator.pushAndRemoveUntil(context,
                                              mainWatch.routeToSignInScreen(const ShowProgressView()), (route) => false,);

                                          },),),
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
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Align(
                                  alignment: AlignmentDirectional.centerEnd,
                                  child: Image.asset("assets/icons/"
                                      "${allQuestions[testState
                                      .activeQuestionIndex].type}.png", width: 40.w,),
                                ),
                              ),
                              allQuestions[testState.activeQuestionIndex].type != "word_match" ?
                              CommonQuestionView(question: allQuestions[testState.activeQuestionIndex].question!,
                                userModel: user, questionModel: allQuestions[testState.activeQuestionIndex],)
                                  :
                              WordMatchView(
                                wordMatchModel: WordMatchModel(
                                  type: "word_match",
                                  shuffledWords: {
                                    for (int i = 0; i < shuffledKeys!.length; i++)
                                      shuffledKeys![i]: shuffledValues![i]
                                  },
                                  words: allQuestions[testState.activeQuestionIndex].question!["words"]
                                ),
                                allQuestions: allQuestions,
                                contents: contents,
                                tests: tests,
                                user: user,
                              ),
                              //Text(allQuestions[testState.activeQuestionIndex].type.toString()),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  width: width, height: 55.h,
                                  decoration: BoxDecoration(
                                      color: Constants.kSecondColor,
                                      borderRadius: BorderRadius.circular(50)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: MaterialButton(
                                      onPressed: () {

                                        shuffled = false;

                                        testWatch.continueButton(
                                          allQuestions: allQuestions,
                                          contents: contents,
                                          tests: tests,
                                          user: user,
                                          userWatch: userWatch
                                        );
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

                    },
                    error: (error, stackTrace) => const AppErrorWidget(),
                    loading: () => const LoadingWidget(),
                  );
                }

                catch(E) {
                  return NoMoreTestWidget(
                    level: level!,
                    onPressed: () => Navigator.pushAndRemoveUntil(context,
                      mainWatch.routeToSignInScreen(const MainView()), (route) => false),);
                }
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
