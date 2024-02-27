import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/config/models/general_setting_item.dart';
import '../../common/constants.dart';
import '../../common/tools/navigate_tools.dart';
import '../../common/tools/tools.dart';
import '../../generated/l10n.dart';
import '../../models/entities/product.dart';
import '../../routes/flux_navigate.dart';
import '../../screens/settings/widgets/setting_item/setting_item_widget.dart';

abstract class GeneralWidget extends StatelessWidget {
  final bool useTile;
  final Color? iconColor;
  final TextStyle? textStyle;
  final GeneralSettingItem? item;
  final SettingItemStyle? cardStyle;
  final void Function()? onNavigator;

  const GeneralWidget({
    required this.item,
    this.iconColor,
    this.textStyle,
    this.useTile = false,
    this.onNavigator,
    this.cardStyle,
  });

  void onTapNavigateOptions({
    BuildContext? context,
    required Map config,
    List<Product>? products,
  }) {
    onNavigator?.call();
    NavigateTools.onTapNavigateOptions(
      config: config,
      context: context,
      products: products,
    );
  }

  void onPushScreen(Widget screen) {
    onNavigator?.call();
    FluxNavigate.push(MaterialPageRoute(builder: (context) => screen));
  }

  void onLaunch(String? webUrl) {
    Tools.launchURL(
      webUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  void onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    var icon = Icons.error;
    String title;
    Widget trailing;
    title = item?.title ?? S.of(context).dataEmpty;
    trailing = const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
    if (item != null) {
      icon = iconPicker(item!.icon, item!.iconFontFamily) ?? Icons.error;
    }
    if (useTile) {
      return ListTile(
        leading: Icon(
          icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: textStyle,
        ),
        onTap: () => onTap(context),
      );
    }

    return SettingItemWidget(
      onTap: () => onTap(context),
      icon: icon,
      title: title,
      trailing: trailing,
      useTile: useTile,
      iconColorTile: iconColor,
      textStyleTile: textStyle,
      cardStyle: cardStyle,
    );
  }
}
