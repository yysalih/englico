import 'package:englico/repository/shared_preferences_repository.dart';
import 'package:englico/views/language_level_view.dart';
import 'package:englico/widgets/status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_animation/weather_animation.dart';
import '../controllers/main_controller.dart';
import '../utils/contants.dart';
import '../widgets/app_navigation_bar.dart';

class MainView extends ConsumerWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final mainWatch = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    final language = ref.watch(languageLevelProvider);

    return Scaffold(
      //backgroundColor: Constants.kFifthColor.withOpacity(.1),
      body: SafeArea(
          child: language.when(
            loading: () => const LoadingWidget(),
            data: (level) => level == "" ? mainState.languageLevel != "" ?
            mainWatch.pages[mainState.bottomIndex] :
            const LanguageLevelView()
                : mainWatch.pages[mainState.bottomIndex],
            error: (error, stackTrace) => const AppErrorWidget(),
          )
      ),
      bottomNavigationBar:
      language.when(
        loading: () => null,
        data: (level) => level == "" ? mainState.languageLevel != "" ? const AppBottomBar() :
        null : const AppBottomBar(),
        error: (error, stackTrace) => null
      ),
    );
  }
}
