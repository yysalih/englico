import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/contants.dart';

class HomeViewWidget extends StatelessWidget {
  final String title;
  final String icon;

  const HomeViewWidget({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w, height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
            colors: [

              Constants.kSixthColor.withOpacity(.5),
              Constants.kFifthColor.withOpacity(.5),
              Constants.kSixthColor.withOpacity(.1),
            ],
          begin: Alignment.topLeft, end: Alignment.bottomRight
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: () {

          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/icons/$icon.png", width: 60.w,),
              SizedBox(height: 10.h,),
              Text(title, style: Constants.kTitleTextStyle
                  .copyWith(color: Colors.black87,),)
            ],
          )
        ),
      ),
    );
  }
}