// ignore_for_file: must_be_immutable

import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../utils/validators.dart';
import '../widgets/auth_text_field.dart';


class ResetPasswordView extends ConsumerWidget {
  ResetPasswordView({super.key});

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authWatch = ref.watch(authController.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: IconButton(
                    onPressed: () => authWatch.switchToResetPassword(),
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
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
                        controller: authWatch.resetPasswordController,
                        validator: AppValidators.emailValidator,
                      ),
                      SizedBox(height: 10,),
                      Container(
                        width: width, height: height * .055,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),

                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            onPressed: () async {
                              if(authWatch.resetPasswordController.text.isNotEmpty) {
                                await authWatch.resetPassword(context);

                              }
                            },
                            child: Center(child: Text("Gönder", style: TextStyle(color: Colors.white,),)),
                            color: Constants.kThirdColor,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
