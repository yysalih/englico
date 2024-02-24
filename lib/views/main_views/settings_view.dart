import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/settings_controller.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../auth_view.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

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
                  Text(user.email!, style: Constants.kTextStyle,),
                ],
              ),
            ),
            for(int i = 0; i < settingsWatch.settingsWidgets.length; i++)
              MaterialButton(
                onPressed: () async {
                  await userWatch.logout(context);
                  Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(AuthView()), (route) => false);

                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Constants.kPrimaryColor,
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
        error: (error, stackTrace) => AppErrorWidget(),
        loading: () => Center(child: LoadingWidget()),
      ),
    );
  }
}
