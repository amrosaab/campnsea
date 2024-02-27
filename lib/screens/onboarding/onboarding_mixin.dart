import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart' as config;
import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/tools/navigate_tools.dart';
import '../../data/boxes.dart';
import '../../models/notification_model.dart';
import '../../services/services.dart';

mixin OnBoardingMixin<T extends StatefulWidget> on State<T> {
  final isRequiredLogin = config.kLoginSetting.isRequiredLogin;
  int page = 0;

  NotificationModel get _notificationModel =>
      Provider.of<NotificationModel>(context, listen: false);

  void setHasSeen() {
    SettingsBox().hasFinishedOnboarding = true;
  }

  void onTapSignIn() {
    setHasSeen();
    NavigateTools.navigateToLogin(context, replacement: true);
  }

  void onTapDone() async {
    if (Services().widget.isRequiredLogin) {
      await NavigateTools.navigateToLogin(
        context,
        replacement: true,
      );
      return;
    }
    if ((Configurations.multiSiteConfigs?.isNotEmpty ?? false) &&
        kAdvanceConfig.isRequiredSiteSelection) {
      await Navigator.of(context).pushNamed(RouteList.multiSiteSelection);
      SettingsBox().hasSelectedSite = true;
    }
    if (SettingsBox().hasFinishedOnboarding) {
      await Navigator.pushReplacementNamed(context, RouteList.dashboard);
      return;
    }
    setHasSeen();

    if (kAdvanceConfig.showRequestNotification) {
      await Navigator.of(context)
          .pushReplacementNamed(RouteList.notificationRequest);
      return;
    }
    await _notificationModel.enableNotification();
    if (kAdvanceConfig.gdprConfig.showPrivacyPolicyFirstTime) {
      await Navigator.of(context).pushReplacementNamed(
        RouteList.privacyTerms,
      );
    } else {
      await Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
    }
  }
}
