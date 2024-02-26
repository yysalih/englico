import 'package:englico/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/user_controller.dart';
import '../utils/contants.dart';

class CustomButton extends ConsumerWidget {
  final Function() onTap;
  final Color color;
  final IconData icon;
  final Color iconColor;
  const CustomButton({super.key,
    required this.onTap,
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final userRead = ref.read(userController.notifier);


    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * .4, height: height * .15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Center(
          child: Icon(icon,
              size: 35,
              color: iconColor),
        ),
      ),
    );
  }
}
