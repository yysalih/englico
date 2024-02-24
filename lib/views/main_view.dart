import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_animation/weather_animation.dart';
import '../controllers/main_controller.dart';
import '../utils/contants.dart';
import '../widgets/app_navigation_bar.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [
                      Constants.kFifthColor.withOpacity(.7),
                      Constants.kSixthColor.withOpacity(.1),
                      Constants.kSixthColor.withOpacity(.2),
                      Constants.kSixthColor.withOpacity(.2),
                      Constants.kSixthColor.withOpacity(.2),
                      Constants.kSixthColor.withOpacity(.1),
                      Constants.kFifthColor.withOpacity(.7),

                    ]
                  )
                ),
              ),
              mainWatch.pages[mainState.bottomIndex],
            ],
          )
      ),
      bottomNavigationBar: AppBottomBar(),
    );
  }
}
