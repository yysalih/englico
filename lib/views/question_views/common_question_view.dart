import 'package:englico/utils/contants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonQuestionView extends StatelessWidget {
  final Map<String, dynamic> question;
  const CommonQuestionView({super.key,
    required this.question});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question["type"] == "complete_sentence" ? question["uncompleted_sentence"]
              : question["question_text"],
            style: Constants.kTitleTextStyle.copyWith(color: Colors.black),),
          SizedBox(height: 10.h),
          for(int i = 0; i < (question["answers"] as List).length; i++)
            Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Container(
                width: width, height: 55.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 1, spreadRadius: 1)]
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: MaterialButton(
                    onPressed: () {

                    },
                    child: Center(
                      child: Text(question["answers"][i], style: Constants.kTitleTextStyle.copyWith(
                          color: Colors.black
                      ),),
                    ),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
