import 'package:flutter/material.dart';

import '../../../../../common/constants.dart';
import '../setting_card_widget.dart';

class SettingStyleListTileCardWidget extends StatelessWidget {
  const SettingStyleListTileCardWidget({
    super.key,
    this.iconColor,
    this.leading,
    this.title,
    this.trailing,
    this.onTap,
    required this.showDivider,
    this.colorCard,
  });

  final Color? colorCard;
  final Color? iconColor;
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;
  final bool showDivider;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingCardWidget(
          colorCard: colorCard,
          style: SettingItemStyle.listTile,
          child: ListTile(
            leading: leading,
            title: title,
            trailing: trailing,
            onTap: onTap,
          ),
        ),
        if (showDivider)
          const Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
      ],
    );
  }
}
