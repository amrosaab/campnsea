import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import 'views/setting_layout_nomarl_widget.dart';
import 'views/setting_layout_style01_widget.dart';

extension SettingStyleExt on SettingStyle {
  Widget builder(DataSettingScreen dataSettings) {
    switch (this) {
      case SettingStyle.style01:
        return SettingLayoutStyle01Widget(dataSettings: dataSettings);
      case SettingStyle.normal:
      default:
        return SettingLayoutNormalWidget(dataSettings: dataSettings);
    }
  }
}

class DataSettingScreen {
  final List<dynamic> settings;
  final Map? subGeneralSetting;
  final String? background;
  final Map? drawerIcon;
  final bool hideUser;
  final bool? showBackground;
  final SettingItemStyle cardStyle;
  final SettingStyle settingStyle;

  const DataSettingScreen({
    required this.settings,
    this.subGeneralSetting,
    this.background,
    this.drawerIcon,
    this.hideUser = false,
    this.showBackground,
    required this.cardStyle,
    required this.settingStyle,
  });
}
