import 'package:englico/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/contants.dart';

class LanguageLevelView extends ConsumerWidget {
  final bool fromSettings;
  const LanguageLevelView({super.key, this.fromSettings = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.h,),
          Text("Senin için uygun olan bir dil seviyesi seç", textAlign: TextAlign.start,
            style: Constants.kTitleTextStyle.copyWith(color: Colors.black),),
          SizedBox(height: 20.h,),
          for(int i = 0; i < mainWatch.languageLevels.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
              child: Container(
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Constants.kFifthColor.withOpacity(.2),
                      Constants.kFifthColor.withOpacity(.1), Constants.kFifthColor.withOpacity(.0),]
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: mainState.languageLevel == mainWatch.languageLevels[i]["level"] ?
                  Constants.kFifthColor : Constants.kFifthColor.withOpacity(.5),
                      width: mainState.languageLevel == mainWatch.languageLevels[i]["level"] ? 2 : 1)
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: () => mainWatch.setLanguageLevel(mainWatch.languageLevels[i]["level"]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mainWatch.languageLevels[i]["title"],
                                style: Constants.kTitleTextStyle.copyWith(color: Colors.black),),
                              Checkbox(

                                shape: const CircleBorder(),
                                value: mainState.languageLevel == mainWatch.languageLevels[i]["level"],
                                onChanged: (value) => mainWatch.setLanguageLevel(mainWatch.languageLevels[i]["level"]),
                              )
                            ],
                          ),
                          SizedBox(height: 10.h,),
                          Text(mainWatch.languageLevels[i]["description"],
                            style: Constants.kTextStyle,),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          SizedBox(height: 20.h,),

        ],
      ),
    );
  }
}
