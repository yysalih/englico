import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:englico/controllers/auth_controller.dart';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/services/authentication_service.dart';
import 'package:englico/utils/validators.dart';
import 'package:englico/views/main_view.dart';
import 'package:englico/views/reset_password_view.dart';
import 'package:englico/widgets/auth_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthView extends ConsumerWidget {
  AuthView({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authState = ref.watch(authController);
    final authWatch = ref.watch(authController.notifier);
    final mainWatch = ref.watch(mainController.notifier);

    return Scaffold(
      body: authState.isResetPassword ? ResetPasswordView()
          : Form(
        key: _formKey,

        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: height * .1,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [


                    ],
                  ),
                  SizedBox(height: height * .1,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        AuthTextField(
                          hintText: "Email",
                          isObscure: false,
                          prefixIcon: Icons.email,
                          controller: authWatch.emailController,
                          validator: AppValidators.emailValidator,
                        ),
                        const SizedBox(height: 20,),
                        AuthTextField(
                          hintText: "Şifre",
                          isObscure: true,
                          prefixIcon: Icons.lock,
                          validator: AppValidators.passwordValidator,
                          controller: authWatch.passwordController,
                        ),
                        const SizedBox(height: 20,),
                        authState.isRegister ? AuthTextField(
                          hintText: "Şifre Tekrar",
                          isObscure: true,
                          prefixIcon: Icons.lock,
                          controller: authWatch.passwordRepeatController,
                          validator: (p0) => AppValidators.confirmPasswordValidator(authWatch.passwordController.text, p0),
                        ) : Container(),
                        /*authState.isRegister ? Row(
                          children: [
                            Checkbox(
                              onChanged: (value) => authWatch.changeCheckBox(),
                              value: authState.hasInviteCode,
                            ),
                            Text("Davet Kodum Var"),
                          ],
                        ) : Container(),
                        authState.hasInviteCode && authState.isRegister ?
                        AuthTextField(
                          hintText: "Davet Kodu",
                          isObscure: false,
                          prefixIcon: Icons.star,
                          controller: authWatch.inviteCodeController,
                          validator: null,
                        ) : Container(),
                        ,*/
                        SizedBox(height: authState.isRegister ? 20 : 0,),
                        FutureBuilder(
                            future: Authentication.initializeFirebase(context: context, authWatch: authWatch),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  width: width, height: height * .05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),

                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        if (_formKey.currentState == null) return;
                                        if (!_formKey.currentState!.validate()) return;
                                        authWatch.handleEmailSignIn(context, mainWatch);


                                      },
                                      color: Constants.kPrimaryColor,
                                      child: Center(child: Text(authState.isRegister ? "Kayıt Ol" : "Giriş Yap",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: width, height: height * .05,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (_formKey.currentState == null) return;
                                      if (!_formKey.currentState!.validate()) return;
                                    },
                                    color: Constants.kPrimaryColor,
                                    child: const Center(child: CircularProgressIndicator(color: Colors.white),),
                                  ),
                                ),
                              );
                            }
                        ),
                        const SizedBox(height: 10,),
                        FutureBuilder(
                          future: Authentication.initializeFirebase(context: context, authWatch: authWatch),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return Container(
                              width: width, height: height * .05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [BoxShadow(color: Constants.kPrimaryColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1)]
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: MaterialButton(
                                  onPressed: () async {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    User? user = await Authentication.signInWithGoogle(context: context);

                                    if(user != null) {
                                      prefs.setString("uid", user.uid);

                                      bool isUserExists = await authWatch.checkIfUserExists(user);

                                      if(isUserExists) {
                                        Navigator.push(context,
                                            mainWatch.routeToSignInScreen(const MainView()));
                                      }
                                      else {
                                        await authWatch.createNewUser(user.uid, user);
                                        Navigator.push(context,
                                            mainWatch.routeToSignInScreen(const MainView()));
                                      }

                                    }
                                  },
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/icons/google.png", width: 22.5,),
                                      const SizedBox(width: 10,),
                                      const Text("Google ile Giriş Yap", style: TextStyle(
                                          fontWeight: FontWeight.bold
                                      ),)
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                            return Container(
                                width: width, height: height * .05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Constants.kPrimaryColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1)]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MaterialButton(
                                    onPressed: () async {

                                    },
                                    color: Colors.white,
                                    child: 1 != 1 ?
                                    Image.asset("assets/icons/google.png", width: 22.5,)
                                        :const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Constants.kPrimaryColor
                                      ),
                                    ),
                                  ),
                                ),
                              );
                          }
                        ),
                        const SizedBox(height: 10,),
                        //Platform.isIOS ?
                        FutureBuilder(
                            future: Authentication.initializeFirebase(context: context, authWatch: authWatch),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                return Container(
                                  width: width, height: height * .05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [BoxShadow(color: Constants.kPrimaryColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1)]
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: MaterialButton(
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        User? user = await Authentication.handleAppleSignIn(context: context);

                                        if(user != null) {
                                          prefs.setString("uid", user.uid);

                                          bool isUserExists = await authWatch.checkIfUserExists(user);

                                          if(isUserExists) {
                                            Navigator.push(context,
                                                mainWatch.routeToSignInScreen(const MainView()));
                                          }
                                          else {
                                            await authWatch.createNewUser(user.uid, user);
                                            Navigator.push(context,
                                                mainWatch.routeToSignInScreen(const MainView()));
                                          }

                                        }
                                      },
                                      color: Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/icons/apple.png", width: 22.5,),
                                          const SizedBox(width: 10,),
                                          const Text("Apple ile Giriş Yap", style: TextStyle(
                                            fontWeight: FontWeight.bold
                                          ),)
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container(
                                width: width, height: height * .05,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [BoxShadow(color: Constants.kPrimaryColor.withOpacity(.15), blurRadius: 1, spreadRadius: 1)]
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: MaterialButton(
                                    onPressed: () async {

                                    },
                                    color: Colors.white,
                                    child: 1 != 1 ?
                                    Image.asset("assets/icons/apple.png", width: 22.5,)
                                        :const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Constants.kPrimaryColor
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                        ),
                        //: Container(),
                        SizedBox(height: Platform.isIOS ? 10 : 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                debugPrint("invite code: ${authWatch.inviteCodeController.text}");
                                authWatch.switchRegister();
                              },
                              child: Text(authState.isRegister ? "Hesabım Var" : "Hesap Oluştur", style: const TextStyle(
                                fontSize: 13, color: Constants.kPrimaryColor, fontWeight: FontWeight.bold
                              )),
                            ),
                            GestureDetector(
                              onTap: () => authWatch.switchToResetPassword(),
                              child: const Text("Şifremi Unuttum", style: TextStyle(
                                fontSize: 13, color: Constants.kPrimaryColor, fontWeight: FontWeight.bold
                              )),
                            ),
                          ],
                        ),
                      ],
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