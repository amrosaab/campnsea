import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../setting_card_widget.dart';

class SettingStyleFlatShadowWidget extends StatelessWidget {
  const SettingStyleFlatShadowWidget({
    super.key,
    this.iconColor,
    required this.leading,
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  final Color? iconColor;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return SettingCardWidget(
      style: SettingItemStyle.flatShadow,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            child: leading,
          ),
          title: title,
          trailing: trailing,
          onTap: onTap,
        ),
      ),
    );
  }
}
