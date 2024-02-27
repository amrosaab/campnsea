import 'package:flutter/material.dart';

import '../../common/config.dart';
import '../../common/constants.dart';
import 'layouts/setting_builder_layout.dart';

class SettingScreen extends StatefulWidget {
  final List<dynamic>? settings;
  final Map? subGeneralSetting;
  final String? background;
  final Map? drawerIcon;
  final bool hideUser;
  final bool? showBackground;
  final String? cardStyle;
  final String? settingStyle;

  const SettingScreen({
    this.settings,
    this.subGeneralSetting,
    this.background,
    this.drawerIcon,
    this.hideUser = false,
    this.showBackground,
    this.cardStyle,
    this.settingStyle,
  });

  @override
  SettingScreenState createState() {
    return SettingScreenState();
  }
}

class SettingScreenState extends State<SettingScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<SettingScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final settingStyle = SettingStyle.fromString(widget.settingStyle);
    final cardStyle = SettingItemStyle.fromString(widget.cardStyle);
    final backgroundColor = cardStyle.backgroundColor(context);

    final data = DataSettingScreen(
      settings: widget.settings ?? kDefaultSettings,
      subGeneralSetting: widget.subGeneralSetting,
      background: widget.background,
      drawerIcon: widget.drawerIcon,
      hideUser: widget.hideUser,
      showBackground: widget.showBackground,
      cardStyle: cardStyle,
      settingStyle: settingStyle,
    );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: settingStyle.builder(data),
    );
  }
}
