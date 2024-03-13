import 'package:englico/repository/saying_repository.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/word_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/main_controller.dart';
import '../../controllers/user_controller.dart';
import '../../repository/user_repository.dart';
import '../../utils/contants.dart';
import '../../widgets/status_widgets.dart';
import '../main_view.dart';

class SayingsView extends ConsumerWidget {
  const SayingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    double width = MediaQuery.of(context).size.width;

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    final sayings = ref.watch(sayingsStreamProvider);
    final languageLevel = ref.watch(languageLevelProvider);
    final userWatch = ref.watch(userController.notifier);

    return user.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => const AppErrorWidget(),
      data: (user) => languageLevel.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => const AppErrorWidget(),

        data: (language) =>  sayings.when(
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => const AppErrorWidget(),

          data: (allSayings) {
            final saying = allSayings.where((element) => element.level! == language!).toList();
            return Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Deyimler", style: Constants.kTitleTextStyle.copyWith(
                          fontSize: 25
                      ),),

                      GestureDetector(
                        onTap: () {
                          mainWatch.setLanguageLevel("");
                          Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(const MainView()), (route) => false);
                        },
                        child: Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Constants.kPrimaryColor,
                          ),
                          child: Center(
                            child: Text(mainState.languageLevel,
                              style: Constants.kTitleTextStyle.
                              copyWith(color: Colors.white),),
                          ),
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 20,),

                  saying.isEmpty ? Padding(
                    padding: EdgeInsets.only(top: 150.h),
                    child: const NoPracticeWidget(
                      text: "Herhangi bir kelime kaydetmediniz.",
                    ),
                  ) :
                  Expanded(
                    child: ListView.builder(
                      itemCount: saying.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            debugPrint(saying.length.toString());
                            debugPrint(user.savedWords!.length.toString());
                          },
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [

                                      Constants.kThirdColor.withOpacity(.5),
                                      Constants.kThirdColor.withOpacity(.4),
                                      Constants.kThirdColor.withOpacity(.3),
                                      Constants.kThirdColor.withOpacity(.2),
                                    ],
                                    begin: Alignment.topLeft, end: Alignment.bottomRight
                                ),
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, right: 10,),
                                    child: Text(saying[index].saying!, style: Constants.kTextStyle.copyWith(
                                        fontSize: 17.5, color: Colors.white,
                                    ), maxLines: 3, textAlign: TextAlign.start,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0, top: 5),
                                    child: Text(saying[index].level!, style: Constants.kTextStyle.copyWith(
                                        fontWeight: FontWeight.bold, color: Constants.kBlackColor, fontSize: 20
                                    ),),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      )
    );
  }
}
