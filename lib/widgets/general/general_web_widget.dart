import 'package:flutter/material.dart';
import 'package:inspireui/icons/icon_picker.dart';
import 'package:provider/provider.dart';

import '../../common/config.dart';
import '../../common/config/models/general_setting_item.dart';
import '../../common/constants.dart';
import '../../generated/l10n.dart';
import '../../models/user_model.dart';
import '../../screens/settings/widgets/setting_item/setting_item_widget.dart';
import '../common/webview.dart';
import 'general_widget.dart';

class GeneralWebWidget extends GeneralWidget {
  const GeneralWebWidget({
    required GeneralSettingItem? item,
    Color? iconColor,
    TextStyle? textStyle,
    bool useTile = false,
    Function()? onNavigator,
    super.cardStyle,
  }) : super(
          item: item,
          iconColor: iconColor,
          textStyle: textStyle,
          useTile: useTile,
          onNavigator: onNavigator,
        );

  @override
  Widget build(BuildContext context) {
    return Selector<UserModel, bool>(
      selector: (context, model) => model.loggedIn,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, value, child) {
        var user = Provider.of<UserModel>(context, listen: false).user;
        var icon = Icons.error;
        String title;
        Widget trailing;
        Function() onTap = () {};
        title = item?.title ?? S.of(context).dataEmpty;
        trailing =
            const Icon(Icons.arrow_forward_ios, size: 18, color: kGrey600);
        var webUrl = item?.webUrl;
        if (item?.requiredLogin ?? false) {
          if (!value) return const SizedBox();
          var base64Str = EncodeUtils.encodeCookie(user!.cookie!);
          webUrl = '$webUrl?cookie=$base64Str';
        }

        if (item != null) {
          icon = iconPicker(item!.icon, item!.iconFontFamily) ?? Icons.error;
          onTap = () {
            if (item?.webViewMode ?? false) {
              onPushScreen(
                WebView(
                  url: webUrl,
                  title: title,
                  enableBackward: item?.enableBackward ?? false,
                  enableForward: item?.enableForward ?? false,
                  enableClose: item?.enableClose ?? false,
                  script: (item?.script?.isEmptyOrNull ?? true)
                      ? kAdvanceConfig.webViewScript
                      : item?.script ?? '',
                ),
              );
            } else {
              onLaunch(webUrl);
            }
          };
        }

        return SettingItemWidget(
          icon: icon,
          title: title,
          onTap: onTap,
          trailing: trailing,
          useTile: useTile,
          cardStyle: cardStyle,
          iconColorTile: iconColor,
          textStyleTile: textStyle,
        );
      },
    );
  }
}
