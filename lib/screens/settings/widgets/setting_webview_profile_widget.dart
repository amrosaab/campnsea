import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/user.dart';
import '../../../services/service_config.dart';
import '../../../widgets/common/index.dart';
import 'setting_item/setting_item_widget.dart';

/// Render the custom profile link via Webview
/// Example show some special profile on the woocommerce site: wallet, wishlist...
class WebViewProfileWidget extends StatelessWidget {
  const WebViewProfileWidget({
    super.key,
    required this.user,
    required this.cartStyle,
  });

  final User? user;
  final SettingItemStyle cartStyle;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const SizedBox();
    }

    return SettingItemWidget(
      cardStyle: cartStyle,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebView(
              auth: true,
              url: '${ServerConfig().url}/my-account',
              title: S.of(context).updateUserInfor,
            ),
          ),
        );
      },
      icon: CupertinoIcons.profile_circled,
      title: S.of(context).updateUserInfor,
    );
  }
}
