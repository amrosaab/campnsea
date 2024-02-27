import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../setting_card_widget.dart';

class SettingStyleFlatWidget extends StatelessWidget {
  const SettingStyleFlatWidget({
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
      style: SettingItemStyle.flat,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            color: iconColor?.withOpacity(0.1) ??
                Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: leading,
        ),
        title: title,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
