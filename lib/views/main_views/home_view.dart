import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/test_controller.dart';
import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/views/inner_views/learn_view.dart';
import 'package:englico/views/inner_views/practiceview.dart';
import 'package:englico/views/inner_views/speak_view.dart';
import 'package:englico/views/inner_views/test_view.dart';
import 'package:englico/widgets/home_view_widget.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final mainWatch = ref.watch(mainController.notifier);
    final testWatch = ref.watch(testController.notifier);

    final languageLevel = ref.watch(languageLevelProvider);

    return user.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => const AppErrorWidget(),
      data: (user) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: "Hoşgeldin\n", style: Constants.kTitleTextStyle.copyWith(
                            fontSize: 50.w, color: Constants.kSecondColor,)),
                          TextSpan(text: user.name!, style: Constants.kTextStyle.copyWith(
                            fontSize: 20.w, color: Colors.black
                          ))
                        ],
                      ),
                    ),
                    languageLevel.when(
                      data: (level) => Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constants.kPrimaryColor,
                        ),
                        child: Center(
                          child: Text(level!,
                            style: Constants.kTitleTextStyle.
                            copyWith(color: Colors.white),),
                        ),
                      ),
                      error: (error, stackTrace) => Container(),
                      loading: () => Container(),

                    ),

                  ],
                ),
                SizedBox(height: 10.h,),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(user.image!),
                        radius: 30.w,
                        backgroundColor: Constants.kSixthColor,
                      ),
                      SizedBox(height: 5.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset("assets/icons/star.png", width: 25.w,),
                          SizedBox(width: 5.w, ),
                          Text("${user.point!} Puan", style: Constants.kTextStyle,)
                        ],
                      ),



                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeViewWidget(
                      onPressed: () => Navigator.push(context, mainWatch.routeToSignInScreen(LearnView())),
                        title: "Öğren", icon: "learn"),

                    HomeViewWidget(
                        onPressed: () {
                          testWatch.changePoint(value: 0);
                          Navigator.push(context, mainWatch.routeToSignInScreen(const TestView()));
                        },

                        title: "Test Et", icon: "multiple_choice"),
                  ],
                ),
                SizedBox(height: 20.h,),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeViewWidget(
                        onPressed: () => Navigator.push(context, mainWatch.routeToSignInScreen(PracticeView())),

                        title: "Tekrar Et", icon: "practice"),
                    HomeViewWidget(
                        onPressed: () => Navigator.push(context, mainWatch.routeToSignInScreen(SpeakView())),

                        title: "Konuş", icon: "speak"),


                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
