import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:simply_qibla/constants/constants.dart';
import 'package:simply_qibla/helpers/shared_preferences_helper.dart';
import 'package:simply_qibla/pages/map_page.dart';
import 'package:simply_qibla/styles/style.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final GlobalKey<IntroductionScreenState> introKey =
      GlobalKey<IntroductionScreenState>();

  Future<void> _onIntroEnd(BuildContext context) async {
    setOnboardingStatus(true);
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<dynamic>(builder: (_) => const MapPage()),
      );
    }
  }

  Widget _buildImage(String assetName, [double dim = 350]) {
    return Image.asset(
      'assets/$assetName',
      width: dim,
      height: dim,
      semanticLabel: 'Welcome screen illustration',
    );
  }

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: Colors.white,
          ),
      bodyTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.white,
          ),
      bodyPadding: const EdgeInsets.symmetric(horizontal: AppPadding.standard),
      imagePadding: const EdgeInsets.all(AppPadding.standard),
      imageFlex: 2,
    );

    return IntroductionScreen(
      key: introKey,
      allowImplicitScrolling: true,
      pages: <PageViewModel>[
        PageViewModel(
          title: AppStrings.onboardingUsageTitle,
          body: AppStrings.onboardingUsageBody,
          image: _buildImage('illustrations/usage-illustration.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppStrings.onboardingLocationTitle,
          body: AppStrings.onboardingLocationBody,
          image: _buildImage('illustrations/location-illustration.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: AppStrings.onboardingSupportTitle,
          body: AppStrings.onboardingSupportBody,
          image: _buildImage('illustrations/support-illustration.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () async => _onIntroEnd(context),
      onSkip: () async => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      // dotsFlex: 4,
      skip: Text(
        'Skip',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primaryContainer,
        semanticLabel: 'Next page',
      ),
      done: Text(
        'Done',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsPadding: const EdgeInsets.only(
        left: AppPadding.standard,
        top: AppPadding.standard,
        right: AppPadding.standard,
        bottom: AppPadding.bottomNav,
      ),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Colors.white,
        activeSize: const Size(22.0, 10.0),
        activeColor: Theme.of(context).colorScheme.primaryContainer,
        activeShape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(AppDimensions.borderRadiusXl)),
        ),
      ),
    );
  }
}
