import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * .385, height: height * .15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Center(
          child: Icon(icon,
              size: 30.w,
              color: iconColor),
        ),
      ),
    );
  }
}
