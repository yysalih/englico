import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../controllers/main_controller.dart';

class AppBottomBar extends ConsumerWidget {
  const AppBottomBar({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    return BottomNavigationBar(

      currentIndex: mainState.bottomIndex,
      onTap: (value) => mainWatch.changePage(value),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      unselectedItemColor: Constants.kSecondColor,
      selectedItemColor: Constants.kSecondColor,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        for(int i = 0; i < mainWatch.pageInfo.length; i++)
          BottomNavigationBarItem(
            icon: Image.asset("assets/ui/${mainWatch.pageInfo[i]["icon"]}.png",
              width: 20.w,
              color: Constants.kPrimaryColor,
            ),
            label: mainWatch.pageInfo[i]["label"],

          ),
      ],

      selectedLabelStyle: const TextStyle(color: Colors.black),
    );
  }
}