import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/user.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/service_config.dart';
import 'setting_item/setting_item_widget.dart';

/// Render the Admin Vendor Menu.
/// Currently support WCFM & Dokan. Will support WooCommerce soon.
class SettingVendorAdminWidget extends StatelessWidget {
  const SettingVendorAdminWidget({
    super.key,
    required this.user,
    this.cardStyle,
  });

  final User? user;
  final SettingItemStyle? cardStyle;

  @override
  Widget build(BuildContext context) {
    var isVendor = user?.isVender ?? false;

    if (!isVendor || !ServerConfig().isVendorType()) {
      return const SizedBox();
    }

    return SettingItemWidget(
      cardStyle: cardStyle,
      onTap: () {
        FluxNavigate.pushNamed(
          RouteList.vendorAdmin,
          arguments: user,
          forceRootNavigator: true,
        );
      },
      icon: Icons.dashboard,
      title: S.of(context).vendorAdmin,
    );
  }
}
