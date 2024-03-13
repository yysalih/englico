import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/user_controller.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/widgets/auth_text_field.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileView extends ConsumerWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    final userWatch = ref.watch(userController.notifier);
    final userState = ref.watch(userController);

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: user.when(
          data: (user) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0,left: 10),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Constants.kPrimaryColor,
                      backgroundColor: Constants.kPrimaryColor,
                      padding: const EdgeInsets.all(10),
                      shape: const CircleBorder()
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 110.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(userState.image),
                        radius: 50.w,
                        backgroundColor: Constants.kPrimaryColor,
                      ),
                      SizedBox(height: 5.h,),
                      TextButton(
                        onPressed: () => userWatch.showPicker(context),
                        child: Text("Profil Fotoğrafını Değiştir",),
                      ),
                      SizedBox(height: 10.h,),
                      AuthTextField(
                          isObscure: false,
                          hintText: "Ad - Soyad",
                          prefixIcon: Icons.person,
                          controller: userWatch.nameController..text = userState.name,
                          initialValue: user.name!,
                          onChanged: (p0) {
                            userWatch.changeName(p0!);
                          },
                          validator: null),
                      SizedBox(height: 10.h,),

                      AuthTextField(
                          isObscure: false,
                          hintText: "Kullanıcı Adı",
                          initialValue: user.username!,
                          prefixIcon: Icons.text_fields,
                          controller: userWatch.usernameController..text = userState.userName,
                          onChanged: (p0) {
                            userWatch.changeUsername(p0!);
                          },
                          validator: null),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: width, height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Constants.kPrimaryColor
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: MaterialButton(
                        onPressed: () {
                          userWatch.updateUser(user.uid!);
                          Navigator.pop(context);
                        },
                        color: Constants.kPrimaryColor,
                        child: Center(
                          child: Text("Kaydet", style: Constants.kTitleTextStyle.copyWith(
                            color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => const AppErrorWidget(),
        )
      ),
    );
  }
}
