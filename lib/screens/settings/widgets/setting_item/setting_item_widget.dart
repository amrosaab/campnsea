import 'package:flutter/material.dart';

import '../../../../common/constants.dart';
import 'styles/setting_style_flat.dart';
import 'styles/setting_style_flat_list_tile.dart';
import 'styles/setting_style_flat_shadow.dart';
import 'styles/setting_style_list_tile_card_widget.dart';
import 'styles/setting_style_list_tile_widget.dart';

class SettingItemWidget extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final String? title;
  final Widget? titleWidget;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool useTile;
  final Color? iconColorTile;
  final Color? iconColor;

  final TextStyle? textStyleTile;
  final SettingItemStyle? cardStyle;

  /// Current only use for [SettingItemStyle.listTile]
  final bool? showDivider;

  /// Current only use for [SettingItemStyle.listTile]
  final Color? colorCard;

  const SettingItemWidget({
    Key? key,
    this.icon,
    this.iconWidget,
    this.title,
    this.titleWidget,
    this.trailing,
    this.onTap,
    this.useTile = false,
    this.showDivider,
    this.iconColorTile,
    this.textStyleTile,
    this.iconColor,
    this.cardStyle,
    this.colorCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = cardStyle ?? kItemProfileTypeDefault;
    final titleWd = title != null
        ? Text(
            title!,
            style: const TextStyle(fontSize: 16),
          )
        : titleWidget;

    final trailingWd = trailing ??
        const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: kGrey600,
        );
    final leadingWd = icon != null
        ? Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          )
        : iconWidget;

    if (useTile) {
      return SettingStyleListTileWidget(
        title: title,
        icon: icon,
        iconColorTile: iconColorTile,
        textStyleTile: textStyleTile,
        onTap: onTap,
      );
    }

    switch (type) {
      case SettingItemStyle.flat:
        return SettingStyleFlatWidget(
          leading: leadingWd,
          onTap: onTap,
          title: titleWd,
          trailing: trailingWd,
          iconColor: iconColor,
        );
      case SettingItemStyle.flatShadow:
        return SettingStyleFlatShadowWidget(
          leading: leadingWd,
          onTap: onTap,
          title: titleWd,
          trailing: trailingWd,
          iconColor: iconColor,
        );
      case SettingItemStyle.flatListTile:
        return SettingStyleFlatListTileWidget(
          leading: leadingWd,
          onTap: onTap,
          title: titleWd,
          trailing: trailingWd,
          iconColor: iconColor,
        );
      case SettingItemStyle.listTile:
      default:
        return SettingStyleListTileCardWidget(
          leading: leadingWd,
          colorCard: colorCard,
          onTap: onTap,
          title: titleWd,
          showDivider: showDivider ?? true,
          trailing: trailingWd,
          iconColor: iconColor,
        );
    }
  }
}
