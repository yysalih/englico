import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/money_controller.dart';
import 'package:englico/utils/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../repository/user_repository.dart';
import '../../utils/contants.dart';
import '../../widgets/status_widgets.dart';

class EarnMoneyView extends ConsumerWidget {
  EarnMoneyView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    double width = MediaQuery.of(context).size.width;

    final moneyWatch = ref.watch(moneyController.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: user.when(
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => const AppErrorWidget(),
          data: (user) => Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 10, right: 10, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Constants.kPrimaryColor,
                            backgroundColor: Constants.kPrimaryColor,
                            padding: const EdgeInsets.all(10),
                            shape: const CircleBorder()
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                      ),
                      SizedBox(width: 10.w,),
                      const Text("Para Kazanma", style: Constants.kTitleTextStyle,),
                    ],
                  ),

                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(user.image!),
                        radius: 50.w,
                        backgroundColor: Constants.kFourthColor,
                      ),
                      SizedBox(width: 10.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hesapta Biriken Para:", style: Constants.kTitleTextStyle),
                          SizedBox(height: 5.h,),
                          Text("${user.money!.toStringAsFixed(1)} TL", style: Constants.kTextStyle.copyWith(
                              fontSize: 18.w
                          ),)
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      TextFormField(
                        validator: (value) => AppValidators.moneyValidator(value),
                        controller: moneyWatch.nameController,
                        decoration: InputDecoration(
                          hintText: "Ad-Soyad Giriniz"
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      TextFormField(
                        validator: (value) => AppValidators.moneyValidator(value),
                        controller: moneyWatch.ibanController,
                        decoration: InputDecoration(

                          hintText: "IBAN Giriniz"
                        ),
                      ),
                    ],
                  ),
                  Text("Talep ettiğiniz bakiye adminler tarafından incelenip hesabınıza yatırılacak.",
                    style: Constants.kTextStyle,),

                  Text("Davet ettiğiniz kullanıcı kadar para kazanırsınız.",
                    style: Constants.kTextStyle.copyWith(
                      color: Constants.kSecondColor
                    ),),
                  Container(
                    width: width, height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Constants.kPrimaryColor,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: MaterialButton(
                        onPressed: () async {
                          if (_formKey.currentState == null) return;
                          if (!_formKey.currentState!.validate()) return;
                          if(user.money! >= 100) {
                            await moneyWatch.sendRequest(user);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("İstek gönderildi.",
                                style: Constants.kTextStyle.copyWith(
                                    color: Colors.white
                                ),),
                            ));
                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("100 TL üzeri bakiyelerde istek gönderilebilir.",
                                style: Constants.kTextStyle.copyWith(
                                  color: Colors.white
                                ),),
                            ));
                          }
                        },
                        child: Center(
                          child: Text("İstek Gönder", style: Constants.kTextStyle.copyWith(
                            color: Colors.white
                          ),),
                        ),
                      ),
                    ),
                  ),
                ],

              ),
            ),
          ),
        ),
      ),
    );
  }
}
