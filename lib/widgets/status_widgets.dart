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
          Text("Yükleme sırasında bir hata oluştu. Lütfen sayfayı yenileyiniz.",
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
          Image.asset("assets/gifs/loading.gif", width: 100.w,),
          SizedBox(height: 10.h,),
          Text("Yükleniyor...",
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
          Text("Herhangi bir öge bulunamadı...",
            style: Constants.kTextStyle,)
        ],
      ),
    );
  }
}
