import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constants.dart';
import '../../../generated/l10n.dart';
import '../../../models/entities/user.dart';
import '../../../routes/flux_navigate.dart';
import '../../../services/services.dart';
import 'setting_item/setting_item_widget.dart';

/// Render the Delivery Menu.
/// Currently support WCFM
class SettingDeliveryBoyWidget extends StatelessWidget {
  const SettingDeliveryBoyWidget({
    super.key,
    required this.user,
    this.cardStyle,
  });

  final SettingItemStyle? cardStyle;
  final User? user;

  @override
  Widget build(BuildContext context) {
    var isDelivery = user?.isDeliveryBoy ?? false;

    if (!isDelivery) {
      return const SizedBox();
    }

    return SettingItemWidget(
      onTap: () {
        FluxNavigate.push(
          MaterialPageRoute(
            builder: (context) =>
                Services().widget.getDeliveryScreen(context, user)!,
          ),
          forceRootNavigator: true,
        );
      },
      icon: CupertinoIcons.cube_box,
      cardStyle: cardStyle,
      title: S.of(context).deliveryManagement,
    );
  }
}
