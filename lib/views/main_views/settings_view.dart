import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/settings_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/views/inner_views/earn_money_view.dart';
import 'package:englico/views/inner_views/edit_profile_view.dart';
import 'package:englico/views/inner_views/market_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';
import '../auth_view.dart';

class SettingsView extends ConsumerWidget {
  SettingsView({super.key});

  final Uri _url = Uri.parse('https://flutter.dev');


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final List<Color> colors = [
      Constants.kPrimaryColor,
      Constants.kSecondColor,
      Constants.kThirdColor,
      Constants.kFourthColor2,
      Constants.kFourthColor,
      Constants.kFifthColor,
      Constants.kSixthColor,
    ];

    final settingsWatch = ref.watch(settingsController.notifier);
    final userWatch = ref.watch(userController.notifier);
    final mainWatch = ref.watch(mainController.notifier);

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    return SingleChildScrollView(
      child: user.when(
        data: (user) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Constants.kSecondColor,
                    backgroundImage: CachedNetworkImageProvider(user.image!),
                    radius: 40.w,
                  ),
                  SizedBox(height: 10.h,),
                  Text(user.name!, style: Constants.kTitleTextStyle,),
                  SizedBox(height: 5.h,),
                  Text("@${user.username!}", style: Constants.kTitleTextStyle.copyWith(
                     color: Constants.kSecondColor
                  ),),
                  SizedBox(height: 5.h,),
                  Text("${user.point!} Puan", style: Constants.kTextStyle,),
                ],
              ),
            ),
            for(int i = 0; i < settingsWatch.settingsWidgets.length; i++)
              MaterialButton(
                onPressed: () async {
                  if(settingsWatch.settingsWidgets[i]["icon"] == "logout") {
                    await userWatch.logout(context);
                    Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(AuthView()), (route) => false);
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "language") {
                    mainWatch.setLanguageLevel("");
                    Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(MyApp()), (route) => false);
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "subscription") {
                    Navigator.push(context, mainWatch.routeToSignInScreen(const MarketView()),);
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "money") {
                    Navigator.push(context, mainWatch.routeToSignInScreen(EarnMoneyView()),);
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "user") {
                    userWatch.setFields(user);
                    Navigator.push(context, mainWatch.routeToSignInScreen(const EditProfileView()));
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "star") {
                    settingsWatch.onShareXFileFromAssets(context, user.uid!);
                  }

                  else if(settingsWatch.settingsWidgets[i]["icon"] == "trash") {
                    userWatch.deleteAccount(context);
                    Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(AuthView()), (route) => false);

                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: colors.reversed.toList()[i],
                            radius: 30,
                            child: Image.asset("assets/ui/${settingsWatch.settingsWidgets[i]["icon"]}.png",
                              width: 22.w, color: Colors.white,),

                          ),
                          SizedBox(width: 10.w,),
                          Text(settingsWatch.settingsWidgets[i]["title"], style: Constants.kTextStyle,),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios, size: 15.w, color: Constants.kPrimaryColor,)
                    ],
                  ),
                ),
              )
          ],
        ),
        error: (error, stackTrace) => const AppErrorWidget(),
        loading: () => const Center(child: LoadingWidget()),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
