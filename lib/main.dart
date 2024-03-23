import 'dart:io';
import 'package:englico/controllers/main_controller.dart';
import 'package:englico/controllers/speak_controller.dart';
import 'package:englico/utils/contants.dart';
import 'package:englico/views/auth_view.dart';
import 'package:englico/views/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initPlatformState();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  @override
  void initState() {
    final mainRead = ref.read(mainController.notifier);
    final speakRead = ref.read(speakController.notifier);
    mainRead.configureTts();
    speakRead.initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_ , child) {
        return MaterialApp(
          title: Constants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: "Roboto",
            colorScheme: ColorScheme.fromSeed(seedColor: Constants.kPrimaryColor),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: AuthView(),
    );
  }
}

Future<void> initPlatformState() async {
  await Purchases.setLogLevel(LogLevel.debug);

  PurchasesConfiguration configuration;
  if (Platform.isAndroid) {
    configuration = PurchasesConfiguration("goog_dpoBxplwuhhWHiLMWqpjIPzoPPG");
  } else {
    configuration = PurchasesConfiguration("appl_JwuzbEJLSKXNThSpMvsczbAYlML");
  }
  // await Purchases.setup(
  //     Platform.isAndroid
  //         ? "goog_kyaPycIcQaxOPAvSerTwZLZygGZ"//"sk_KaSRHBMpOTsUcbZYiRmcixcHiOLSF"
  //         : "appl_yqNpQGmYVkOfzndhlJmRcccHODP",
  //     usesStoreKit2IfAvailable: true,
  //     observerMode: false);
  await Purchases.configure(configuration);
}