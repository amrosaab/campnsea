import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/config/models/onboarding_config.dart';
import '../../models/app_model.dart';
import '../home/change_language_mixin.dart';
import '../onboarding/onboarding_mixin.dart';
import 'widgets/version1/onboarding_v1.dart';
import 'widgets/version2/onboarding_v2.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({
    super.key,
  });

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with ChangeLanguage, OnBoardingMixin {
  // Priority read config.json
  OnBoardingConfig get config =>
      Provider.of<AppModel>(context).appConfig?.onBoardingConfig ??
      kOnBoardingConfig;

  @override
  Widget build(BuildContext context) {
    if (config.version == 1) {
      return OnBoardingV1(config: config);
    }
    return OnBoardingV2(config: config);
  }
}
