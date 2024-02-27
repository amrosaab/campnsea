import 'package:flutter/material.dart';

class SettingStyleListTileWidget extends StatelessWidget {
  const SettingStyleListTileWidget({
    super.key,
    this.title,
    this.onTap,
    this.iconColorTile,
    this.textStyleTile,
    this.icon,
  });

  final IconData? icon;
  final String? title;

  final Color? iconColorTile;
  final TextStyle? textStyleTile;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColorTile ?? Theme.of(context).colorScheme.secondary,
      ),
      title: Text(
        title ?? '',
        style: textStyleTile ?? const TextStyle(fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
