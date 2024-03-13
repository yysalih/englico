import 'package:cached_network_image/cached_network_image.dart';
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

// ignore: must_be_immutable
class BestUsersView extends ConsumerStatefulWidget {
  BestUsersView({super.key});

  @override
  ConsumerState<BestUsersView> createState() => _BestUsersViewState();
}

class _BestUsersViewState extends ConsumerState<BestUsersView> {
  List tabs = [
    {"id" : "annuallyPoint", "title" : "Yıllık"},
    {"id" : "monthlyPoint", "title" : "Aylık"},
    {"id" : "weeklyPoint", "title" : "Haftalık"},
    {"id" : "point", "title" : "Tümü"},
  ];

  @override
  void initState() {
    final mainRead = ref.read(mainController.notifier);
    mainRead.checkPointsCategory();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    final languageLevel = ref.watch(languageLevelProvider);
    final userWatch = ref.watch(userController.notifier);


    final users = ref.watch(usersStreamProvider(mainState.selectedTab));

    return user.when(
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => const AppErrorWidget(),
      data: (user) => languageLevel.when(
        loading: () => const LoadingWidget(),
        error: (error, stackTrace) => const AppErrorWidget(),

        data: (language) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Text("Liderlik Tabloları", style: Constants.kTitleTextStyle.copyWith(
                      fontSize: 25
                  ),),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for(int i = 0; i < tabs.length; i++)
                      Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [BoxShadow(
                                color: Constants.kSecondColor.withOpacity(.2),
                                blurRadius: 1, spreadRadius: 1
                            )]
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: MaterialButton(
                            color: mainState.selectedTab == tabs[i]["id"]
                                ? Constants.kPrimaryColor : Colors.white,
                            onPressed: () {
                              mainWatch.changeSelectedTab(tabs[i]["id"]);
                            },
                            child: Center(child: Text(tabs[i]["title"], style: Constants.kTextStyle.copyWith(
                                color: mainState.selectedTab == tabs[i]["id"] ? Colors.white : Colors.black,
                                fontSize: 15
                            ),),),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h,),
            users.when(
              data: (users) => Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: 20.h, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Constants.kPrimaryColor.withOpacity(.1),
                                spreadRadius: 1, blurRadius: 1
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25.w,
                                  backgroundColor: Constants.kPrimaryColor,
                                  backgroundImage: CachedNetworkImageProvider(users[index].image!),
                                ),
                                SizedBox(width: 10.w,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(users[index].username!, style: Constants.kTitleTextStyle.copyWith(
                                        fontSize: 17.5.w
                                    ),),
                                    Text("${users[index].point!.toString()} Puan",
                                      style: Constants.kTextStyle.copyWith(
                                          fontSize: 15.w, color: Colors.black87
                                      ),),
                                  ],
                                )
                              ],
                            ),
                            CircleAvatar(
                              radius: 15.w,
                              backgroundColor: Constants.kFifthColor,
                              child: Center(
                                child: Text("${index+1}", style: Constants.kTitleTextStyle.copyWith(
                                    color: Colors.white
                                ),),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  itemCount: users.length,
                  scrollDirection: Axis.vertical,
                ),
              ),
              loading: () => const LoadingWidget(),
              error: (error, stackTrace) => const AppErrorWidget(),
            ),

          ],
        ),
      )
    );
  }
}
