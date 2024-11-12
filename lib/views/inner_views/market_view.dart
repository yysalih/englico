import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:englico/controllers/market_controller.dart';
import 'package:englico/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../utils/contants.dart';
import '../../widgets/status_widgets.dart';

class MarketView extends ConsumerStatefulWidget {
  const MarketView({super.key});

  @override
  ConsumerState<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends ConsumerState<MarketView> {

  late CustomerInfo customerInfo;

  @override
  void initState() {
    init();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    final user = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    double width = MediaQuery.of(context).size.width;

    final marketWatch = ref.watch(marketController.notifier);

    return Scaffold(
      body: SafeArea(
        child: user.when(
          loading: () => const LoadingWidget(),
          error: (error, stackTrace) => const AppErrorWidget(),
          data: (user) => SingleChildScrollView(
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
                      const Text("Abonelikler", style: Constants.kTitleTextStyle,),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Abonelik Durumu", style: Constants.kTitleTextStyle.copyWith(
                        fontSize: 22.5.w
                      ),),
                      SizedBox(height: 10.h,),
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
                              Row(
                                children: [
                                  Text("Son abonelik kullanım tarihi", style: Constants.kTextStyle.copyWith(
                                      fontWeight: FontWeight.w600
                                  ),),
                                  SizedBox(width: 10.w,),
                                  user.isUserPremium ? Image.asset("assets/icons/done.png", width: 20.w,)
                                  : Icon(Icons.cancel, color: Colors.redAccent),
                                ],
                              ),
                              SizedBox(height: 5.h,),
                              Text(
                                !user.isUserPremium ?
                                    "Abonelik bulunamadı"
                                    :
                                DateFormat('dd.MM.yyyy - hh.mm').format(DateTime.fromMillisecondsSinceEpoch(
                                  user.subscriptionDate!)), style: Constants.kTextStyle.copyWith(
                                fontSize: 18.w
                              ),)
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h,),
                  FutureBuilder(
                    future: init(),
                    builder: (context, snapshot) {
                      try {
                        if(!snapshot.hasData) return const LoadingWidget();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Abonelik Paketleri", style: Constants.kTitleTextStyle.copyWith(
                                fontSize: 22.5.w
                            ),),
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await Purchases.purchasePackage(
                                        snapshot.data!.all["monthly"]!
                                            .availablePackages[0]
                                    );

                                    marketWatch.extendSubscriptionDate(user.uid!, const Duration(days: 30));

                                  },
                                  child: Container(
                                    width: 150.w, height: 170.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [

                                            Constants.kSixthColor.withOpacity(.1),
                                            Constants.kSixthColor.withOpacity(.5),
                                            Constants.kSixthColor.withOpacity(.7),
                                            Constants.kSixthColor.withOpacity(.5),
                                            Constants.kSixthColor.withOpacity(.1),
                                          ],
                                          begin: Alignment.topLeft, end: Alignment.bottomRight
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("1 Aylık Abonelik", style:
                                              Constants.kTextStyle.copyWith(
                                                fontSize: 17.w, fontWeight: FontWeight.bold
                                              ), textAlign: TextAlign.center,),
                                            Image.asset("assets/logo.png", width: 75.w,),
                                            Text(snapshot.data!.all["monthly"]!
                                                .availablePackages[0].storeProduct.priceString, style:
                                            Constants.kTitleTextStyle.copyWith(
                                            fontSize: 17.5.w, color: Constants.kSecondColor
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Purchases.purchasePackage(
                                        snapshot.data!.all["monthly"]!
                                            .availablePackages[1]
                                    );

                                    marketWatch.extendSubscriptionDate(user.uid!, const Duration(days: 90));

                                  },
                                  child: Container(
                                    width: 150.w, height: 170.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [

                                            Constants.kSixthColor.withOpacity(.1),
                                            Constants.kSixthColor.withOpacity(.5),
                                            Constants.kSixthColor.withOpacity(.7),
                                            Constants.kSixthColor.withOpacity(.5),
                                            Constants.kSixthColor.withOpacity(.1),
                                          ],
                                          begin: Alignment.topLeft, end: Alignment.bottomRight
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("3 Aylık Abonelik", style:
                                              Constants.kTextStyle.copyWith(
                                                fontSize: 17.w, fontWeight: FontWeight.bold
                                              ), textAlign: TextAlign.center,),
                                            Image.asset("assets/logo.png", width: 75.w,),
                                            Text(snapshot.data!.all["monthly"]!
                                                .availablePackages[0].storeProduct.priceString, style:
                                            Constants.kTitleTextStyle.copyWith(
                                            fontSize: 17.5.w, color: Constants.kSecondColor
                                            ),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  await Purchases.purchasePackage(
                                      snapshot.data!.all["monthly"]!
                                          .availablePackages[2]
                                  );
                                  marketWatch.extendSubscriptionDate(user.uid!, const Duration(days: 365));
                                  //TODO update in subscription date
                                },
                                child: Container(
                                  width: 250.w, height: 170.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        colors: [

                                          Constants.kSixthColor.withOpacity(.1),
                                          Constants.kSixthColor.withOpacity(.5),
                                          Constants.kSixthColor.withOpacity(.7),
                                          Constants.kSixthColor.withOpacity(.5),
                                          Constants.kSixthColor.withOpacity(.1),
                                        ],
                                        begin: Alignment.topLeft, end: Alignment.bottomRight
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Yıllık Abonelik", style:
                                          Constants.kTextStyle.copyWith(
                                              fontSize: 17.w, fontWeight: FontWeight.bold
                                          ), textAlign: TextAlign.center,),
                                          Image.asset("assets/logo.png", width: 75.w,),
                                          Text(snapshot.data!.all["monthly"]!
                                              .availablePackages[2].storeProduct.priceString, style:
                                          Constants.kTitleTextStyle.copyWith(
                                              fontSize: 17.5.w, color: Constants.kSecondColor
                                          ),),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        );
                      }
                      catch (E) {
                        debugPrint(E.toString());
                        return const AppErrorWidget();
                      }
                    },
                  ),

                ],

              ),
            ),
          ),
        )
      ),
    );
  }

  Future<Offerings> init() async {
    Offerings offerings = await Purchases.getOfferings();
    customerInfo = await Purchases.getCustomerInfo();

    debugPrint("Offerings: $offerings");
    debugPrint("CustomerInfo: $customerInfo");

    // state = state.copyWith(
    //   customerInfo: customerInfo,
    //   offerings: offerings
    // );

    if (Platform.isIOS) {
      List<StoreProduct> products = await Purchases.getProducts([
        "pararix20",
        "pararix50",
        "pararix100",
        "pararix300",
        "pararix600",
        "pararix1000",
      ]);

      //state = state.copyWith(products: products);
    }
    debugPrint("Tokens initialized");
    return offerings;
  }
}
