import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/utils/contants.dart';
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
                SizedBox(height: 15.h,),

                Center(
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.image!),
                    radius: 40.w,
                    backgroundColor: Constants.kSixthColor,
                  ),
                ),
                SizedBox(height: 5.h,),
                Center(child: Text("${user.point.toString()} Puan",
                  style: Constants.kTitleTextStyle,))
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

                        title: "Öğren", icon: "learn"),

                    HomeViewWidget(
                        title: "Test Et", icon: "multiple_choice"),
                  ],
                ),
                SizedBox(height: 20.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HomeViewWidget(

                        title: "Tekrar Et", icon: "practice"),
                    HomeViewWidget(
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
