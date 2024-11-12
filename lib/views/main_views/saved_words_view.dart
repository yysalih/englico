import 'package:englico/repository/word_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/main_controller.dart';
import '../../controllers/user_controller.dart';
import '../../main.dart';
import '../../repository/user_repository.dart';
import '../../utils/contants.dart';
import '../../widgets/status_widgets.dart';
import '../main_view.dart';

class SavedWordsView extends ConsumerWidget {
  const SavedWordsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    final words = ref.watch(wordsStreamProvider);
    final userWatch = ref.watch(userController.notifier);

    return user.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => const AppErrorWidget(),
      data: (user) => words.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => const AppErrorWidget(),
        data: (allWords) {
          final words = allWords.where((element) => user.savedWords!.contains(element.uid!)).toList();
          return Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Kelimelerim", style: Constants.kTitleTextStyle.copyWith(
                        fontSize: 25
                    ),),
                    GestureDetector(
                      onTap: () {
                        mainWatch.setLanguageLevel("");
                        Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(MyApp()), (route) => false);
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
                const SizedBox(height: 10,),

                words.isEmpty ? Padding(
                  padding: EdgeInsets.only(top: 150.h),
                  child: const NoPracticeWidget(
                    text: "Herhangi bir kelime kaydetmediniz.",
                  ),
                ) :
                Expanded(
                  child: GridView.builder(
                    itemCount: words.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        debugPrint(words.length.toString());
                        debugPrint(user.savedWords!.length.toString());
                      },
                      child: Container(
                        width: 100.w, height: 100.h,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [

                                  Constants.kPrimaryColor.withOpacity(.5),
                                  Constants.kFourthColor.withOpacity(.5),
                                  Constants.kFourthColor.withOpacity(.2),
                                  Constants.kThirdColor.withOpacity(.1),
                                ],
                                begin: Alignment.topLeft, end: Alignment.bottomRight
                            ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Container(),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                              child: Text(words[index].english!, style: Constants.kTextStyle.copyWith(
                                fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold
                              ), maxLines: 3),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(words[index].level!, style: Constants.kTextStyle.copyWith(
                                    fontWeight: FontWeight.bold, color: Constants.kBlackColor, fontSize: 20
                                  ),),
                                  IconButton(
                                    onPressed: () => userWatch.addInUserSavedWords(user, words[index].uid!),
                                    icon: Icon(user.savedWords!.contains(words[index].uid!) ?
                                    Icons.bookmark_added
                                        :
                                    Icons.bookmark_add, color: Constants.kPrimaryColor,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20, childAspectRatio: 1
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
    );
  }
}
