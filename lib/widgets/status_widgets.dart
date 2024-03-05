import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/contants.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/warning.png", width: 100.w,),
          SizedBox(height: 10.h,),
          const Text("Yükleme sırasında bir hata oluştu. Lütfen sayfayı yenileyiniz.",
            style: Constants.kTextStyle,)
        ],
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator(),),
          SizedBox(height: 10.h,),
          const Text("Yükleniyor...",
            style: Constants.kTextStyle,)
        ],
      ),
    );
  }
}

class NotFoundWidget extends StatelessWidget {
  const NotFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/gifs/notfound.gif", width: 200.w,),
          SizedBox(height: 10.h,),
          const Text("Herhangi bir öge bulunamadı...",
            style: Constants.kTextStyle,)
        ],
      ),
    );
  }
}

class NoMoreWidget extends StatelessWidget {
  const NoMoreWidget({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/done2.png", width: 150.w,),
          SizedBox(height: 20.h,),
          Text("Bu seviyedeki bütün kelimeleri tamamladın.\nTebrikler!",
            style: Constants.kTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 25.w,
            ), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}

class NoPracticeWidget extends StatelessWidget {
  final String text;
  const NoPracticeWidget({super.key, this.text = "Yeni kelimeler öğrendikten sonra burada tekrar yapabilirsin."});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/empty.png", width: 150.w,),
          SizedBox(height: 20.h,),
          Text(text,
            style: Constants.kTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 20.w,
            ), textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}

class NoMoreTestWidget extends StatelessWidget {
  final Function() onPressed;
  final String level;

  const NoMoreTestWidget({super.key, required this.onPressed, required this.level});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/done2.png", width: 150.w,),
          SizedBox(height: 20.h,),
          Text("$level seviyesindeki bütün bölümleri tamamladın.\nTebrikler!",
            style: Constants.kTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 25.w,
            ), textAlign: TextAlign.center,),
          SizedBox(height: 20.h,),
          TextButton(
            onPressed: onPressed,
            child: const Text("Ana Sayfaya Dön", style: Constants.kTextStyle,),
          )
        ],
      ),
    );
  }
}

class CustomAlertDialog extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final Function() onPressed;
  const CustomAlertDialog({super.key, required this.image, required this.title,
    required this.description, required this.onPressed});


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //SizedBox(height: 20.h,),
          Text(description, style: Constants.kTextStyle,textAlign: TextAlign.center),
          SizedBox(height: 20.h,),
          Image.asset("assets/icons/$image.png", width: 100.w,),
         // SizedBox(height: 20.h,),
        ],
      ),
      actions: [
        TextButton(
          child: const Text("Hayır", style: Constants.kTextStyle,),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          onPressed: onPressed,
          child: const Text("Evet", style: Constants.kTextStyle,),
        )
      ],
    );
  }
}
