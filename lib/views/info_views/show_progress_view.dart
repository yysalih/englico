import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/test_controller.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowProgressView extends ConsumerWidget {
  const ShowProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testWatch = ref.watch(testController.notifier);
    final testState = ref.watch(testController);

    final mainWatch = ref.watch(mainController.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Tebrikler!", style: Constants.kTitleTextStyle.copyWith(
                fontSize: 30.w
            ),),
            SizedBox(height: 10.h,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/practice.png", width: 35.w,),
                SizedBox(width: 5.w,),
                Text("${testState.point} puan kazandınız!", style: Constants.kTextStyle.copyWith(
                  fontSize: 20.w
                ),)
              ],
            ),
            SizedBox(height: 10.h,),
            Image.asset("assets/icons/done2.png", width: 150.w,),
            SizedBox(height: 50.h,),
            Container(
              width: 300.w, height: 50.w,
              decoration: BoxDecoration(
                color: Constants.kPrimaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: MaterialButton(
                  color: Constants.kPrimaryColor,
                  child: Center(
                    child: Text("Ana Sayfaya Dön", style: Constants.kTitleTextStyle.copyWith(
                      color: Colors.white
                    ), textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    testWatch.changePoint(value: 0);
                    Navigator.pushAndRemoveUntil(context, mainWatch.routeToSignInScreen(MainView()),
                            (route) => false);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
