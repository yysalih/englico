import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../controllers/auth_controller.dart';

class AuthTextField extends ConsumerWidget {
  final bool isObscure;
  final String hintText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthTextField({
    super.key,
    required this.isObscure,
    required this.hintText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final authState = ref.watch(authController);
    final authWatch = ref.watch(authController.notifier);

    return Container(
      width: width, height: height * .07,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Constants.kSecondColor, width: 1.25),
        borderRadius: BorderRadius.circular(15),

      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        validator: validator,
        obscureText: isObscure ? authState.isObscure : false,
        controller: controller,
        decoration: Constants.kInputDecorationWithNoBorder.copyWith(
          prefixIcon: Icon(prefixIcon),
          hintText: hintText,
          suffixIcon: !isObscure ? null : IconButton(
            icon: Icon(Icons.remove_red_eye_rounded),
            onPressed: () {
              authWatch.obscureChange();
            },
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
